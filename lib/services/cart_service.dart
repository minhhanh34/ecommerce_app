import 'package:ecommerce_app/model/cart_model.dart';
import 'package:ecommerce_app/repository/product_repository.dart';
import 'package:ecommerce_app/services/firebase_service.dart';

abstract class CartService extends Service {
  Future<CartModel> getCart({required String userId});
}

class CartServiceIml implements CartService {
  Repository<CartModel> repository;

  CartServiceIml({required this.repository});

  @override
  Future<CartModel> getCart({required String userId}) async {
    return await repository.getOne(userId);
  }
}
