import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/services/cart_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({required this.service}) : super(CartInitial());
  final CartService service;

  final collection = 'cart';

  void getCart() async {
    emit(CartLoading());
    final pfres = await SharedPreferences.getInstance();
    final uid = pfres.getString('uid');
    final products = await service.getCart(userId: uid!);
    emit(CartLoaded(products: products));
  }

  void onItemTap(ProductModel product) {
    emit(CartDetail(product));
  }
}
