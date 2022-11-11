import 'package:ecommerce_app/services/sign_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'signin_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({required this.service}) : super(SignInInitial());
  SignService service;

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

  void onObscureClick(bool currentObs) {
    emit(SignInPasswordVisibility(isObscureText: !currentObs));
  }

  void onRegister() {
    emit(SignUp());
  }

  void onSignIn(String phone, String password) async {
    String? uid = await service.signIn(phone: phone, password: password);
    if (uid == 'admin') {
      final spref = await SharedPreferences.getInstance();
      await spref.setString('uid', uid!);
      emit(AdminLoged());
      return;
    }
    if (uid != null) {
      final spref = await SharedPreferences.getInstance();
      await spref.setString('uid', uid);
      emit(SignIned());
      return;
    }
    emit(SignInMessage('Sai tài khoản hoặc mật khẩu'));
  }

  void onForgetPassword() {
    emit(SignInForgetPassword());
  }

  String? validatePhone(String? phone) {
    if (phone == null) return 'Vui lòng nhập số điện thoại';
    if (phone.isEmpty) return 'Vui lòng nhập số điện thoại';
    if (phone.length != 10) return 'Vui lòng điền số điện thoại 10 số';
    if (!phone.startsWith('0')) return 'Số điện thoại không hợp lệ';
    return null;
  }

  String? validatePassword(String? password) {
    if (password == null) return 'Vui lòng nhập mật khẩu';
    if (password.isEmpty) return 'Vui lòng nhập mật khẩu';
    if (password.length < 8) return 'Mật khẩu ít nhất 8 ký tự';
    return null;
  }

  void onValidator() {
    emit(SignInValidator());
  }

  void sendMessage(String? message) {
    emit(SignInMessage(message));
  }
}
