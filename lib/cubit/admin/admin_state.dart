part of 'admin_cubit.dart';

@immutable
abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminOrders extends AdminState {
  final List<OrderModel> orders;
  AdminOrders(this.orders);
}
