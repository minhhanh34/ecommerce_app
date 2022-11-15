// ignore_for_file: must_be_immutable

import 'package:ecommerce_app/model/cart_item.dart';
import 'package:ecommerce_app/model/order_model.dart';
import 'package:ecommerce_app/utils/alert_dialog.dart';
import 'package:ecommerce_app/utils/generator.dart';
import 'package:ecommerce_app/utils/libs.dart';
import 'package:ecommerce_app/utils/price_format.dart';

import '../widgets/cart_list_tile.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Future<void> dismiss(CartItem item) async {
    context.read<CartCubit>().removeItem(item);
  }

  int totalPrice(List<CartItem> items) {
    int total = 0;
    for (var item in items) {
      total += item.price * item.quantity;
    }
    return total;
  }
  // bool checkBoxValue = false;

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    final cartCubit = context.read<CartCubit>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      //drawer: MyDrawer(homeCubit: context.read<HomeCubit>()),
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartInitial) {
            context.read<CartCubit>().getCart();
            return buildLoading();
          }
          if (state is CartLoading) {
            return buildLoading();
          }
          if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add_shopping_cart_rounded,
                      color: Colors.red,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Bạn chưa có sản phẩm nào trong vỏ hàng',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                const SizedBox(height: 8.0),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => context.read<CartCubit>().refresh(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        return CartListTile(state.items[index]);
                      },
                    ),
                  ),
                ),
                // const Divider(color: Colors.white),
                SizedBox(
                  width: double.infinity,
                  height: 56.0,
                  child: Row(
                    children: [
                      const SizedBox(width: 8.0),
                      Text(
                        'Tổng cộng: ${PriceHealper.format(totalPrice(state.items))}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          bool isOutOfProducts = cartCubit.checkOutOfProducts();
                          if (isOutOfProducts) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const CustomAlertDialog(
                                    title: 'Hết hàng',
                                    content: 'Một số sản phẩm đã hết hàng!',
                                    actions: ['Ok'],
                                  );
                                });
                            return;
                          }
                          bool confirm = await showDialog(
                            context: context,
                            builder: (context) {
                              return CustomAlertDialog(
                                title: 'Xác nhận',
                                content:
                                    'Xác nhận đặt ${state.items.length} sản phẩm',
                              );
                            },
                          );
                          if (!confirm) return;
                          cartCubit.onOrdering();
                          final spref = await SharedPreferences.getInstance();
                          final uid = spref.getString('uid');
                          final user = homeCubit.user ??=
                              await homeCubit.getUserInfo(uid!);
                          final order = OrderModel(
                            uid: state.items[0].uid,
                            order: state.items
                                .map((item) => item.toJson())
                                .toList(),
                            date: DateTime.now(),
                            id: Generator.generateString(),
                            status: 'Chờ xác nhận',
                            address: user.address,
                            recipient: user.name,
                          );
                          await homeCubit.addOrder(order);
                          await cartCubit.removeAllCartItem();
                          scaffoldMessenger
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: const Text('Đặt hàng thành công!'),
                                action: SnackBarAction(
                                  label: 'Xem đơn hàng',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (_) => const HomePage(),
                                      ),
                                      (_) => false,
                                    );
                                    int orderTabIndex = 2;
                                    context
                                        .read<HomeCubit>()
                                        .onNavTap(orderTabIndex);
                                  },
                                ),
                              ),
                            );
                        },
                        child: const Text(
                          'Đặt hàng',
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                    ],
                  ),
                )
              ],
            );
          }
          if (state is CartLoading) {
            return buildLoading();
          }
          return const SizedBox();
        },
      ),
    );
  }
}
