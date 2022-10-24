import 'dart:developer';

import 'package:ecommerce_app/cubit/cart/cart_cubit.dart';
import 'package:ecommerce_app/model/banner_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/model/user_model.dart';
import 'package:ecommerce_app/services/favorite_service.dart';
import 'package:ecommerce_app/services/home_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cubit/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.homeService,
    required this.favoriteService,
    required this.cartCubit,
  }) : super(InitialState());
  HomeService homeService;
  FavoriteService favoriteService;
  CartCubit cartCubit;

  int navIndex = 0;

  List<ProductModel>? products;
  List<ProductModel>? favoriteProducts;
  List<ProductModel>? orderProducts;
  List<ProductModel>? historyProducts;
  UserModel? user;
  BannerModel? bannersData;

  Future<void> favoriteTab() async {
    if (favoriteProducts == null) {
      emit(LoadingState());
      final favoriteProducts = await getFavoriteProduct();
      emit(FavoriteState(favoritedProducts: favoriteProducts));
    } else {
      emit(FavoriteState(favoritedProducts: favoriteProducts!));
    }
  }

  Future<List<ProductModel>> getFavoriteProduct() async {
    final spref = await SharedPreferences.getInstance();
    final uid = spref.getString('uid');
    favoriteProducts = await homeService.getFavoriteProducts(uid!);
    return favoriteProducts ?? <ProductModel>[];
  }

  Future<void> addFavoriteProduct(ProductModel product) async {
    final spref = await SharedPreferences.getInstance();
    final uid = spref.getString('uid');
    favoriteProducts!.add(product);
    favoriteService.updateFavoriteProducts(uid!, favoriteProducts!);
  }

  Future<void> removeFavoriteProduct(ProductModel product) async {
    final spref = await SharedPreferences.getInstance();
    final uid = spref.getString('uid');
    favoriteProducts!.remove(product);
    favoriteService.updateFavoriteProducts(uid!, favoriteProducts!);
  }

  Future<void> mainTab() async {
    if (products == null || bannersData == null) {
      emit(LoadingState());
      bannersData = await homeService.getBanners();
      products = await homeService.getAllProducts();
      await cartCubit.getCart();
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

  Future<void> orderTab() async {
    if (orderProducts == null) {
      emit(LoadingState());
      final spref = await SharedPreferences.getInstance();
      final uid = spref.getString('uid');
      orderProducts = await homeService.getOrderProducts(uid!);
      emit(OrderState(orderProducts!));
    } else {
      emit(OrderState(orderProducts!));
    }
  }

  Future<void> historyTab() async {
    if (historyProducts == null) {
      emit(HistoryState());
      final spref = await SharedPreferences.getInstance();
      final uid = spref.getString('uid');
      historyProducts = await homeService.getHistoryProducts(uid!);
    } else {
      emit(HistoryState());
    }
  }

  Future<void> accountTab() async {
    if (user == null) {
      emit(AccountState());
      final spref = await SharedPreferences.getInstance();
      final uid = spref.getString('uid');
      user = await homeService.getUserInfo(uid!);
    } else {
      emit(AccountState());
    }
  }

  Future<void> logout() async {
    emit(LoadingState());
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('uid');
      bannersData = null;
      products = null;
      favoriteProducts = null;
      orderProducts = null;
      historyProducts = null;
      user = null;
      cartCubit.products = null;
      navIndex = 0;
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

  Future<void> orderRefresh() async {
    orderProducts = null;
    orderTab();
  }

  void onNavTap(int index) async {
    if (index == 0) {
      navIndex == 0 ? products = null : navIndex = 0;
      await mainTab();
    } else if (index == 1) {
      navIndex == 1 ? favoriteProducts = null : navIndex = 1;
      await favoriteTab();
    } else if (index == 2) {
      navIndex == 2 ? orderProducts = null : navIndex = 2;
      await orderTab();
    } else if (index == 3) {
      navIndex == 3 ? historyProducts = null : navIndex = 3;
      await historyTab();
    } else if (index == 4) {
      navIndex == 4 ? user = null : navIndex = 4;
      await accountTab();
    }
  }
}
