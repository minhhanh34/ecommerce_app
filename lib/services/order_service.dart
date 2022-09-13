import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/order_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/repository/repository_interface.dart';

abstract class OrderService {
  Future<List<ProductModel>> getOrderProducts(String uid);
  Future<bool> updateOrderProducts(String uid, List<ProductModel> products);
}

class OrderServiceIml implements OrderService {
  Repository<OrderModel> orderRepository;
  Repository<ProductModel> productRepository;
  OrderServiceIml(this.orderRepository, this.productRepository);
  @override
  Future<List<ProductModel>> getOrderProducts(String uid) async {
    final products = <ProductModel>[];
    final docSnap = await orderRepository.getQueryDocumentSnapshot(uid);
    final orderModel = await orderRepository.getOne(docSnap.id);
    final prodsRef = orderModel.order;
    for (var ref in prodsRef!.values) {
      final prodData =
          await (ref as DocumentReference<Map<String, dynamic>>).get();
      final product = ProductModel.fromJson(prodData.data()!);
      products.add(product);
    }
    return products;
  }

  @override
  Future<bool> updateOrderProducts(
      String uid, List<ProductModel> products) async {
    final map = <String, DocumentReference>{};
    for (int i = 0; i < products.length; i++) {
      final docQuery =
          await productRepository.getQueryDocumentSnapshot(products[i].name);
      map.addAll({'product${i + 1}': docQuery.reference});
    }
    final favoriteModel = OrderModel(uid: uid, order: map);
    final cartQuery = await orderRepository.getQueryDocumentSnapshot(uid);
    return await orderRepository.update(cartQuery.id, favoriteModel);
  }
}
