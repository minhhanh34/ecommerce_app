part of 'admin_cubit.dart';

@immutable
abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminProgressOrders extends AdminState {
  final List<OrderModel> orders;
  AdminProgressOrders(this.orders);
}

class AdminFinishedOrders extends AdminState {
  AdminFinishedOrders(this.orders);
  final List<OrderModel> orders;
}

class AdminLoading extends AdminState {}

class AdminLogout extends AdminState {}

class AdminAllProducts extends AdminState {
  final List<ProductModel> products;
  AdminAllProducts(this.products);
}

class AdminProductAddition extends AdminState {}

class AdminDetailProduct extends AdminState {
  final ProductModel product;
  AdminDetailProduct(this.product);
}
