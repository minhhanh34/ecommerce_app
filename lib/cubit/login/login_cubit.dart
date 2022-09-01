import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:ecommerce_app/cubit/login/login_state.dart';
import 'package:ecommerce_app/services/sign_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(
      {this.isLogin = true,
      this.saveAcount = false,
      this.isShowPassword = false,
      required this.service})
      : super(
          SignInState(
            isLogin: isLogin,
            isShowPassword: isShowPassword,
            saveAcount: saveAcount,
          ),
        );
  // bool showPassword = false;
  bool isLogin;
  bool saveAcount;
  bool isShowPassword;
  SignService service;

  void showHidePass() {
    isShowPassword = !isShowPassword;
    emit(
      SignInState(
        isLogin: isLogin,
        isShowPassword: isShowPassword,
        saveAcount: saveAcount,
      ),
    );
  }

  void setInitial() {
    isLogin = true;
    isShowPassword = false;
    saveAcount = false;
    emit(
      SignInState(
        isLogin: isLogin,
        isShowPassword: isShowPassword,
        saveAcount: saveAcount,
      ),
    );
  }

  void changeSignState() {
    emit(SwitchSignState());
    isLogin = !isLogin;
    if (isLogin) {
      emit(
        SignInState(
          isLogin: isLogin,
          isShowPassword: isShowPassword,
          saveAcount: saveAcount,
        ),
      );
    } else {
      emit(SignUpState());
    }
  }

  void changeCB(bool? value) {
    saveAcount = value!;
    emit(
      SignInState(
        isLogin: isLogin,
        isShowPassword: isShowPassword,
        saveAcount: saveAcount,
      ),
    );
  }

  String? validateAccount(String? value) {
    if (value!.isEmpty) return 'Vui lòng điền số điện thoại';
    if (value.length != 10) return 'Vui lòng điền số điẹn thoại 10 số';
    if (!value.startsWith('0')) return 'Số điện thoại không hợp lệ';
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) return 'Vui lòng điền mật khẩu';
    if (value.length < 8) return 'Mật khẩu ít nhất 8 ký tự';
    return null;
  }

  Future<String?> login(
      GlobalKey<FormState> key, String phoneNumber, String password) async {
    bool validate = key.currentState!.validate();
    String? uid = await signIn(phoneNumber: phoneNumber, password: password);
    bool result = validate && (uid != null);
    if (result) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', uid);
      navToHome();
      return uid;
    } else {
      return null;
    }
  }

  void navToHome() {
    emit(SignLoadingState());
    Future.delayed(const Duration(seconds: 1), () {
      emit(LoginedState());
    });
  }

  Future<String?> signup(
      {required String phoneNumber, required String password}) async {
    String hashed = hashPassword(phoneNumber: phoneNumber, password: password);
    String? result = await service.signUp(phone: phoneNumber, password: hashed);
    if (result != null) emit(SignUpSuccessState());
    return result;
  }

  String hashPassword({required String phoneNumber, required String password}) {
    String suffix = phoneNumber.substring(phoneNumber.length - 5);
    password += suffix;
    for (int i = 0; i < suffix.length; i++) {
      password += pepper[suffix[i]]!;
    }
    String hashed = md5.convert(utf8.encode(password)).toString();
    return hashed;
  }

  Future<String?> signIn(
      {required String phoneNumber, required String password}) async {
    String hashed = hashPassword(phoneNumber: phoneNumber, password: password);
    String? uid = await service.signIn(phone: phoneNumber, password: hashed);
    return uid;
  }

  void createNewPassword() {}
}

final pepper = <String, String>{
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
