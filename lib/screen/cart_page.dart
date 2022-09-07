import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/screen/product_page.dart';
import 'package:ecommerce_app/utils/price_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cart/cart_cubit.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key, required this.products}) : super(key: key);
  final List<ProductModel> products;
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
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
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                return Row(
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
                              child: state.products[index].images['image1']!,
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
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
