import 'package:ecommerce_app/cubit/home/home_cubit.dart';
import 'package:ecommerce_app/cubit/home/home_state.dart';
import 'package:ecommerce_app/screen/notification_screen.dart';
import 'package:ecommerce_app/screen/product_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/product_model.dart';
import '../widgets/account_container.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/cart_icon.dart';
import '../widgets/favorite_container.dart';
import '../widgets/history_container.dart';
import '../widgets/home_container.dart';
import '../widgets/notify_icon.dart';
import '../widgets/order_container.dart';
import '../widgets/search_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget _buildSearchIconButton(
    BuildContext context,
    List<ProductModel> products,
  ) {
    return IconButton(
      alignment: Alignment.centerRight,
      onPressed: () {
        showSearch(
          context: context,
          delegate: SearchScreen(
            products,
            isAdmin: false,
          ),
        );
      },
      icon: const Icon(
        Icons.search_rounded,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    List<ProductModel> products = homeCubit.products ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        elevation: 0,
        actions: [
          _buildSearchIconButton(context, products),
          const NotifyIcon(),
          const CartIcon(),
        ],
      ),
      // drawer: const MyDrawer(),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeNotification) {
            builder(context) => const NotificationScreen();
            final route = MaterialPageRoute(builder: builder);
            Navigator.of(context).push(route);
          }
          if (state is ProductDetail) {
            builder(context) => ProductPage(product: state.product);
            final route = MaterialPageRoute(builder: builder);
            Navigator.of(context).push(route);
          }
        },
        builder: (context, state) {
          if (state is InitialState) {
            homeCubit.mainTab();
            homeCubit.getFavoriteProduct();
            // notificationCubit.getNotification();
            return buildLoading();
          }
          if (state is MainState) {
            if (products.isEmpty) {
              products.addAll(state.products);
            }
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
          if (state is OrderState) {
            return OrderContainer(orders: state.orders);
          }
          if (state is HistoryState) {
            return HistoryContainer(
              historyOrders: state.historyOrders,
            );
          }
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
