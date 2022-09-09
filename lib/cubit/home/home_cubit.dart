import 'dart:developer';

import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/services/banner_service.dart';
import 'package:ecommerce_app/services/product_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cubit/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.bannerService,
    required this.productService,
  }) : super(InitialState());
  final BannerService bannerService;
  final ProductService productService;

  int navIndex = 0;

  void favoriteTab() async {
    emit(LoadingState());
    final spref = await SharedPreferences.getInstance();
    final uid = spref.getString('uid');
    final products = await productService.getFavorite(uid: uid!);
    emit(FavoriteState(favoritedProducts: products));
  }

  void mainTab() async {
    emit(LoadingState());
    final banners = await bannerService.getAllBanners();
    final products = await productService.getAllProducts();
    emit(
      MainState(
        banners: banners,
        products: products!,
      ),
    );
  }

  void orderTab() {
    emit(OrderState());
  }

  void historyTab() {
    emit(HistoryState());
  }

  void accountTab() {
    emit(AccountState());
  }

  void logout() async {
    emit(LoadingState());
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('uid');
    } catch (e) {
      log('error', error: e);
    }
    emit(LogoutState());
  }

  void onDetailProduct(ProductModel product) {
    emit(ProductDetail(product));
  }

  void onCartTab() {
    emit(CheckCartState());
  }

  void onNavTap(int index) async {
    if (index == 0) {
      navIndex = 0;
      mainTab();
    } else if (index == 1) {
      navIndex = 1;
      favoriteTab();
    } else if (index == 2) {
      navIndex = 2;
      orderTab();
    } else if (index == 3) {
      navIndex = 3;
      historyTab();
    } else {
      navIndex = 4;
      accountTab();
    }
  }
}
