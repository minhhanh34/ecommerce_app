import 'package:ecommerce_app/model/banner_model.dart';
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
  Future<bool> updateFavoriteProducts(String uid, List<ProductModel> products);
  Future<List<OrderModel>> getOrderProducts(String uid);
  Future<bool> updateOrderProducts(OrderModel order);
  Future<List<OrderModel>> getHistoryOrders(String uid);
  Future<bool> updateHistoryProducts(String uid, List<ProductModel> products);
  Future<UserModel> getUserInfo(String uid);
  Future<bool> updateUserInfo(UserModel userModel);
  // Future<List<OrderModel>> getUserOrders(String uid);
}

class HomeServiceIml implements HomeService {
  final productService = ProductServiceIml(ProductRepository());
  final favoriteService =
      FavoriteServiceIml(FavoriteRepository(), ProductRepository());
  final orderService = OrderServiceIml(OrderRepository(), ProductRepository());
  final historyService =
      HistoryServiceIml(HistoryRepository(), ProductRepository());
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
  Future<List<OrderModel>> getHistoryOrders(String uid) async {
    return await historyService.getHistoryOrders(uid);
  }

  @override
  Future<List<OrderModel>> getOrderProducts(String uid) async {
    return await orderService.getUserOrder(uid);
  }

  @override
  Future<UserModel> getUserInfo(String uid) async {
    return await userService.getUser(uid);
  }

  @override
  Future<bool> updateFavoriteProducts(
      String uid, List<ProductModel> products) async {
    return await favoriteService.updateFavoriteProducts(uid, products);
  }

  @override
  Future<bool> updateHistoryProducts(
      String uid, List<ProductModel> products) async {
    return await historyService.updateHistoryProducts(uid, products);
  }

  @override
  Future<bool> updateOrderProducts(OrderModel order) async {
    return await orderService.updateOrderProducts(order.id, order);
  }

  @override
  Future<bool> updateUserInfo(UserModel userModel) async {
    return await userService.updateUserInfo(userModel);
  }

  // @override
  // Future<List<OrderModel>> getUserOrders(String uid) async {
  //   final docs = await (orderService.orderRepository as OrderRepository)
  //       .collection
  //       .where('uid', isEqualTo: uid)
  //       .get();
  //   final orders =
  //       docs.docs.map((order) => OrderModel.fromJson(order.data())).toList();
  //   for (var order in orders) {
  //     await order.build();
  //   }
  //   return orders;
  // }
}
