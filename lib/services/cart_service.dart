import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/cart_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/services/product_service.dart';

import '../repository/repository_interface.dart';

abstract class CartService extends Service {
  Future<List<ProductModel>> getCart({required String userId});
  Future<void> update(String id, List<ProductModel> products);
}

class CartServiceIml implements CartService {
  Repository<CartModel> repository;
  CartServiceIml({required this.repository});

  @override
  Future<List<ProductModel>> getCart({required String userId}) async {
    final products = <ProductModel>[];
    final carts = await repository.list();
    final model = carts.firstWhere((cart) => cart.uid == userId);
    final cartData = model.cart;
    for (var prodRef in cartData.values) {
      final prodData =
          await (prodRef as DocumentReference<Map<String, dynamic>>).get();
      products.add(ProductModel.fromJson(prodData.data()!));
    }
    return products;
  }

  @override
  Future<void> update(String uid, List<ProductModel> products) async {
    final map = <String, dynamic>{};
    for (int i = 0; i < products.length; i++) {
      map.addAll({'product${i + 1}': products[i].name});
    }
    final cart = CartModel(
      uid: uid,
      cart: map,
    );
    final docID = await repository.getDocumentID(uid);
    repository.update(docID, cart);
  }
}
