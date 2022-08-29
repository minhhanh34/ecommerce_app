import 'package:ecommerce_app/blocs/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../screen/home_page.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(SignInState());
  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // final accountController = TextEditingController();
  // final passController = TextEditingController();
  // final confirmPassword = TextEditingController();
  // bool showPassword = false;

  bool isLogin = false;

  bool saveAcount = false;

  void showHidePass(bool showPassword) {
    showPassword = !showPassword;
    emit(SignInState());
  }

  void changeSignState() {
    accountController.clear();
    passController.clear();
    confirmPassword.clear();
    formKey.currentState!.reset();
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

  void login(BuildContext context) {
    bool result = formKey.currentState!.validate();
    if (result) {
      emit(LoginedState());
    }
  }

  void navToHome(BuildContext context) {
    emit(SignLoadingState());
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    });
  }

  void signup() {}

  void createNewPassword() {}
}
