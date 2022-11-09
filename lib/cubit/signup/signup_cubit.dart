import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:ecommerce_app/services/sign_service.dart';
import 'package:ecommerce_app/utils/generator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required this.service}) : super(SignUpInitial());

  final SignService service;

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

  String? Function(String? value)? nameValidator = (String? value) {
    if (value == null) return 'Vui lòng nhập họ tên';
    if (value.isEmpty) return 'Vui lòng nhập họ tên';
    return null;
  };

  String? Function(String? value)? addressValidator = (String? value) {
    if (value == null) return 'Vui lòng nhập địa chỉ';
    if (value.isEmpty) return 'Vui lòng nhập địa chỉ';
    return null;
  };

  String? Function(String? value)? phoneValidator = (String? value) {
    if (value == null) return 'Vui lòng nhập số điện thoại';
    if (value.isEmpty) return 'Vui lòng nhập số điện thoại';
    if (value.length != 10) return 'Vui lòng nhập số điện thoại 10 số';
    return null;
  };

  String? Function(String? value)? passwordValidator = (String? value) {
    if (value == null) return 'Vui lòng nhập mật khẩu';
    if (value.isEmpty) return 'Vui lòng nhập mật khẩu';
    if (value.length < 8) return 'Mật khẩu ít nhất 8 ký tự';
    return null;
  };

  String? Function(String? value)? confirmValidator = (String? pass) {
    if (pass == null) return 'Vui lòng nhập lại mật khẩu';
    if (pass.isEmpty) return 'Vui lòng nhập lại mật khẩu';
    return null;
  };

  Future<void> onSignUp(String phone, String pass, String confirm, String name,
      String address) async {
    if (pass == confirm) {
      final keyUnique = Generator.generateString();
      pass += keyUnique;
      pass = md5.convert(utf8.encode(pass)).toString();
      String? uid = await service.signUp(
          phone: phone, password: pass, name: name, address: address, keyUnique: keyUnique);
      if (uid != null) {
        emit(SignUpSuccess());
      } else {
        emit(SignUpMessage('Đăng ký không thành công'));
      }
    } else {
      emit(SignUpMessage('Xác nhận mật khẩu không đúng'));
    }
  }

  void onSignUped() {
    emit(SignUped());
  }
}
