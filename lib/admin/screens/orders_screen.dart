import 'package:ecommerce_app/admin/components/orders_overview.dart';
import 'package:ecommerce_app/model/order_model.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen(this.orders, {super.key});
  final List<OrderModel> orders;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 56.0),
        child: SafeArea(
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              const SizedBox(width: 80.0),
              const Text(
                'Đơn hàng',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: OrdersOverview(orders, isAdmin: true),
    );
  }
}
