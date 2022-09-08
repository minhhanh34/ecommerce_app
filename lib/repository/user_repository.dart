import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/user_model.dart';
import 'package:ecommerce_app/repository/product_repository.dart';

class UserRepository implements Repository<UserModel> {
  final user = 'user';

  @override
  Future<List<UserModel>> list() async {
    final docs = await FirebaseFirestore.instance.collection(user).get();
    return docs.docs.map((doc) {
      final userData = doc.data();
      return UserModel.fromJson(userData);
    }).toList();
  }

  @override
  Future<UserModel> getOne(String id) async {
    final docs = await FirebaseFirestore.instance.collection(user).get();
    final userDocID =
        docs.docs.firstWhere((element) => element.data()['uid'] == id).id;
    final userSnapshot =
        await FirebaseFirestore.instance.collection(user).doc(userDocID).get();
    return UserModel.fromJson(userSnapshot.data()!);
  }

  @override
  Future<UserModel> create(UserModel item) async {
    await FirebaseFirestore.instance.collection(user).add(item.toJson());
    return item;
  }

  @override
  Future<bool> update(String id, UserModel item) async {
    final docs = await FirebaseFirestore.instance.collection(user).get();
    final userDocID =
        docs.docs.firstWhere((element) => element.data()['uid'] == id).id;
    await FirebaseFirestore.instance
        .collection(user)
        .doc(userDocID)
        .update(item.toJson())
        .catchError((_) => false);
    return true;
  }

  @override
  Future<bool> delete(String id) async {
    final docs = await FirebaseFirestore.instance.collection(user).get();
    final userDocID =
        docs.docs.firstWhere((element) => element.data()['uid'] == id).id;
    await FirebaseFirestore.instance
        .collection(user)
        .doc(userDocID)
        .delete()
        .catchError((_) => false);
    return true;
  }
}
