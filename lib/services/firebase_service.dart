import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/product_model.dart';

abstract class Service {}

abstract class ProductService extends Service {
  Future<List<ProductModel>?> getAllProducts();
  Future<ProductModel?> getProduct({required String prodID});
  Future<List<ProductModel>> getFavoritedProduct({required String userID});
}

class ProductServiceIml implements ProductService {
  const ProductServiceIml({required this.database});

  final FirebaseFirestore database;

  @override
  Future<List<ProductModel>?> getAllProducts() async {
    String collection = 'products';
    try {
      QuerySnapshot<Map<String, dynamic>> colRef =
          await database.collection(collection).get();
      return colRef.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        Map<String, dynamic> json = doc.data();
        return ProductModel.fromJson(json);
      }).toList();
    } catch (e) {
      log('error', error: e);
    }
    return [];
  }

  @override
  Future<ProductModel?> getProduct({required String prodID}) async {
    String collection = 'products';
    try {
      DocumentSnapshot<Map<String, dynamic>> docRef =
          await database.collection(collection).doc(prodID).get();
      Map<String, dynamic> json = docRef.data()!;
      return ProductModel.fromJson(json);
    } catch (e) {
      log('error', error: e);
    }
    return null;
  }

  @override
  Future<List<ProductModel>> getFavoritedProduct(
      {required String userID}) async {
    final products = <ProductModel>[];
    const String collection = 'favorite';
    final docs = await database.collection(collection).get();
    final doc =
        docs.docs.where((element) => element.data()['uid'] == userID).first;
    
    Map<String, dynamic> data = doc.data()['favorite'];
    for (var ref in data.values) {
      DocumentSnapshot<Map<String, dynamic>> json = await ref.get();
      Map<String, dynamic> result = json.data()!;

      products.add(ProductModel.fromJson(result));
    }
    return products;
  }
}
