
import 'package:ecommerce_app/model/cart_item.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/services/cart_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({
    required this.service,
  }) : super(CartInitial());

  CartService service;
  List<CartItem>? cartItems;

  Future<void> getCart() async {
    // if (cartItems == null) {
      emit(CartLoading());
      // try {
        final pfres = await SharedPreferences.getInstance();
        final uid = pfres.getString('uid');
        cartItems = await service.getCart(userId: uid!);
        emit(CartLoaded(items: cartItems!));
      // } catch (error) {
        // log('error', error: error);
      // }
      // emit(CartInitial());
    // } else {
      // emit(CartLoaded(items: cartItems!));
    // }
  }

  void onItemTap(ProductModel product) {
    emit(CartDetail(product));
  }

  Future<bool> addItem(CartItem item) async {
    if (cartItems == null) {
      final pfres = await SharedPreferences.getInstance();
      final uid = pfres.getString('uid');
      cartItems = await service.getCart(userId: uid!);
    }
    //check duplicate
    await item.build();
    for (var element in cartItems!) {
      if (element.color == item.color &&
          element.memory == item.memory &&
          element.product!.name == item.product!.name) {
        return false;
      }
    }
    cartItems!.add(item);
    await service.addCartItem(item);
    emit(CartLoaded(items: cartItems!));
    return true;
  }

  Future<void> removeItem(CartItem item) async {
    await service.removeItem(item);
    cartItems?.remove(item);
    emit(CartLoaded(items: cartItems!));
  }

  Future<void> removeAllCartItem() async {
    if (cartItems == null) return;
    for (var item in cartItems!) {
      await service.removeItem(item);
    }
    cartItems?.clear();
    emit(CartLoaded(items: cartItems!));
  }

  void dispose() {
    cartItems = null;
  }

  Future<void> refresh() async {
    emit(CartLoading());
    dispose();
    getCart();
  }

  Future<bool> updateCartItem(CartItem item) async {
    final result = await service.update(item.id, item);
    if (!result) return false;
    cartItems = cartItems!.map((element) {
      if (element.id == item.id) {
        return item;
      }
      return element;
    }).toList();
    getCart();
    return true;
  }

  void onOrdering() {
    emit(CartLoading());
  }

  bool checkOutOfProducts() {
    if (cartItems != null) {
      return cartItems!.any((item) => item.product!.isOutOf == true);
    }
    return false;
  }
}
