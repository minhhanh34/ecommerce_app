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
  Future<UserModel> getOne(String uid) async {
    final doc = await collection.where('uid', isEqualTo: uid).get();
    return UserModel.fromJson(doc.docs.first.data());
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
  Future<QueryDocumentSnapshot> getQueryDocumentSnapshot(String uid) async {
    final docs = await collection.where('uid', isEqualTo: uid).get();
    return docs.docs.first;
  }
}

// class UserUserRepository implements Repository<UserModel> {
//   late UserRepository repo;

//   UserUserRepository() {
//     repo = UserRepository();
//   }

//   @override
//   Future<UserModel> create(UserModel item) async {
//     return await repo.create(item);
//   }

//   @override
//   Future<bool> delete(String id) {
//     throw IllegalAccessExeption('can not access!');
//   }

//   @override
//   Future<String> getDocumentID(String key) async {
//     return await repo.getDocumentID(key);
//   }

//   @override
//   Future<UserModel> getOne(String id) async {
//     return repo.getOne(id);
//   }

//   @override
//   Future<List<UserModel>> list() {
//     throw IllegalAccessExeption('can not access!');
//   }

//   @override
//   Future<bool> update(String id, UserModel item) async {
//     return await repo.update(id, item);
//   }
// }

// class AdminUserRepository implements Repository<UserModel> {
//   late UserRepository repo;

//   AdminUserRepository() {
//     repo = UserRepository();
//   }

//   @override
//   Future<UserModel> create(UserModel item) async {
//     throw IllegalAccessExeption('can not access!');
//   }

//   @override
//   Future<bool> delete(String id) {
//     throw IllegalAccessExeption('can not access!');
//   }

//   @override
//   Future<String> getDocumentID(String key) async {
//     return await repo.getDocumentID(key);
//   }

//   @override
//   Future<UserModel> getOne(String id) async {
//     return repo.getOne(id);
//   }

//   @override
//   Future<List<UserModel>> list() async {
//     return await repo.list();
//   }

//   @override
//   Future<bool> update(String id, UserModel item) async {
//     throw IllegalAccessExeption('can not access!');
//   }
// }
