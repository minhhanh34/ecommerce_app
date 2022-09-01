import 'package:ecommerce_app/cubit/home/home_cubit.dart';
import 'package:ecommerce_app/cubit/home/home_state.dart';
import 'package:ecommerce_app/cubit/login/login_cubit.dart';
import 'package:ecommerce_app/components/account_container.dart';
import 'package:ecommerce_app/components/bottom_navigation_bar.dart';
import 'package:ecommerce_app/components/cart_icon.dart';
import 'package:ecommerce_app/components/favorite_container.dart';
import 'package:ecommerce_app/components/history_container.dart';
import 'package:ecommerce_app/components/home_container.dart';
import 'package:ecommerce_app/components/order_container.dart';
import 'package:ecommerce_app/screen/cart_page.dart';
import 'package:ecommerce_app/screen/login_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/notify_icon.dart';

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
      drawer: Drawer(
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
            ListTile(
              selected: true,
              selectedTileColor: Colors.pink.shade100,
              selectedColor: Colors.white,
              onTap: () {},
              leading: const Icon(Icons.home_rounded),
              title: Text(
                'Trang chủ',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              selected: false,
              selectedTileColor: Colors.pink.shade100,
              selectedColor: Colors.white,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CartPage(),
                  ),
                );
              },
              leading: const Icon(Icons.shopping_cart_rounded),
              title: Text(
                'Giỏ hàng',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            // const Divider(color: Colors.black),
            ListTile(
              selected: false,
              selectedTileColor: Colors.pink.shade100,
              selectedColor: Colors.white,
              onTap: () {},
              leading: const Icon(Icons.border_all_rounded),
              title: Text(
                'Tất cả sản phẩm',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              selected: false,
              selectedTileColor: Colors.pink.shade100,
              selectedColor: Colors.white,
              onTap: () {},
              leading: const Icon(Icons.category_rounded),
              title: Text(
                'Danh mục',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              selected: false,
              selectedTileColor: Colors.pink.shade100,
              selectedColor: Colors.white,
              onTap: () {},
              leading: const Icon(Icons.feedback_rounded),
              title: Text(
                'Phản hồi',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListTile(
              selected: false,
              selectedTileColor: Colors.pink.shade100,
              selectedColor: Colors.white,
              onTap: () {},
              leading: const Icon(Icons.info_rounded),
              title: Text(
                'Thông tin',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Spacer(),
            const Divider(color: Colors.black, height: 2),
            ListTile(
              onTap: homeCubit.logout,
              title: const Text('Đăng xuất'),
              trailing: Icon(
                Icons.logout_rounded,
                color: Colors.red.shade900,
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is LogoutState) {
            context.read<LoginCubit>().setInitial();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          }
        },
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
