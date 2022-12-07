import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:ecommerce_app/model/user_model.dart';
import 'package:ecommerce_app/utils/alert_dialog.dart';
import 'package:ecommerce_app/utils/libs.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen(this.user, {super.key});
  final UserModel user;
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _key = GlobalKey<FormState>();
  String oldPassword = '';
  String newPassword = '';
  String confirmPassword = '';
  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text('Đổi mật khẩu'),
        elevation: 0,
      ),
      body: Form(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 56.0),
                TextFormField(
                  onChanged: (val) => oldPassword = val,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu cũ';
                    }
                    if (value.length < 8) {
                      return 'vui lòng nhập đủ 8 ký tự';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelText: 'Mật khẩu cũ',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  onChanged: (val) => newPassword = val,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu mới';
                    }
                    if (value.length < 8) {
                      return 'Vui lòng nhập đủ 8 ký tự';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelText: 'Mật khẩu mới',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  onChanged: (val) => confirmPassword = val,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập lại mật khẩu mới';
                    }
                    if (value.length < 8) {
                      return 'Vui lòng nhập đủ 8 ký tự';
                    }
                    if (newPassword != confirmPassword) {
                      return 'Mật khẩu chưa chính xác';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelText: 'Xác nhận lại mật khẩu cũ',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                Visibility(
                  visible: hasError,
                  child: const Text(
                    'Thông tin không chính xác',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      bool result = _key.currentState?.validate() ?? false;
                      if (!result) return;
                      oldPassword += widget.user.keyUnique;
                      String hashedPassword =
                          md5.convert(utf8.encode(oldPassword)).toString();
                      if (widget.user.password != hashedPassword) {
                        setState(() {
                          hasError = true;
                        });
                        return;
                      }
                      String newPasswordHashed = md5
                          .convert(
                              utf8.encode(newPassword + widget.user.keyUnique))
                          .toString();
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text('Đang xử lí'),
                            content: SizedBox(
                              width: 120.0,
                              height: 120.0,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                        },
                      );
                      bool isSuccess = await context
                          .read<HomeCubit>()
                          .updateInfo(
                            widget.user.copyWith(password: newPasswordHashed),
                          );
                      if (isSuccess) {
                        if (!mounted) return;
                        Navigator.of(context).pop();
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return const CustomAlertDialog(
                              title: 'Trạng thái',
                              content: 'Đổi mật khẩu thành công!',
                              actions: ['Ok'],
                            );
                          },
                        );
                        if (!mounted) return;
                        Navigator.of(context).pop();
                        return;
                      }
                      if (!mounted) return;
                      Navigator.of(context).pop();
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return const CustomAlertDialog(
                            title: 'Trạng thái',
                            content: 'Đổi mật khẩu không thành công!',
                            actions: ['Ok'],
                          );
                        },
                      );
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
