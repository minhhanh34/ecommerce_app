import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/product_model.dart';

abstract class Repository<T> {
  Future<List<T>> list();
  Future<T> getOne(String id);
  Future<bool> update(String id, T item);
  Future<bool> delete(String id);
  Future<T> create(T item);
}

class ProductRepository implements Repository<ProductModel> {
  final collection = 'products';
  @override
  Future<List<ProductModel>> list() async {
    final query = await FirebaseFirestore.instance.collection(collection).get();
    return query.docs.map((doc) {
      final data = doc.data();
      return ProductModel.fromJson(data);
    }).toList();
  }

  @override
  Future<ProductModel> getOne(String id) async {
    final query =
        await FirebaseFirestore.instance.collection(collection).doc(id).get();
    return ProductModel.fromJson(query.data()!);
  }

  @override
  Future<bool> update(String id, ProductModel product) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .update(product.toJson());
    return true;
  }

  @override
  Future<ProductModel> create(ProductModel product) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(product.model)
        .set(product.toJson());
    return product;
  }

  @override
  Future<bool> delete(String id) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .delete()
        .catchError((_) => false);
    return true;
  }
}
