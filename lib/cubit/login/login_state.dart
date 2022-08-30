abstract class LoginState {}

class SignInState extends LoginState {
  bool isShowPassword;
  bool isLogin;
  bool saveAcount;
  SignInState({
    this.isLogin = true,
    this.isShowPassword = false,
    this.saveAcount = false,
  });

  bool get showPass => isShowPassword;
  bool get login => isShowPassword;
  bool get save => isShowPassword;
}

class SignLoadingState extends LoginState {}

class SignUpState extends LoginState {}

class LoginedState extends LoginState {}
