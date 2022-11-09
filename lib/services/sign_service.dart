import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:ecommerce_app/model/cart_model.dart';
import 'package:ecommerce_app/model/favorite_model.dart';
import 'package:ecommerce_app/model/history_model.dart';
import 'package:ecommerce_app/model/order_model.dart';
import 'package:ecommerce_app/model/user_model.dart';
import 'package:ecommerce_app/repository/user_repository.dart';
import 'package:ecommerce_app/services/home_service.dart';

import '../repository/repository_interface.dart';

abstract class SignService extends Service {
  Future<String?> signIn({required String phone, required String password});
  Future<String?> signUp({
    required String phone,
    required String password,
    required String name,
    required String address,
    required String keyUnique,
  });
}

class SignServiceIml implements SignService {
  Repository<UserModel> userRepo;
  Repository<CartModel> cartRepo;
  Repository<FavoriteModel> favoriteRepo;
  Repository<HistoryModel> historyRepo;
  Repository<OrderModel> orderRepo;
  SignServiceIml({
    required this.userRepo,
    required this.cartRepo,
    required this.favoriteRepo,
    required this.historyRepo,
    required this.orderRepo,
  });

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
    final user = await (userRepo as UserRepository).getKeyUnique(phone);
    password += user.keyUnique;
    password = md5.convert(utf8.encode(password)).toString();
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
  Future<String?> signUp({
    required String phone,
    required String password,
    required String name,
    required String address,
    required String keyUnique,
  }) async {
    try {
      String uid = password.substring(password.length - 10);
      final userModel = UserModel.fromJson(
        <String, dynamic>{
          'uid': uid,
          'phone': phone,
          'password': password,
          'name': name,
          'address': address,
          'keyUnique': keyUnique,
        },
      );
      userRepo.create(userModel);
      cartRepo.create(CartModel(uid: uid, cart: <String, DocumentReference>{}));
      favoriteRepo.create(
        FavoriteModel(uid: uid, favorite: <String, DocumentReference>{}),
      );
      historyRepo.create(
        HistoryModel(uid: uid, historyRef: []),
      );
      // orderRepo.create(
      //   OrderModel(uid: uid, order: <String, DocumentReference>{}),
      // );
      return uid;
    } catch (e) {
      log('error', error: e);
    }
    return null;
  }
}
