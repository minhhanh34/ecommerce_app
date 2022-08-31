import 'package:ecommerce_app/model/cart_model.dart';
import 'package:ecommerce_app/services/cart_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({required this.service}) : super(CartInitial());
  final CartService service;

  void getCart({required String uid}) async {
    emit(CartLoading());
    CartModel model = await service.getCart(userId: 'user1');
    emit(CartLoaded(model: model));
  }
}
