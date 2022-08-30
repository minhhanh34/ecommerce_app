import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/product_model.dart';

abstract class Service {}

abstract class ProductService extends Service {
  Future<List<ProductModel>?> getAllProducts();
  Future<ProductModel?> getProduct({required String id});
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
        return ProductModel.fromJson(json)..buildImage();
      }).toList();
    } catch (e) {
      log('error', error: e);
    }
    return [];
  }

  @override
  Future<ProductModel?> getProduct({required String id}) async {
    String collection = 'products';
    try {
      DocumentSnapshot<Map<String, dynamic>> docRef =
          await database.collection(collection).doc(id).get();
      Map<String, dynamic> json = docRef.data()!;
      return ProductModel.fromJson(json);
    } catch (e) {
      log('error', error: e);
    }
    return null;
  }
}
