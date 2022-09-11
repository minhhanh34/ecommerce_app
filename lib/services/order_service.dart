import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/order_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/repository/repository_interface.dart';

abstract class OrderService {
  Future<List<ProductModel>> getOrderProducts(String uid);
  Future<bool> updateOrderProducts(String uid, OrderModel orderModel);
}

class OrderServiceIml implements OrderService {
  Repository<OrderModel> repository;
  OrderServiceIml(this.repository);
  @override
  Future<List<ProductModel>> getOrderProducts(String uid) async {
    final products = <ProductModel>[];
    final docID = await repository.getDocumentID(uid);
    final orderModel = await repository.getOne(docID);
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
  Future<bool> updateOrderProducts(String uid, OrderModel orderModel) async {
    return await repository.update(uid, orderModel);
  }
}
