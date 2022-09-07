import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/cart_model.dart';
import 'package:ecommerce_app/repository/product_repository.dart';

class CartRepository implements Repository<CartModel> {
  final collection = 'cart';

  @override
  Future<CartModel> create(CartModel item) async {
    await FirebaseFirestore.instance.collection(collection).add(item.toJson());
    return item;
  }

  @override
  Future<List<CartModel>> list() async {
    final docs = await FirebaseFirestore.instance.collection(collection).get();
    return docs.docs.map((doc) {
      final data = doc.data();
      return CartModel.fromJson(data);
    }).toList();
  }

  @override
  Future<CartModel> getOne(String id) async {
    final docs = await FirebaseFirestore.instance.collection(collection).get();
    final doc = docs.docs.where((element) => element.data()['uid'] == id).first;
    final data = doc.data();
    return CartModel.fromJson(data);
  }

  @override
  Future<bool> delete(String id) async {
    final docs = await FirebaseFirestore.instance.collection(collection).get();
    final doc = docs.docs.firstWhere((doc) => doc.data()['uid'] == id);
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(doc.id)
        .delete()
        .catchError((error) => false);
    return true;
  }

  @override
  Future<bool> update(String id, CartModel item) async {
    final docs = await FirebaseFirestore.instance.collection(collection).get();
    final docID =
        docs.docs.firstWhere((element) => element.data()['uid'] == item.uid).id;
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(docID)
        .update(item.toJson())
        .catchError((error) => false);
    return true;
  }
}
