import 'package:ecommerce_app/cubit/admin/admin_cubit.dart';
import 'package:ecommerce_app/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'order_list_tile.dart';

class OrdersOverview extends StatelessWidget {
  const OrdersOverview(
    this.orders, {
    Key? key,
    this.isAdmin = false,
    this.isFinish = false,
  }) : super(key: key);
  final List<OrderModel> orders;
  final bool isAdmin;
  final bool isFinish;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<AdminCubit>().refreshOrders(isFinish),
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return OrderListTile(
            orders[index],
            isAdmin: isAdmin,
            isFinish: isFinish,
          );
        },
      ),
    );
  }
}
