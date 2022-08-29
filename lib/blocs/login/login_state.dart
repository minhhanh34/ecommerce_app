abstract class LoginState {}

class SignInState extends LoginState {
  bool isShowPassword;
  bool isLogin;
  bool saveAcount;
}

class SignLoadingState extends LoginState {}

class SignUpState extends LoginState {}

class LoginedState extends LoginState {}
