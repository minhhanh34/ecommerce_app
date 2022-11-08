import 'dart:developer';

import 'package:ecommerce_app/model/banner_model.dart';
import 'package:ecommerce_app/model/order_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/model/user_model.dart';
import 'package:ecommerce_app/services/favorite_service.dart';
import 'package:ecommerce_app/services/order_service.dart';
import 'package:ecommerce_app/services/user_service.dart';
import 'package:ecommerce_app/utils/libs.dart';

import '../../cubit/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.homeService,
    required this.favoriteService,
    required this.cartCubit,
    required this.orderService,
    required this.userService,
  }) : super(InitialState());
  HomeService homeService;
  FavoriteService favoriteService;
  CartCubit cartCubit;
  OrderService orderService;
  UserService userService;

  int navIndex = 0;

  List<ProductModel>? products;
  List<ProductModel>? favoriteProducts;
  List<OrderModel>? orderProducts;
  List<OrderModel>? historyOrders;
  UserModel? user;
  BannerModel? bannersData;

  Brightness _brightness = Brightness.light;

  Brightness get brightness => _brightness;

  set toggleBrightness(Brightness brightness) => _brightness = brightness;

  Future<void> favoriteTab() async {
    if (favoriteProducts == null) {
      emit(LoadingState());
      final favoriteProducts = await getFavoriteProduct();
      if (navIndex == 1) {
        emit(FavoriteState(favoritedProducts: favoriteProducts));
      }
    } else {
      emit(FavoriteState(favoritedProducts: favoriteProducts!));
    }
  }

  Future<void> favoriteRefresh() async {
    favoriteProducts = null;
    favoriteTab();
  }

  void goToTopScreen() async {
    emit(GoToTopScreen());
  }

  void editInfo(UserModel user) async {
    emit(InfoEdition(user));
    accountTab();
  }

  Future<void> userRefresh() async {
    user = null;
    final spref = await SharedPreferences.getInstance();
    final uid = spref.getString('uid');
    user = await getUserInfo(uid!);
    emit(AccountState(user!));
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
      if (navIndex == 0) {
        emit(
          MainState(
            banners: bannersData!,
            products: products!,
          ),
        );
      }
    } else {
      emit(MainState(
        banners: bannersData!,
        products: products!,
      ));
    }
  }

  Future<void> mainRefresh() async {
    products = null;
    bannersData = null;
    mainTab();
  }

  Future<void> orderTab() async {
    if (orderProducts == null) {
      emit(LoadingState());
      final spref = await SharedPreferences.getInstance();
      final uid = spref.getString('uid');
      orderProducts = await homeService.getOrderProducts(uid!);
      if (navIndex == 2) {
        emit(OrderState(orderProducts!));
      }
    } else {
      emit(OrderState(orderProducts!));
    }
  }

  Future<void> historyTab() async {
    if (historyOrders == null) {
      emit(LoadingState());
      final spref = await SharedPreferences.getInstance();
      final uid = spref.getString('uid');
      historyOrders = await homeService.getHistoryOrders(uid!);
      if (navIndex == 3) {
        emit(HistoryState(historyOrders!));
      }
    } else {
      emit(HistoryState(historyOrders!));
    }
  }

  Future<void> accountTab() async {
    if (user == null) {
      emit(LoadingState());
      final spref = await SharedPreferences.getInstance();
      final uid = spref.getString('uid');
      user = await homeService.getUserInfo(uid!);
      if (navIndex == 4) {
        emit(AccountState(user!));
      }
    } else {
      emit(AccountState(user!));
    }
  }

  Future<void> cancelOrder(OrderModel order) async {
    orderProducts?.remove(order);
    emit(OrderState(orderProducts!));
    await orderService.remove(order);
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('uid');
      bannersData = null;
      products = null;
      favoriteProducts = null;
      orderProducts = null;
      historyOrders = null;
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
      if (navIndex == 0) {
        emit(GoToTopScreen());
      }
      navIndex = 0;
      await mainTab();
    } else if (index == 1) {
      navIndex = 1;
      await favoriteTab();
    } else if (index == 2) {
      navIndex = 2;
      await orderTab();
    } else if (index == 3) {
      navIndex = 3;
      await historyTab();
    } else if (index == 4) {
      navIndex = 4;
      await accountTab();
    }
  }

  Future<void> historyRefresh() async {
    historyOrders = null;
    historyTab();
  }

  Future<UserModel> getUserInfo(String uid) async {
    return await userService.getUser(uid);
  }

  Future<bool> updateInfo(UserModel user) async {
    return await userService.updateUserInfo(user);
  }
}
