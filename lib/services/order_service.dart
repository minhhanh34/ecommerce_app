import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/order_model.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/repository/repository_interface.dart';
import 'package:ecommerce_app/utils/libs.dart';

abstract class OrderService {
  Future<List<OrderModel>> getOrders();
  Future<bool> updateOrderProducts(String uid, OrderModel products);
  Future<bool> remove(OrderModel order);
  Future<OrderModel> addOrder(OrderModel order);
  Future<bool> updateOrder(OrderModel order);
  Future<List<OrderModel>> getFinishedOrders();
  Future<List<OrderModel>> getProgressOrders();
}

class OrderServiceIml implements OrderService {
  Repository<OrderModel> orderRepository;
  Repository<ProductModel> productRepository;
  OrderServiceIml(this.orderRepository, this.productRepository);
  @override
  Future<List<OrderModel>> getOrders() async {
    // final products = <ProductModel>[];
    // final docSnap = await orderRepository.getQueryDocumentSnapshot(uid);
    // final orderModel = await orderRepository.getOne(docSnap.id);
    // final prodsRef = orderModel.order;
    // for (var ref in prodsRef.values) {
    //   final prodData =
    //       await (ref as DocumentReference<Map<String, dynamic>>).get();
    //   final product = ProductModel.fromJson(prodData.data()!);
    //   products.add(product);
    // }
    // return products;
    final orders = await orderRepository.list();
    for (var order in orders) {
      await order.build();
    }
    return orders;
  }

  @override
  Future<List<OrderModel>> getProgressOrders() async {
    final docs = await (orderRepository as OrderRepository)
        .collection
        .where('status', isNotEqualTo: 'Đã giao hàng')
        .get();
    final orders =
        docs.docs.map((order) => OrderModel.fromJson(order.data())).toList();
    for (var order in orders) {
      await order.build();
    }
    return orders;
  }

  Future<List<OrderModel>> getUserOrder(String uid) async {
    List<OrderModel> orders = [];
    final docs = await FirebaseFirestore.instance
        .collection('order')
        .where('uid', isEqualTo: uid)
        .get();
    for (var doc in docs.docs) {
      final orderModal = OrderModel.fromJson(doc.data());
      await orderModal.build();
      orders.add(orderModal);
    }
    return orders;
  }

  @override
  Future<bool> updateOrderProducts(String id, OrderModel order) async {
    return await orderRepository.update(order.id, order);

    // final map = <String, DocumentReference>{};
    // for (int i = 0; i < products.length; i++) {
    //   final docQuery =
    //       await productRepository.getQueryDocumentSnapshot(products[i].name);
    //   map.addAll({'product${i + 1}': docQuery.reference});
    // }
    // final favoriteModel = OrderModel(uid: uid, order: /*map*/[]);
    // final cartQuery = await orderRepository.getQueryDocumentSnapshot(uid);
    // return await orderRepository.update(cartQuery.id, favoriteModel);
  }

  @override
  Future<bool> remove(OrderModel order) async {
    return await orderRepository.delete(order.id);
  }

  @override
  Future<OrderModel> addOrder(OrderModel order) async {
    final resultOrder = await orderRepository.create(order);
    await resultOrder.build();
    return resultOrder;
  }

  @override
  Future<bool> updateOrder(OrderModel order) async {
    return await orderRepository.update(order.id, order);
  }

  @override
  Future<List<OrderModel>> getFinishedOrders() async {
    final docs = await (orderRepository as OrderRepository)
        .collection
        .where('status'.toLowerCase(), isEqualTo: 'Đã giao hàng')
        .get();
    final orders = docs.docs
        .map((orderSnapshot) => OrderModel.fromJson(orderSnapshot.data()))
        .toList();
    for (var order in orders) {
      await order.build();
    }
    return orders;
  }
}
