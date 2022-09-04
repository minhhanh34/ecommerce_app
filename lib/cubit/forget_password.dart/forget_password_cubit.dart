import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  void onSend(String phone) {
    if (phone.isEmpty) {
      emit(IncorrectInput('Vui lòng nhập số điện thoại'));
    } else if (phone.length != 10) {
      emit(IncorrectInput('Vui lòng nhập số điện thoại 10 số'));
    } else {
      emit(SendedVariefy('123456'));
    }
  }

  void onGetNewPassword() {
    emit(NewPassword());
  }
}
