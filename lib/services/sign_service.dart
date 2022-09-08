import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:ecommerce_app/model/user_model.dart';
import 'package:ecommerce_app/repository/product_repository.dart';
import 'package:ecommerce_app/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SignService extends Service {
  Future<String?> signIn({required String phone, required String password});
  Future<String?> signUp(
      {required String phone,
      required String password,
      required String name,
      required String address});
}

class SignServiceIml implements SignService {
  Repository<UserModel> repository;
  SignServiceIml({required this.repository});

  Map<String, dynamic> pepper = const <String, dynamic>{
    '0': ')',
    '1': '!',
    '2': '@',
    '3': '#',
    '4': '\$',
    '5': '%',
    '6': '^',
    '7': '&',
    '8': '*',
    '9': '(',
  };

  @override
  Future<String?> signIn(
      {required String phone, required String password}) async {
    String suff = phone.substring(phone.length - 5);
    password += suff;
    for (int i = 0; i < suff.length; i++) {
      password += pepper[suff[i]];
    }

    password = md5.convert(utf8.encode(password)).toString();
    final users = await repository.list();
    final user = users.firstWhere((element) => element.phone == phone);
    if (user.password == password) {
      return user.uid;
    }
    // final docs = await FirebaseFirestore.instance.collection('user').get();
    // for (var doc in docs.docs) {
    //   final data = doc.data();
    //   if (data['phone'] == phone && data['password'] == password) {
    //     return data['uid'];
    //   }
    // }
    return null;
  }

  @override
  Future<String?> signUp(
      {required String phone,
      required String password,
      required String name,
      required String address}) async {
    try {
      String uid = password.substring(password.length - 10);
      await FirebaseFirestore.instance.collection('user').add(
        <String, dynamic>{
          'uid': uid,
          'phone': phone,
          'password': password,
          'name': name,
          'address': address,
        },
      );
      return uid;
    } catch (e) {
      log('error', error: e);
    }
    return null;
  }
}
