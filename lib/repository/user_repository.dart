import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/user_model.dart';

import 'repository_interface.dart';

class UserRepository implements Repository<UserModel> {
  final collection = FirebaseFirestore.instance.collection('user');

  @override
  Future<List<UserModel>> list() async {
    final docs = await collection.get();
    return docs.docs.map((doc) {
      final userData = doc.data();
      return UserModel.fromJson(userData);
    }).toList();
  }

  @override
  Future<UserModel> getOne(String id) async {
    final snapshot = await collection.doc(id).get();
    return UserModel.fromJson(snapshot.data()!);
  }

  @override
  Future<UserModel> create(UserModel item) async {
    await collection.add(item.toJson());
    return item;
  }

  @override
  Future<bool> update(String id, UserModel item) async {
    await collection.doc(id).update(item.toJson()).catchError((e) => false);
    return true;
  }

  @override
  Future<bool> delete(String id) async {
    await collection.doc(id).delete().catchError((e) => false);
    return true;
  }

  @override
  Future<String> getDocumentID(String uid) async {
    final docs = await collection.get();
    return docs.docs.firstWhere((doc) => doc.data()['uid']).id;
  }
}
