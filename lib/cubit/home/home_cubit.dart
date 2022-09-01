import 'dart:developer';

import 'package:ecommerce_app/services/banner_service.dart';
import 'package:ecommerce_app/services/firebase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cubit/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.bannerService, required this.productService})
      : super(InitialState());
  final BannerService bannerService;
  final ProductService productService;

  void favoriteTab() async {
    emit(LoadingState());
    final favorited = await productService.getFavoritedProduct(userID: 'user1');
    emit(FavoriteState(favoritedProducts: favorited));
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
}
