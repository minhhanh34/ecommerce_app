// ignore_for_file: must_be_immutable

import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/screen/product_page.dart';
import 'package:ecommerce_app/utils/price_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cart/cart_cubit.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key, required this.products}) : super(key: key);
  List<ProductModel> products;
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // Future<void> _onRefresh(BuildContext context) async {
  //   final cartCubit = context.read<CartCubit>();

  //   cartCubit.products = null;
  //   await cartCubit.getCart();
  // }

  Future<void> dismiss(ProductModel item) async {
    final cartCubit = context.read<CartCubit>();
    cartCubit.products!.remove(item);
  }

  @override
  Widget build(BuildContext context) {
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
          } else if (state is CartLoaded) {
            if (state.products.isEmpty) {
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
            return RefreshIndicator(
              onRefresh: () async => context.read<CartCubit>().refresh(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(state.products[index].name),
                    onDismissed: (_) => context
                        .read<CartCubit>()
                        .removeItem(state.products[index]),
                    child: Row(
                      children: [
                        Radio(
                            value: false,
                            groupValue: const [],
                            onChanged: (value) => value),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => ProductPage(
                                            product: state.products[index])),
                                  );
                                },
                                isThreeLine: true,
                                leading: Hero(
                                  tag: state.products[index].name,
                                  child:
                                      state.products[index].images['image1']!,
                                ),
                                title: Text(
                                  state.products[index].name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      PriceFormat.format(
                                          state.products[index].price),
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
                                        for (int i = 0;
                                            i < state.products[index].grade;
                                            i++)
                                          Icon(
                                            Icons.star_rounded,
                                            color: Colors.yellow.shade300,
                                          )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
