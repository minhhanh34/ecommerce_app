import 'package:ecommerce_app/blocs/home/home_cubit.dart';
import 'package:ecommerce_app/blocs/home/home_state.dart';
import 'package:ecommerce_app/components/account_container.dart';
import 'package:ecommerce_app/components/bottom_navigation_bar.dart';
import 'package:ecommerce_app/components/cart_icon.dart';
import 'package:ecommerce_app/components/favorite_container.dart';
import 'package:ecommerce_app/components/history_container.dart';
import 'package:ecommerce_app/components/home_comtainer.dart';
import 'package:ecommerce_app/components/order_container.dart';

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
      drawer: const Drawer(),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is MainState) return const HomeContainer();
          if (state is FavoriteState) return const FavoriteProductContainer();
          if (state is OrderState) return const OrderContainer();
          if (state is HistoryState) return const HistoryContainer();
          if (state is AccountState) return const AccountContainer();
          return Container();
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
