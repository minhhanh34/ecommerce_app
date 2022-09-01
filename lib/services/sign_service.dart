import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/services/firebase_service.dart';

abstract class SignService extends Service {
  Future<String?> signIn({required String phone, required String password});
  Future<String?> signUp({required String phone, required String password});
}

class SignServiceIml implements SignService {
  @override
  Future<String?> signIn(
      {required String phone, required String password}) async {
    final docs = await FirebaseFirestore.instance.collection('user').get();
    for (var doc in docs.docs) {
      final data = doc.data();
      if (data['phone'] == phone && data['password'] == password) {
        return data['uid'];
      }
    }
    return null;
  }

  @override
  Future<String?> signUp(
      {required String phone, required String password}) async {
    try {
      String uid = password.substring(password.length - 10);
      await FirebaseFirestore.instance.collection('user').add(
        <String, dynamic>{
          'uid': uid,
          'phone': phone,
          'password': password,
        },
      );
      return uid;
    } catch (e) {
      log('error', error: e);
    }
    return null;
  }
}
