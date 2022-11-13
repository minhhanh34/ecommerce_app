import 'package:ecommerce_app/cubit/home/home_cubit.dart';
import 'package:ecommerce_app/model/order_model.dart';
import 'package:ecommerce_app/widgets/empty_item.dart';
import 'package:ecommerce_app/widgets/header_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryContainer extends StatefulWidget {
  const HistoryContainer({Key? key, required this.historyOrders})
      : super(key: key);
  final List<OrderModel> historyOrders;
  @override
  State<HistoryContainer> createState() => _HistoryContainerState();
}

class _HistoryContainerState extends State<HistoryContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
      ),
      child: Column(
        children: [
          HeaderRow(title: 'Lịch sử mua hàng'),
          Visibility(
            visible: widget.historyOrders.isEmpty,
            child: const Expanded(
              child: EmptyItem(
                message: 'Bạn chưa có lịch sửa mua hàng',
                child: Icon(
                  Icons.remove_shopping_cart_outlined,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.historyOrders.isNotEmpty,
            child: Expanded(
              child: RefreshIndicator(
                onRefresh: () => context.read<HomeCubit>().historyRefresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  itemCount: widget.historyOrders.length,
                  itemBuilder: (context, index) {
                    final orders = widget.historyOrders[index].order;
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const SizedBox(height: 8.0),
                          ListTile(
                            leading: const Text('Mã đơn hàng:'),
                            trailing:
                                Text('  ${widget.historyOrders[index].id}'),
                          ),
                          const Divider(),
                          for (var order in orders)
                            ListTile(
                              // contentPadding: EdgeInsets.zero,
                              leading: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 80.0,
                                  maxHeight: 80.0,
                                ),
                                child: order['product'].images['image1'],
                              ),
                              title: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(order['product'].name),
                              ),
                              subtitle: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 13.0,
                                    backgroundColor: Colors.black54,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(int.parse(order['color'])),
                                        shape: BoxShape.circle,
                                      ),
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Text('${order["memory"]}')
                                ],
                              ),
                              trailing: Text('SL: ${order["quantity"]}  '),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
