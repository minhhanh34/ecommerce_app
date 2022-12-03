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
        title: const Text('doi mat khau'),
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
                      return 'Vui long nhap mat khau cu';
                    }
                    if (value.length < 8) {
                      return 'vui long nhap du 8 ky tu';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelText: 'mat khau cu',
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
                      return 'Vui long nhap mat khau moi';
                    }
                    if (value.length < 8) {
                      return 'vui long nhap du 8 ky tu';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelText: 'mat khau moi',
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
                      return 'Vui long nhap lai mat khau moi';
                    }
                    if (value.length < 8) {
                      return 'vui long nhap du 8 ky tu';
                    }
                    if (newPassword != confirmPassword) {
                      return 'mat khau chua chinh xac';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelText: 'xac nhan mat khau cu',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                Visibility(
                  visible: hasError,
                  child: const Text(
                    'Thong tin khong chinh xac',
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
                            title: Text('Dang xu li'),
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
                              title: 'Trang thai',
                              content: 'Doi mat khau thanh cong!',
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
                            title: 'Trang thai',
                            content: 'Doi mat khau thanh cong!',
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
