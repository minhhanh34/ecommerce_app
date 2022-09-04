import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/forget_password.dart/forget_password_cubit.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late TextEditingController controller;
  late TextEditingController passController;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    passController = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Quên mật khẩu'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        children: [
          const SizedBox(height: 50),
          BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
            builder: (context, state) {
              if (state is NewPassword) {
                return TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.password_rounded),
                    label: Text('Mật khẩu mới'),
                  ),
                );
              }
              return TextField(
                controller: controller,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone_rounded),
                  label: Text('Nhập số điện thoại'),
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
            builder: (context, state) {
              if (state is IncorrectInput) {
                return Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                );
              }
              if (state is NewPassword) {
                return TextField(
                  controller: passController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.confirmation_number_rounded),
                    label: Text('Xác nhận mật khẩu'),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
            listener: (context, state) {
              if (state is SendedVariefy) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Mã xác nhận'),
                      content: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (value.length == 6) {
                            if (value == state.variefy) {
                              Navigator.of(context).pop();
                              context
                                  .read<ForgetPasswordCubit>()
                                  .onGetNewPassword();
                            }
                          }
                        },
                      ),
                    );
                  },
                );
              }
            },
            child: ElevatedButton(
              onPressed: () =>
                  context.read<ForgetPasswordCubit>().onSend(controller.text),
              child: const Text('Gửi'),
            ),
          ),
        ],
      ),
    );
  }
}
