import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home/home_cubit.dart';
import '../cubit/home/home_state.dart';
import '../screen/cart_screen.dart';
import '../screen/sign_in_screen.dart';
import 'drawer_list_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is LogoutState) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false,
          );
        }
        if (state is CheckCartState) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CartScreen()),
          );
        }
      },
      child: Drawer(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DrawerHeader(
                curve: Curves.easeInOut,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    transform: GradientRotation(2),
                    colors: [
                      Colors.red,
                      Colors.blue,
                      Colors.orange,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    CircleAvatar(
                      maxRadius: 40,
                      child: FlutterLogo(size: 40),
                    ),
                    Text(
                      'Minh Hanh',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DrawerListTile(
              leading: Icons.home_rounded,
              ontap: () {},
              title: 'Trang chủ',
              isSelected: true,
            ),
            DrawerListTile(
              leading: Icons.shopping_cart_outlined,
              ontap: () async {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
                // homeCubit.onCartTab();
              },
              title: 'Giỏ hàng',
            ),
            // const Divider(color: Colors.black),
            DrawerListTile(
              ontap: () {},
              leading: Icons.border_all_rounded,
              title: 'Tất cả sản phẩm',
            ),
            DrawerListTile(
              leading: Icons.category_rounded,
              ontap: () {},
              title: 'Danh mục',
            ),
            DrawerListTile(
              ontap: () {},
              leading: Icons.feedback_rounded,
              title: 'Phản hồi',
            ),
            DrawerListTile(
              ontap: () {},
              leading: Icons.info_rounded,
              title: 'Thông tin',
            ),
            const Spacer(),
            const Divider(color: Colors.black, height: 2),
            DrawerListTile(
              ontap: () async {
                Navigator.of(context).pop();
                await BlocProvider.of<HomeCubit>(context).logout();
              },
              title: 'Đăng xuất',
              trailing: Icons.logout_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
