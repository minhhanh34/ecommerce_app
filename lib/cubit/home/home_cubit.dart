import 'dart:developer';

import 'package:ecommerce_app/cubit/notification/notification_cubit.dart';
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
    required this.notificationCubit,
  }) : super(InitialState());
  HomeService homeService;
  FavoriteService favoriteService;
  CartCubit cartCubit;
  OrderService orderService;
  UserService userService;
  NotificationCubit notificationCubit;

  int navIndex = 0;

  String? uid;

  List<ProductModel>? products;
  List<ProductModel>? favoriteProducts;
  List<OrderModel>? orders;
  List<OrderModel>? historyOrders;
  UserModel? user;
  BannerModel? banners;

  List<String>? get favoriteProductNames =>
      favoriteProducts?.map((product) => product.name).toList();

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

  // void onAddProduct() {
  //   emit(HomeProductAddition());
  // }

  Future<void> getNotification() async {
    notificationCubit.onNotification();
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

  Future<OrderModel> addOrder(OrderModel order) async {
    final resultOrder = await orderService.addOrder(order);
    int firstIndex = 0;
    orders?.insert(firstIndex, resultOrder);
    return resultOrder;
  }

  Future<UserModel> userRefresh() async {
    user = null;
    final spref = await SharedPreferences.getInstance();
    final uid = spref.getString('uid');
    user = await getUserInfo(uid!);
    emit(AccountState(user!));
    return user!;
  }

  Future<List<ProductModel>> getFavoriteProduct() async {
    try {
      final spref = await SharedPreferences.getInstance();
      uid = spref.getString('uid');
      favoriteProducts = await homeService.getFavoriteProducts(uid!);
    } catch (error) {
      log('error', error: error);
    }
    return favoriteProducts ?? <ProductModel>[];
  }

  Future<void> addFavoriteProduct(ProductModel product) async {
    final spref = await SharedPreferences.getInstance();
    final uid = spref.getString('uid');
    favoriteProducts ??= await getFavoriteProduct();
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
    if (products == null || banners == null) {
      emit(LoadingState());
      banners = await homeService.getBanners();
      products = await homeService.getAllProducts();
      await cartCubit.getCart();
      await notificationCubit.onNotification();
      if (navIndex == 0) {
        emit(
          MainState(
            banners: banners!,
            products: products!,
          ),
        );
      }
    } else {
      emit(MainState(
        banners: banners!,
        products: products!,
      ));
    }
  }

  Future<void> mainRefresh() async {
    products = null;
    banners = null;
    mainTab();
  }

  Future<void> orderTab() async {
    if (orders == null) {
      emit(LoadingState());
      final spref = await SharedPreferences.getInstance();
      final uid = spref.getString('uid');
      orders = await homeService.getOrderProducts(uid!);
      orders
        ?..removeWhere((order) => order.status.toLowerCase() == 'đã giao hàng')
        ..sort((a, b) => b.date.compareTo(a.date));
      if (navIndex == 2) {
        emit(OrderState(orders!));
      }
    } else {
      emit(OrderState(orders!));
    }
  }

  Future<void> historyTab() async {
    if (historyOrders == null) {
      emit(LoadingState());
      final spref = await SharedPreferences.getInstance();
      final uid = spref.getString('uid');
      historyOrders = await homeService.getHistoryOrders(uid!);
      historyOrders?.removeWhere(
          (order) => order.status.toLowerCase() != 'đã giao hàng');
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
    orders?.remove(order);
    emit(OrderState(orders!));
    await orderService.remove(order);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    banners = null;
    products = null;
    favoriteProducts = null;
    orders = null;
    historyOrders = null;
    user = null;
    cartCubit.cartItems = null;
    navIndex = 0;
    notificationCubit.dispose();
    cartCubit.emit(CartInitial());
    emit(LogoutState());
    emit(InitialState());
  }

  void onDetailProduct(ProductModel product) {
    final oldState = state;
    emit(ProductDetail(product));
    emit(oldState);
    // emit(MainState(banners: banners!, products: products!));
  }

  void onCartTab() {
    emit(CheckCartState());
  }

  Future<void> orderRefresh() async {
    orders = null;
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
    final isSuccess = await userService.updateUserInfo(user);
    if (isSuccess) {
      this.user = user;
    }
    return isSuccess;
  }

  void onAllProduct() async {
    products ??= await homeService.getAllProducts();
    emit(AllProducts(products!));
  }

  void productsByBrand(String brand) {
    final productsByBrand = products
        ?.where((product) =>
            product.name.toLowerCase().contains(brand.toLowerCase()))
        .toList();

    emit(ProductsByBrand(productsByBrand ?? [], brand));
    emit(MainState(banners: banners!, products: products!));
  }

  void onAvatarView(UserModel user) {
    emit(AvatarView(user));
    int accountTab = 4;
    navIndex = accountTab;
    emit(AccountState(user));
  }

  void toNotificationScreen() {
    final oldState = state;
    emit(HomeNotification());
    emit(oldState);
  }

  toChangePasswordScreen() {
    final oldState = state;
    emit(HomeChangePassword());
    emit(oldState);
  }

  Future<void> refreshAccount() async {
    emit(LoadingState());
    user = null;
    final spref = await SharedPreferences.getInstance();
    final uid = spref.getString('uid');
    user = await getUserInfo(uid!);
    emit(AccountState(user!));
  }
}
