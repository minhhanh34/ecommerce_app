import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/model/order_model.dart';
import 'package:ecommerce_app/utils/price_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RevenueScreen extends StatelessWidget {
  const RevenueScreen({
    super.key,
    required this.revenue,
    required this.orders,
  });
  final int revenue;
  final List<OrderModel> orders;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text('Doanh thu'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  for (var order in orders)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16.0),
                        Text(
                          DateFormat('dd/MM/yyyy').format(order.date),
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 18.0),
                        for (var orderField in order.order)
                          Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: SizedBox(
                                  width: 80.0,
                                  height: 80.0,
                                  child: CachedNetworkImage(
                                    imageUrl: orderField['imageURL'],
                                  ),
                                ),
                              ),
                              title: Text(orderField['product'].name),
                              subtitle: Text(orderField['memory']),
                              trailing: Text(
                                PriceHealper.compactFormat(orderField['price']),
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 16.0),
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 16.0),
            ),
            SliverToBoxAdapter(
              child: Row(
                children: [
                  const SizedBox(width: 8.0),
                  const Text(
                    'Tổng cộng:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    PriceHealper.format(revenue),
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
