import 'package:ecommerce_app/model/banner_model.dart';
import 'package:ecommerce_app/model/favorite_model.dart';
import 'package:ecommerce_app/model/history_model.dart';
import 'package:ecommerce_app/model/order_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/model/user_model.dart';
import 'package:ecommerce_app/repository/history_repository.dart';
import 'package:ecommerce_app/repository/order_repository.dart';
import 'package:ecommerce_app/repository/product_repository.dart';
import 'package:ecommerce_app/services/banner_service.dart';
import 'package:ecommerce_app/services/favorite_service.dart';
import 'package:ecommerce_app/services/history_service.dart';
import 'package:ecommerce_app/services/order_service.dart';
import 'package:ecommerce_app/services/product_service.dart';
import 'package:ecommerce_app/services/user_service.dart';

import '../repository/favorite_repository.dart';
import '../repository/user_repository.dart';

abstract class Service {}

abstract class HomeService extends Service {
  Future<BannerModel> getBanners();
  Future<List<ProductModel>?> getAllProducts();
  Future<List<ProductModel>> getFavoriteProducts(String uid);
  Future<bool> updateFavoriteProducts(String uid, FavoriteModel favoriteModel);
  Future<List<ProductModel>> getOrderProducts(String uid);
  Future<bool> updateOrderProducts(String uid, OrderModel orderModel);

  Future<List<ProductModel>> getHistoryProducts(String uid);
  Future<bool> updateHistoryProducts(String uid, HistoryModel historyModel);

  Future<UserModel> getUserInfo(String uid);
  Future<bool> updateUserInfo(UserModel userModel);
}

class HomeServiceIml implements HomeService {
  final productService = ProductServiceIml(ProductRepository());
  final favoriteService = FavoriteServiceIml(FavoriteRepository());
  final orderService = OrderServiceIml(OrderRepository());
  final historyService = HistoryServiceIml(HistoryRepository());
  final userService = UserServiceIml(UserRepository());
  final bannerService = BannerServiceIml();

  @override
  Future<List<ProductModel>?> getAllProducts() async {
    return await productService.getAllProducts();
  }

  @override
  Future<List<ProductModel>> getFavoriteProducts(String uid) async {
    return await favoriteService.getFavoriteProducts(uid);
  }

  @override
  Future<BannerModel> getBanners() async {
    return await bannerService.getAllBanners();
  }

  @override
  Future<List<ProductModel>> getHistoryProducts(String uid) async {
    return await historyService.getHistoryProducts(uid);
  }

  @override
  Future<List<ProductModel>> getOrderProducts(String uid) async {
    return await orderService.getOrderProducts(uid);
  }

  @override
  Future<UserModel> getUserInfo(String uid) async {
    return await userService.getUser(uid);
  }

  @override
  Future<bool> updateFavoriteProducts(
      String uid, FavoriteModel favoriteModel) async {
    return await favoriteService.updateFavoriteProducts(uid, favoriteModel);
  }

  @override
  Future<bool> updateHistoryProducts(
      String uid, HistoryModel historyModel) async {
    return await historyService.updateHistoryProducts(uid, historyModel);
  }

  @override
  Future<bool> updateOrderProducts(String uid, OrderModel orderModel) async {
    return await orderService.updateOrderProducts(uid, orderModel);
  }

  @override
  Future<bool> updateUserInfo(UserModel userModel) async {
    return await userService.updateUserInfo(userModel);
  }
}
