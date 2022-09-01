abstract class LoginState {}

class SignInState extends LoginState {
  bool isShowPassword;
  bool isLogin;
  bool saveAcount;
  SignInState({
    required this.isLogin,
    required this.isShowPassword,
    required this.saveAcount,
  });
}

class SignInitial extends LoginState {}

class SignLoadingState extends LoginState {}

class SignUpState extends LoginState {}

class LoginedState extends LoginState {}

class SwitchSignState extends LoginState {}

class SignUpSuccessState extends LoginState {}
