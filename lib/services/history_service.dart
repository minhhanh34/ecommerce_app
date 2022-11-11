import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/history_model.dart';
import 'package:ecommerce_app/model/order_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/repository/order_repository.dart';
import 'package:ecommerce_app/repository/product_repository.dart';
import 'package:ecommerce_app/services/order_service.dart';

import '../repository/repository_interface.dart';

abstract class HistoryService {
  Future<List<OrderModel>> getHistoryOrders(String uid);
  Future<bool> updateHistoryProducts(String uid, List<ProductModel> products);
}

class HistoryServiceIml implements HistoryService {
  Repository<HistoryModel> historyRepository;
  Repository<ProductModel> productRepository;
  HistoryServiceIml(this.historyRepository, this.productRepository);
  @override
  Future<List<OrderModel>> getHistoryOrders(String uid) async {
    final orderService =
        OrderServiceIml(OrderRepository(), ProductRepository());
    final orders = await orderService.getUserOrder(uid);
    return orders
        .where((order) => order.status.toLowerCase() == 'đã giao hàng')
        .toList();
  }

  @override
  Future<bool> updateHistoryProducts(
    String uid,
    List<ProductModel> products,
  ) async {
    final map = <String, DocumentReference>{};
    for (int i = 0; i < products.length; i++) {
      final docQuery =
          await productRepository.getQueryDocumentSnapshot(products[i].name);
      map.addAll({'product${i + 1}': docQuery.reference});
    }
    final favoriteModel = HistoryModel(uid: uid, historyRef: []);
    final cartQuery = await historyRepository.getQueryDocumentSnapshot(uid);
    return await historyRepository.update(cartQuery.id, favoriteModel);
  }
}
