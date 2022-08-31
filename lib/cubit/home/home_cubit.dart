import 'package:ecommerce_app/services/banner_service.dart';
import 'package:ecommerce_app/services/firebase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.bannerService, required this.productService})
      : super(LoadingState()) {
    mainTab();
  }
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

  void logout() {
    emit(LoadingState());
    emit(LogoutState());
  }
}
