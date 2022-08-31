import 'package:ecommerce_app/model/banner_model.dart';
import 'package:ecommerce_app/model/product_model.dart';

abstract class HomeState {}

class MainState extends HomeState {
  final BannerModel banners;
  final List<ProductModel> products;
  MainState({required this.banners, required this.products});
}

class FavoriteState extends HomeState {
  List<ProductModel> favoritedProducts;
  FavoriteState({required this.favoritedProducts});
}

class OrderState extends HomeState {}

class HistoryState extends HomeState {}

class AccountState extends HomeState {}

class LogoutState extends HomeState {}

class LoadingState extends HomeState {}
