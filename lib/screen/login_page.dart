import 'package:ecommerce_app/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/login/login_cubit.dart';
import '../cubit/login/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController accountController;
  late TextEditingController passController;
  late TextEditingController confirmController;
  late GlobalKey<FormState> formKey;
  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    accountController = TextEditingController();
    passController = TextEditingController();
    confirmController = TextEditingController();
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    accountController.dispose();
    passController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Widget _buildLoadingLogin() {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('My shop')),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    LoginCubit loginCubit = BlocProvider.of<LoginCubit>(context);
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginedState) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }

        if (state is SignInState || state is SignUpState) {
          accountController.clear();
          confirmController.clear();
          passController.clear();
        }
      },
      builder: (context, state) {
        if (state is SignLoadingState) {
          return _buildLoadingLogin();
        } else if (state is SignInState || state is SignUpState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('My shop'),
              centerTitle: true,
              elevation: 0,
              actions: [
                TextButton(
                  onPressed: loginCubit.changeSignState,
                  child: Text(
                    state is SignInState ? 'Đăng ký' : 'Đăng nhập',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.red.shade900,
                          fontSize: 18,
                        ),
                  ),
                ),
              ],
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.shade100,
                    Colors.red.shade100,
                    Colors.blue.shade100,
                  ],
                ),
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 40,
                          top: 50,
                        ),
                        child: Text(
                          state is SignInState ? 'Đăng nhập' : 'Đăng ký',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextFormField(
                          validator: loginCubit.validateAccount,
                          keyboardType: TextInputType.phone,
                          controller: accountController,
                          decoration: InputDecoration(
                            labelText: 'Số điện thoại',
                            labelStyle: Theme.of(context).textTheme.bodyText2,
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: Colors.blue,
                            ),
                            hintText: 'Số điện thoại của bạn',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextFormField(
                          validator: loginCubit.validatePassword,
                          obscureText: !loginCubit.isShowPassword,
                          controller: passController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.password_outlined,
                              color: Colors.blue,
                            ),
                            suffixIcon: state is SignInState
                                ? (loginCubit.isShowPassword
                                    ? IconButton(
                                        icon: const Icon(Icons.visibility),
                                        onPressed: loginCubit.showHidePass,
                                      )
                                    : IconButton(
                                        onPressed: loginCubit.showHidePass,
                                        icon: const Icon(Icons.visibility_off),
                                      ))
                                : const SizedBox(),
                            labelText: 'Mật khẩu',
                            labelStyle: Theme.of(context).textTheme.bodyText2,
                            hintText: '********',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      state is SignInState
                          ? const SizedBox()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: TextFormField(
                                obscureText: !loginCubit.isShowPassword,
                                controller: confirmController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.confirmation_num_outlined,
                                    color: Colors.blue,
                                  ),
                                  labelText: 'Xác nhận mật khẩu',
                                  hintText: '********',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                      state is SignInState
                          ? Row(
                              children: [
                                const SizedBox(width: 45),
                                Checkbox(
                                  value: loginCubit.saveAcount,
                                  onChanged: loginCubit.changeCB,
                                ),
                                const Text('Ghi nhớ đăng nhập')
                              ],
                            )
                          : const SizedBox(),
                      state is SignInState
                          ? const SizedBox()
                          : const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        widthFactor: 5.4,
                        child: Container(
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade700,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            iconSize: 40,
                            color: Colors.white,
                            onPressed: () => loginCubit.login(formKey),
                            icon: const Icon(Icons.arrow_forward),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                      state is SignInState
                          ? Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: loginCubit.createNewPassword,
                                child: const Text('Quên mật khẩu?'),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return _buildLoadingLogin();
      },
    );
  }
}
