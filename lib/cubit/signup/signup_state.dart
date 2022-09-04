part of 'signup_cubit.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpValidator extends SignUpState {}

class SignUpMessage extends SignUpState {
  final String? message;
  SignUpMessage(this.message);
}

class SignUped extends SignUpState {}

class SignUpSuccess extends SignUpState {}
