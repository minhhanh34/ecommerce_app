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

  List<ProductModel>? products;

  Future<void> getCart() async {
    if (products == null) {
      emit(CartLoading());
      final pfres = await SharedPreferences.getInstance();
      final uid = pfres.getString('uid');
      products = await service.getCart(userId: uid!);
      emit(CartLoaded(products: products!));
    } else {
      emit(CartLoaded(products: products!));
    }
  }

  void onItemTap(ProductModel product) {
    emit(CartDetail(product));
  }

  void addItem(ProductModel item) async {
    if (products == null) {
      final pfres = await SharedPreferences.getInstance();
      final uid = pfres.getString('uid');
      products = await service.getCart(userId: uid!);
    }
    products!.add(item);
    final spref = await SharedPreferences.getInstance();
    final uid = spref.getString('uid');
    await service.update(uid!, products!);
  }

  void removeItem(ProductModel item) async {
    products?.remove(item);
    final spref = await SharedPreferences.getInstance();
    final uid = spref.getString('uid');
    await service.update(uid!, products!);
    emit(CartLoaded(products: products!));
  }
}
