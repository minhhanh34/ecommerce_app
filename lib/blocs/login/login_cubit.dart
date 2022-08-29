import 'package:ecommerce_app/blocs/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(
      {this.isLogin = true,
      this.saveAcount = false,
      this.isShowPassword = false})
      : super(SignInState());
  // bool showPassword = false;
  bool isLogin;
  bool saveAcount;
  bool isShowPassword;

  void showHidePass() {
    isShowPassword = !isShowPassword;
    emit(SignInState());
  }

  void setInitial() {
    isLogin = true;
    isShowPassword = false;
    saveAcount = false;
    emit(SignInState());
  }

  void changeSignState() {
    isLogin = !isLogin;
    if (isLogin) {
      emit(SignInState());
    } else {
      emit(SignUpState());
    }
  }

  void changeCB(bool? value) {
    saveAcount = value!;
    emit(SignInState());
  }

  String? validateAccount(String? value) {
    if (value!.isEmpty) return 'Vui lòng điền số điện thoại';
    if (value.length != 10) return 'Vui lòng điền số điẹn thoại 10 số.';
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) return 'Vui lòng điền mật khẩu';
    if (value.length < 8) return 'Mật khẩu ít nhất 8 ký tự';
    return null;
  }

  void login(GlobalKey<FormState> key) {
    bool result = key.currentState!.validate();
    if (result) {
      navToHome();
    }
  }

  void navToHome() {
    emit(SignLoadingState());
    Future.delayed(const Duration(seconds: 1), () {
      emit(LoginedState());
    });
  }

  void signup() {}

  void createNewPassword() {}
}
