import 'package:ecommerce_app/components/products_widget.dart';
import 'package:ecommerce_app/cubit/cart/cart_cubit.dart';
import 'package:ecommerce_app/model/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key, this.model}) : super(key: key);
  final CartModel? model;
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
        appBar: AppBar(
          title: const Text('Giỏ hàng'),
          centerTitle: true,
        ),
        body: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {},
          builder: (context, state) {
            // if (state is CartLoading) return buildLoading();
            if (state is CartInitial) {
              context.read<CartCubit>().getCart(uid: 'user1');
              return buildLoading();
            }
            if (state is CartLoading) {
              return buildLoading();
            }
            if (state is CartLoaded) {
              return ProductsWidget(products: state.model.products);
            }
            return buildLoading();
          },
        ));
  }
}
