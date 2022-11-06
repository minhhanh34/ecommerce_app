import 'package:ecommerce_app/cubit/home/home_cubit.dart';
import 'package:ecommerce_app/cubit/home/home_state.dart';
import 'package:ecommerce_app/utils/price_format.dart';
import 'package:ecommerce_app/widgets/header_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../model/order_model.dart';

class OrderContainer extends StatefulWidget {
  const OrderContainer({Key? key, required this.orders}) : super(key: key);
  final List<OrderModel> orders;

  @override
  State<OrderContainer> createState() => _OrderContainerState();
}

class _OrderContainerState extends State<OrderContainer> {
  int totalPrice(List<Map<String, dynamic>> order) {
    int total = 0;
    for (var prod in order) {
      total += (prod['product'].price as int) * (prod['quantity'] as int);
    }
    return total;
  }

  void cancelOrder(OrderModel order) {
    context.read<HomeCubit>().cancelOrder(order);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade100,
      child: Column(
        children: [
          HeaderRow(title: 'Đơn hàng của bạn'),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is OrderState) {
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async =>
                        context.read<HomeCubit>().orderRefresh(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 4.0),
                      itemCount: state.orders.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '  ${DateFormat('dd/MM/yyyy')
                                  .format(state.orders[index].date)}',
                              style: const TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              margin: const EdgeInsets.all(12.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                        'Trạng thái: ${state.orders[index].status}'),
                                    const SizedBox(height: 4),
                                    Text(
                                        'Mã đơn hàng: ${state.orders[index].id}'),
                                    const SizedBox(height: 8.0),
                                    Text('Địa chỉ giao hàng: ${state.orders[index].address}'),
                                    const SizedBox(height: 8.0),
                                    for (var prod in state.orders[index].order)
                                      Card(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              isThreeLine: true,
                                              leading: ConstrainedBox(
                                                constraints:
                                                    const BoxConstraints(
                                                  maxHeight: 60,
                                                  maxWidth: 60,
                                                ),
                                                child: prod['product']
                                                    .images['image1'],
                                              ),
                                              title: Text(
                                                prod['product'].name,
                                              ),
                                              subtitle: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text('Màu: '),
                                                      const SizedBox(
                                                          width: 8.0),
                                                      Container(
                                                        width: 12,
                                                        height: 12,
                                                        color: Color(int.parse(
                                                            prod['color'])),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text('Bộ nhớ:'),
                                                      const SizedBox(
                                                          width: 8.0),
                                                      Text(
                                                        prod['memory'],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              trailing: Text(
                                                  'SL: ${prod["quantity"]}'),
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                PriceFormat.format(
                                                    prod['product'].price *
                                                        prod['quantity']),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                        color: Colors.red),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Text('Tổng cộng: '),
                                        const SizedBox(width: 10),
                                        Text(
                                          PriceFormat.format(
                                            totalPrice(
                                                state.orders[index].order),
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Thanh toán khi nhận hàng',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const SizedBox(height: 10),
                                    Visibility(
                                      visible: state.orders[index].status
                                              .toLowerCase() ==
                                          'chờ xác nhận',
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () async {
                                            bool confirm = await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text('Xác nhận'),
                                                  content: const Text(
                                                      'Bạn có chắc muốn xóa?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
                                                      child: const Text('Yes'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child: const Text('No'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            if (confirm) {
                                              cancelOrder(state.orders[index]);
                                            }
                                          },
                                          child: const Text('Hủy'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              }
              return const Text('error');
            },
          ),
        ],
      ),
    );
  }
}
