import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cart/cart_cubit.dart';
import '../cubit/home/home_cubit.dart';
import '../model/cart_item.dart';
import '../model/product_model.dart';
import '../screen/home_screen.dart';
import '../screen/product_screen.dart';
import '../utils/price_format.dart';

class CartListTile extends StatefulWidget {
  const CartListTile(this.item, {Key? key, required this.scaffoldKey})
      : super(key: key);
  final CartItem item;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  State<CartListTile> createState() => _CartListTileState();
}

class _CartListTileState extends State<CartListTile> {
  bool loadingBottomSheet = false;
  int selectColor = 0;
  int selectMemory = 0;
  int quantity = 1;
  bool navVisible = true;
  late PersistentBottomSheetController _controller;
  late CachedNetworkImage imageOption;

  @override
  void initState() {
    super.initState();
    imageOption = widget.item.product!.images['image1']!;
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  void chooseProductOption(ProductModel product) {
    displayBottomSheet(context, product);
  }

  void changeColor(ProductModel product, int i) {
    _controller.setState!(() {
      selectColor = i;
      imageOption = CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: product.colorOption[i]['imageURL'],
        placeholder: (context, url) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Icon(Icons.image),
          );
        },
      );
    });
  }

  void goToOrder() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final homeCubit = context.read<HomeCubit>();
    int orderTabIndex = 2;
    final route = MaterialPageRoute(builder: (_) => const HomeScreen());
    Navigator.of(context).pushAndRemoveUntil(route, (_) => false);
    homeCubit.onNavTap(orderTabIndex);
  }

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

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ObjectKey(widget.item),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.red,
        ),
        child: const Center(
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) {
            return const CustomAlertDialog(
              title: 'Xác nhận',
              content: 'Bạn có chắc muốn sản phẩm này ra khỏi giỏ hàng?',
            );
          },
        );
      },
      onDismissed: (_) => context.read<CartCubit>().removeItem(widget.item),
      child: Row(
        children: [
          const SizedBox(height: 8.0),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    isThreeLine: true,
                    leading: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) =>
                                  ProductScreen(product: widget.item.product!)),
                        );
                      },
                      child: SizedBox(
                        width: 80.0,
                        height: 80.0,
                        child: CachedNetworkImage(
                          imageUrl: widget.item.imageURL,
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Icon(Icons.image),
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      widget.item.product!.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: InkWell(
                      onTap: () => displayBottomSheet(
                        context,
                        widget.item.product!,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            PriceHealper.format(widget.item.price),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                          ),
                          Row(
                            children: [
                              const Text('Màu:'),
                              const SizedBox(width: 8.0),
                              CircleAvatar(
                                radius: 11.0,
                                backgroundColor: Colors.black45,
                                child: CircleAvatar(
                                  radius: 10.0,
                                  backgroundColor:
                                      Color(int.parse(widget.item.color)),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Bộ nhớ:'),
                              const SizedBox(width: 8.0),
                              Text(widget.item.memory),
                              const Spacer(),
                              Row(
                                children: [
                                  const Text('SL: '),
                                  InkWell(
                                    onTap: () async {
                                      if (widget.item.quantity <= 1) return;
                                      await context
                                          .read<CartCubit>()
                                          .updateCartItem(
                                            widget.item.copyWith(
                                              quantity: --widget.item.quantity,
                                            ),
                                          );
                                    },
                                    child: const Icon(Icons.remove_rounded),
                                  ),
                                  Text(widget.item.quantity.toString()),
                                  InkWell(
                                    onTap: () async {
                                      await context
                                          .read<CartCubit>()
                                          .updateCartItem(
                                            widget.item.copyWith(
                                              quantity: ++widget.item.quantity,
                                            ),
                                          );
                                    },
                                    child: const Icon(Icons.add_rounded),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void displayBottomSheet(BuildContext context, ProductModel product) {
    imageOption = CachedNetworkImage(imageUrl: widget.item.imageURL);
    selectColor = widget.item.product!.colorOption
        .indexWhere((option) => option['color'] == widget.item.color);
    selectMemory = widget.item.product!.memoryOption
        .indexWhere((option) => option['memory'] == widget.item.memory);
    quantity = widget.item.quantity;
    final textTheme = Theme.of(context).textTheme;
    _controller = widget.scaffoldKey.currentState!.showBottomSheet(
      backgroundColor: Colors.white,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.65,
      ),
      enableDrag: false,
      (context) {
        final cartCubit = context.read<CartCubit>();
        if (loadingBottomSheet) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            ListTile(
              onTap: () {
                _controller.close();
              },
              trailing: const Icon(Icons.close),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 90.0,
                          maxHeight: 90.0,
                        ),
                        child: imageOption,
                      ),
                      title: Text(product.name),
                      subtitle: Text(
                        PriceHealper.format(
                          (product.memoryOption.isNotEmpty)
                              ? product.memoryOption[selectMemory]['price']
                              : product.price,
                        ),
                        style:
                            textTheme.titleMedium?.copyWith(color: Colors.red),
                      ),
                    ),
                    Visibility(
                      visible: product.colorOption.isNotEmpty,
                      child: ListTile(
                        leading: const Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Text('Màu:'),
                        ),
                        title: Row(
                          children: [
                            for (int i = 0;
                                i < (product.colorOption.length);
                                i++)
                              InkWell(
                                onTap: () {
                                  changeColor(product, i);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: selectColor == i
                                        ? Color(
                                            int.parse(
                                              product.colorOption[i]['color'] !=
                                                      '0xffffffff'
                                                  ? product.colorOption[i]
                                                      ['color']
                                                  : '0xff000000',
                                            ),
                                          )
                                        : Colors.white,
                                    child: CircleAvatar(
                                      radius: 12.0,
                                      backgroundColor: selectColor == i
                                          ? product.colorOption[i]['color'] ==
                                                  '0xffffffff'
                                              ? Colors.white
                                              : null
                                          : Colors.white,
                                      child: CircleAvatar(
                                        radius: selectColor == i
                                            ? (product.colorOption[selectColor]
                                                        ['color'] ==
                                                    '0xffffffff'
                                                ? 9.0
                                                : 13.0)
                                            : 11.0,
                                        backgroundColor: selectColor == i
                                            ? (product.colorOption[selectColor]
                                                        ['color'] !=
                                                    '0xffffffff'
                                                ? Colors.white
                                                : Colors.black38)
                                            : Colors.black,
                                        child: CircleAvatar(
                                          radius: selectColor == i
                                              ? product.colorOption[i]
                                                          ['color'] ==
                                                      '0xffffffff'
                                                  ? 8.0
                                                  : 10.0
                                              : 10.0,
                                          backgroundColor: Color(
                                            int.parse(
                                              product.colorOption[i]['color'],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: product.memoryOption.isNotEmpty,
                      child: ListTile(
                        leading: const Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Text('Bộ nhớ:'),
                        ),
                        title: Wrap(
                          children: [
                            for (int i = 0;
                                i < (product.memoryOption.length);
                                i++)
                              InkWell(
                                onTap: () {
                                  _controller.setState!(() {
                                    selectMemory = i;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Chip(
                                    backgroundColor: selectMemory == i
                                        ? Colors.blue.shade100
                                        : Colors.white,
                                    label:
                                        Text(product.memoryOption[i]['memory']),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text('Số lượng:'),
                      ),
                      title: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              _controller.setState!(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.black,
                            ),
                          ),
                          Text(quantity.toString()),
                          IconButton(
                            onPressed: () {
                              _controller.setState!(() {
                                quantity++;
                              });
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Text('Tổng cộng:'),
                      title: Text(
                        PriceHealper.format(
                          (product.memoryOption.isNotEmpty)
                              ? (product.memoryOption[selectMemory]['price'] *
                                  quantity)
                              : (product.price * quantity),
                        ),
                        style: textTheme.titleLarge?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: () async {
                    _controller.setState!(() => loadingBottomSheet = true);
                    final cartItem = widget.item.copyWith(
                      color: product.colorOption[selectColor]['color'],
                      imageURL: product.colorOption[selectColor]['imageURL'],
                      memory: product.memoryOption[selectMemory]['memory'],
                      price: product.memoryOption[selectMemory]['price'],
                      quantity: quantity,
                    );
                    await cartCubit.updateCartItem(cartItem);
                    _controller.close();
                    loadingBottomSheet = false;
                  },
                  child: const Text('Ok'),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
