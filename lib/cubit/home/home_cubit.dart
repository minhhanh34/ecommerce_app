import 'dart:developer';

import 'package:ecommerce_app/model/banner_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/model/user_model.dart';
import 'package:ecommerce_app/services/home_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cubit/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.homeService}) : super(InitialState());
  HomeService homeService;

  int navIndex = 0;

  List<ProductModel>? products;
  List<ProductModel>? favoriteProducts;
  List<ProductModel>? orderProducts;
  List<ProductModel>? historyProducts;
  UserModel? user;
  BannerModel? bannersData;

  void favoriteTab() async {
    if (favoriteProducts == null) {
      emit(LoadingState());
      final spref = await SharedPreferences.getInstance();
      final uid = spref.getString('uid');
      favoriteProducts = await homeService.getFavoriteProducts(uid!);
      emit(FavoriteState(favoritedProducts: favoriteProducts!));
    } else {
      emit(FavoriteState(favoritedProducts: favoriteProducts!));
    }
  }

  void mainTab() async {
    if (products == null || bannersData == null) {
      emit(LoadingState());
      bannersData = await homeService.getBanners();
      products = await homeService.getAllProducts();
      emit(
        MainState(
          banners: bannersData!,
          products: products!,
        ),
      );
    } else {
      emit(MainState(
        banners: bannersData!,
        products: products!,
      ));
    }
  }

  void orderTab() async {
    if (orderProducts == null) {
      emit(OrderState());
      final spref = await SharedPreferences.getInstance();
      final uid = spref.getString('uid');
      orderProducts = await homeService.getOrderProducts(uid!);
      print('order');
    } else {
      emit(OrderState());
    }
  }

  void historyTab() async {
    if (historyProducts == null) {
      emit(HistoryState());
      final spref = await SharedPreferences.getInstance();
      final uid = spref.getString('uid');
      historyProducts = await homeService.getHistoryProducts(uid!);
      print('history');
    } else {
      emit(HistoryState());
    }
  }

  void accountTab() async {
    if (user == null) {
      emit(AccountState());
      final spref = await SharedPreferences.getInstance();
      final uid = spref.getString('uid');
      user = await homeService.getUserInfo(uid!);
      print('account');
    } else {
      emit(AccountState());
    }
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
      navIndex == 0 ? products = null : navIndex = 0;
      mainTab();
    } else if (index == 1) {
      navIndex == 1 ? favoriteProducts = null : navIndex = 1;
      favoriteTab();
    } else if (index == 2) {
      navIndex == 2 ? orderProducts = null : navIndex = 2;
      orderTab();
    } else if (index == 3) {
      navIndex == 3 ? historyProducts = null : navIndex = 3;
      historyTab();
    } else if (index == 4) {
      navIndex == 4 ? user = null : navIndex = 4;
      accountTab();
    }
  }
}
