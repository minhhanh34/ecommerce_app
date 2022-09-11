import 'package:ecommerce_app/cubit/home/home_cubit.dart';
import 'package:ecommerce_app/cubit/home/home_state.dart';

import 'package:ecommerce_app/screen/cart_page.dart';
import 'package:ecommerce_app/screen/sign_in_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/account_container.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/cart_icon.dart';
import '../widgets/favorite_container.dart';
import '../widgets/history_container.dart';
import '../widgets/home_container.dart';
import '../widgets/notify_icon.dart';
import '../widgets/order_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _buildSearchIconButton() {
    return IconButton(
      alignment: Alignment.centerRight,
      onPressed: () {},
      icon: const Icon(
        Icons.search_rounded,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    HomeCubit homeCubit = context.read<HomeCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        elevation: 0,
        actions: [
          _buildSearchIconButton(),
          const NotifyIcon(),
          const CartIcon(),
        ],
      ),
      drawer: MyDrawer(homeCubit: homeCubit),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is InitialState) {
            context.read<HomeCubit>().mainTab();
            return buildLoading();
          }
          if (state is MainState) {
            return HomeContainer(
              banners: state.banners,
              products: state.products,
            );
          }
          if (state is FavoriteState) {
            return FavoriteProductContainer(
              favoritedProducts: state.favoritedProducts,
            );
          }
          if (state is OrderState) return const OrderContainer();
          if (state is HistoryState) return const HistoryContainer();
          if (state is AccountState) return const AccountContainer();
          if (state is LoadingState) return buildLoading();
          return buildLoading();
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
    required this.homeCubit,
  }) : super(key: key);

  final HomeCubit homeCubit;

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is LogoutState) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SignInPage()),
            (route) => false,
          );
        }
        if (state is CheckCartState) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CartPage(products: [])),
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
                  MaterialPageRoute(builder: (_) => const CartPage(products: [])),
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
              ontap: () {
                Navigator.of(context).pop();
                homeCubit.logout();
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

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    this.isSelected = false,
    this.leading,
    required this.ontap,
    required this.title,
    this.trailing,
  }) : super(key: key);

  final bool isSelected;
  final VoidCallback ontap;
  final IconData? leading;
  final String title;
  final IconData? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: isSelected,
      selectedTileColor: Colors.pink.shade100,
      selectedColor: Colors.white,
      onTap: ontap,
      leading: Icon(leading),
      trailing: Icon(trailing),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
