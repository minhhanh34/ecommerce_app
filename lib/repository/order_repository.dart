import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/order_model.dart';

import 'repository_interface.dart';

class OrderRepository implements Repository<OrderModel> {
  final collection = FirebaseFirestore.instance.collection('order');
  @override
  Future<OrderModel> create(OrderModel item) async {
    await collection.add(item.toJson());
    return item;
  }

  @override
  Future<bool> delete(String id) async {
    await collection.doc(id).delete().catchError((e) => false);
    return true;
  }

  @override
  Future<OrderModel> getOne(String id) async {
    final doc = await collection.doc(id).get();
    return OrderModel.fromJson(doc.data()!);
  }

  @override
  Future<List<OrderModel>> list() async {
    final docs = await collection.get();
    return docs.docs.map((doc) {
      return OrderModel.fromJson(doc.data());
    }).toList();
  }

  @override
  Future<bool> update(String id, OrderModel item) async {
    await collection.doc(id).update(item.toJson()).catchError((e) => false);
    return true;
  }

  @override
  Future<String> getDocumentID(String uid) async {
    final docs = await collection.get();
    return docs.docs.firstWhere((doc) => doc.data()['uid'] == uid).id;
  }
}
