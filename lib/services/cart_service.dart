import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/cart_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/services/home_service.dart';

import '../repository/repository_interface.dart';

abstract class CartService extends Service {
  Future<List<ProductModel>> getCart({required String userId});
  Future<bool> update(String id, List<ProductModel> products);
}

class CartServiceIml implements CartService {
  Repository<CartModel> cartRepository;
  Repository<ProductModel> prodRepository;
  CartServiceIml(this.cartRepository, this.prodRepository);

  @override
  Future<List<ProductModel>> getCart({required String userId}) async {
    final products = <ProductModel>[];
    final carts = await cartRepository.list();
    final model = carts.firstWhere((cart) => cart.uid == userId);
    final cartData = model.cart;
    for (var prodRef in cartData!.values) {
      final prodData =
          await (prodRef as DocumentReference<Map<String, dynamic>>).get();
      products.add(ProductModel.fromJson(prodData.data()!));
    }
    return products;
  }

  @override
  Future<bool> update(String uid, List<ProductModel> products) async {
    final map = <String, DocumentReference>{};
    for (int i = 0; i < products.length; i++) {
      final docSnap =
          await prodRepository.getQueryDocumentSnapshot(products[i].name);
      map.addAll({'product${i + 1}': docSnap.reference});
    }
    final cart = CartModel(
      uid: uid,
      cart: map,
    );
    final cartSnap = await cartRepository.getQueryDocumentSnapshot(uid);
    return await cartRepository.update(cartSnap.id, cart);
  }
}
