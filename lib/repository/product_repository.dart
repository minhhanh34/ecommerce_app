import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/product_model.dart';

import 'repository_interface.dart';



class ProductRepository implements Repository<ProductModel> {
  final collection = FirebaseFirestore.instance.collection('products');
  @override
  Future<List<ProductModel>> list() async {
    final query = await collection.get();
    return query.docs.map((doc) {
      final data = doc.data();
      return ProductModel.fromJson(data);
    }).toList();
  }

  @override
  Future<ProductModel> getOne(String id) async {
    final query = await collection.doc(id).get();
    return ProductModel.fromJson(query.data()!);
  }

  @override
  Future<bool> update(String id, ProductModel product) async {
    await collection.doc(id).update(product.toJson());
    return true;
  }

  @override
  Future<ProductModel> create(ProductModel product) async {
    await collection.doc(product.model).set(product.toJson());
    return product;
  }

  @override
  Future<bool> delete(String id) async {
    await collection.doc(id).delete().catchError((_) => false);
    return true;
  }

  @override
  Future<String> getDocumentID(String productName) async {
    final docs = await collection.get();
    return docs.docs.firstWhere((doc) => doc.data()['name'] == productName).id;
  }
}
