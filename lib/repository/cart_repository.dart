import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/cart_model.dart';

import 'repository_interface.dart';

class CartRepository implements Repository<CartModel> {
  final collection = FirebaseFirestore.instance.collection('cart');

  @override
  Future<CartModel> create(CartModel item) async {
    await collection.add(item.toJson());
    return item;
  }

  @override
  Future<List<CartModel>> list() async {
    final docs = await collection.get();
    return docs.docs.map((doc) {
      final data = doc.data();
      return CartModel.fromJson(data);
    }).toList();
  }

  @override
  Future<CartModel> getOne(String id) async {
    final doc = await collection.doc(id).get();
    return CartModel.fromJson(doc.data()!);
  }

  @override
  Future<bool> delete(String id) async {
    final docs = await collection.get();
    final doc = docs.docs.firstWhere((doc) => doc.data()['uid'] == id);
    await collection.doc(doc.id).delete().catchError((error) => false);
    return true;
  }

  @override
  Future<bool> update(String id, CartModel item) async {
    await collection.doc(id).update(item.toJson()).catchError((error) => false);
    return true;
  }

  @override
  Future<String> getDocumentID(String uid) async {
    final docs = await collection.get();
    return docs.docs.firstWhere((doc) => doc.data()['uid'] == uid).id;
  }
}
