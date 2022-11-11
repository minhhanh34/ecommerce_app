import 'package:ecommerce_app/model/cart_item.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/repository/cart_repository.dart';
import 'package:ecommerce_app/services/home_service.dart';
import '../repository/repository_interface.dart';

abstract class CartService extends Service {
  Future<List<CartItem>> getCart({required String userId});
  Future<bool> update(String id, CartItem cartItem);
  Future<bool> removeItem(CartItem item);
  Future<CartItem> addCartItem(CartItem item);
}

class CartServiceIml implements CartService {
  Repository<CartItem> cartRepository;
  Repository<ProductModel> prodRepository;
  CartServiceIml(this.cartRepository, this.prodRepository);

  @override
  Future<List<CartItem>> getCart({required String userId}) async {
    final cartItems =
        await (cartRepository as CartRepository).query('uid', userId);
    for (var item in cartItems) {
      await item.build();
    }
    return cartItems;
  }

  @override
  Future<bool> update(String uid, CartItem item) async {
    return await cartRepository.update(item.id, item);
  }

  @override
  Future<bool> removeItem(CartItem item) async {
    return await cartRepository.delete(item.id);
  }

  @override
  Future<CartItem> addCartItem(CartItem item) async {
    return await cartRepository.create(item);
  }
}
