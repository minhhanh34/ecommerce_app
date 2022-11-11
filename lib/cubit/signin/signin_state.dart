part of 'signin_cubit.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInPasswordVisibility extends SignInState {
  final bool isObscureText;
  SignInPasswordVisibility({required this.isObscureText});
}

class SignUp extends SignInState {}

class SignIned extends SignInState {}

class SignInForgetPassword extends SignInState {}

class SignInValidator extends SignInState {}

class SignInMessage extends SignInState {
  SignInMessage(this.message);
  final String? message;
}

class AdminLoged extends SignInState {}
