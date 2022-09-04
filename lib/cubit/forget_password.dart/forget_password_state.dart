part of 'forget_password_cubit.dart';

@immutable
abstract class ForgetPasswordState {}

class ForgetPasswordInitial extends ForgetPasswordState {}

class IncorrectInput extends ForgetPasswordState {
  final String message;
  IncorrectInput(this.message);
}

class SendedVariefy extends ForgetPasswordState {
  final String variefy;
  SendedVariefy(this.variefy);
}

class NewPassword extends ForgetPasswordState{}


