import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/cubit/admin/admin_cubit.dart';
import 'package:ecommerce_app/cubit/home/home_cubit.dart';
import 'package:ecommerce_app/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../utils/price_format.dart';

class OrderListTile extends StatefulWidget {
  const OrderListTile(
    this.order, {
    super.key,
    this.isAdmin = false,
    this.isFinish = false,
  });
  final OrderModel order;
  final bool isAdmin;
  final bool isFinish;
  @override
  State<OrderListTile> createState() => _OrderListTileState();
}

class _OrderListTileState extends State<OrderListTile> {
  Future<void> cancelOrder(OrderModel order) async {
    context.read<HomeCubit>().cancelOrder(order);
  }

  bool visible() {
    if (widget.isAdmin && widget.isFinish) {
      return widget.order.status.toLowerCase() == 'đã giao hàng';
    }
    if (widget.isAdmin && !widget.isFinish) {
      return widget.order.status.toLowerCase() != 'đã giao hàng';
    }

    return widget.order.status.toLowerCase() != 'đã giao hàng';
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final adminCubit = context.read<AdminCubit>();
    return Visibility(
      visible: visible(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '  ${DateFormat('dd/MM/yyyy').format(widget.order.date)}',
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
                  Row(
                    children: [
                      Text('Trạng thái: ${widget.order.status}'),
                      const Spacer(),
                      Visibility(
                        visible: widget.isAdmin,
                        child: PopupMenuButton(
                          icon: const Icon(Icons.expand_circle_down_outlined),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                onTap: () async {
                                  final newOrder = widget.order.copyWith(
                                    status: 'Chờ xác nhận',
                                  );
                                  adminCubit.updateOrder(newOrder);
                                  setState(() {
                                    widget.order.status = 'Chờ xác nhận';
                                  });
                                  adminCubit.createNotification(newOrder);
                                },
                                child: const Text('Chờ xác nhận'),
                              ),
                              PopupMenuItem(
                                onTap: () async {
                                  final newOrder = widget.order.copyWith(
                                    status: 'Đang đóng gói',
                                  );
                                  adminCubit.updateOrder(newOrder);
                                  setState(() {
                                    widget.order.status = 'Đang đóng gói';
                                  });
                                  adminCubit.createNotification(newOrder);
                                },
                                child: const Text('Đang đóng gói'),
                              ),
                              PopupMenuItem(
                                onTap: () async {
                                  final newOrder = widget.order.copyWith(
                                    status: 'Đang vận chuyển',
                                  );
                                  adminCubit.updateOrder(newOrder);
                                  setState(() {
                                    widget.order.status = 'Đang vận chuyển';
                                  });
                                  adminCubit.createNotification(newOrder);
                                },
                                child: const Text('Đang vận chuyển'),
                              ),
                              PopupMenuItem(
                                onTap: () async {
                                  final newOrder = widget.order.copyWith(
                                    status: 'Đã giao hàng',
                                  );
                                  adminCubit.updateOrder(newOrder);
                                  setState(() {
                                    widget.order.status = 'Đã giao hàng';
                                  });
                                  adminCubit.createNotification(newOrder);
                                },
                                child: const Text('Đã giao hàng'),
                              ),
                            ];
                          },
                          // child: Text('Trạng thái: ${widget.order.status}'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Mã đơn hàng: ${widget.order.id}'),
                  const SizedBox(height: 8.0),
                  const Divider(color: Colors.black),
                  for (var prod in widget.order.order)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          isThreeLine: true,
                          leading: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 60,
                              maxWidth: 60,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: prod['imageURL'],
                            ),
                          ),
                          title: Text(
                            prod['product'].name,
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  const Text('Màu: '),
                                  const SizedBox(width: 8.0),
                                  CircleAvatar(
                                    backgroundColor: Colors.grey.shade300,
                                    radius: 11.0,
                                    child: CircleAvatar(
                                      radius: 10.0,
                                      backgroundColor:
                                          Color(int.parse(prod['color'])),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Bộ nhớ:'),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    prod['memory'],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Text('SL: ${prod["quantity"]}'),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            PriceHealper.format(
                              prod['price'],
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.red),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  const Divider(color: Colors.black),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Tổng cộng: '),
                      const SizedBox(width: 10),
                      Text(
                        PriceHealper.format(
                          PriceHealper.totalPrice(widget.order.order),
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8.0),
                  Text('Địa chỉ giao hàng: ${widget.order.address}'),
                  const SizedBox(height: 8.0),
                  Text(
                    'Người nhận: ${widget.order.recipient}',
                  ),
                  const SizedBox(height: 8.0),
                  Visibility(
                    visible: widget.isAdmin
                        ? false
                        : widget.order.status.toLowerCase() == 'chờ xác nhận',
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () async {
                          bool confirm = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Xác nhận'),
                                content: const Text('Bạn có chắc muốn hủy?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('No'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (confirm) {
                            cancelOrder(widget.order);
                            scaffoldMessenger
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                    content: Text('Đã hủy đơn hàng!')),
                              );
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
      ),
    );
  }
}
