import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

abstract class UserService {
  Future<UserModel> getUser(String uid);
  Future<void> setAddress(String uid, String address);
}

class UserServiceIml implements UserService {
  static const String collection = 'user';

  @override
  Future<UserModel> getUser(String uid) async {
    final snapshot =
        await FirebaseFirestore.instance.collection(collection).doc(uid).get();
    final data = snapshot.data()!;
    return UserModel.fromJson(data);
  }

  @override
  Future<void> setAddress(String uid, String address) async {
    final data = <String, dynamic>{
      'address': address,
    };
    await FirebaseFirestore.instance.collection(collection).doc(uid).set(data);
  }
}
