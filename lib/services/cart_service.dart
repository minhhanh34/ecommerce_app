import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/cart_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/repository/product_repository.dart';
import 'package:ecommerce_app/services/firebase_service.dart';

abstract class CartService extends Service {
  Future<List<ProductModel>> getCart({required String userId});
}

class CartServiceIml implements CartService {
  Repository<CartModel> repository;

  CartServiceIml({required this.repository});

  @override
  Future<List<ProductModel>> getCart({required String userId}) async {
    final products = <ProductModel>[];
    final model = await repository.getOne(userId);
    final cart = model.cart;
    for (var prodRef in cart.values) {
      final prodData =
          await (prodRef as DocumentReference<Map<String, dynamic>>).get();
      products.add(ProductModel.fromJson(prodData.data()!));
    }
    return products;
  }
}
