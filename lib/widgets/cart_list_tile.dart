import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cart/cart_cubit.dart';
import '../model/cart_item.dart';
import '../screen/product_page.dart';
import '../utils/price_format.dart';

class CartListTile extends StatefulWidget {
  const CartListTile(this.item, {Key? key}) : super(key: key);
  final CartItem item;

  @override
  State<CartListTile> createState() => _CartListTileState();
}

class _CartListTileState extends State<CartListTile> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ObjectKey(widget.item),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.red,
        ),
        child: const Center(
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) {
            return const CustomAlertDialog(
              title: 'Xác nhận',
              content: 'Bạn có chắc muốn sản phẩm này ra khỏi giỏ hàng?',
            );
          },
        );
      },
      onDismissed: (_) => context.read<CartCubit>().removeItem(widget.item),
      child: Row(
        children: [
          const SizedBox(height: 8.0),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    isThreeLine: true,
                    leading: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) =>
                                  ProductPage(product: widget.item.product!)),
                        );
                      },
                      child: SizedBox(
                        width: 80.0,
                        height: 80.0,
                        child: CachedNetworkImage(
                          imageUrl: widget.item.imageURL,
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Icon(Icons.image),
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      widget.item.product!.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          PriceHealper.format(widget.item.price),
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                        ),
                        Row(
                          children: [
                            const Text('Màu:'),
                            const SizedBox(width: 8.0),
                            CircleAvatar(
                              radius: 11.0,
                              backgroundColor: Colors.black45,
                              child: CircleAvatar(
                                radius: 10.0,
                                backgroundColor:
                                    Color(int.parse(widget.item.color)),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Bộ nhớ:'),
                            const SizedBox(width: 8.0),
                            Text(widget.item.memory),
                            const Spacer(),
                            Row(
                              children: [
                                const Text('SL: '),
                                InkWell(
                                  onTap: () async {
                                    if (widget.item.quantity <= 1) return;
                                    await context
                                        .read<CartCubit>()
                                        .updateCartItem(
                                          widget.item.copyWith(
                                            quantity: --widget.item.quantity,
                                          ),
                                        );
                                  },
                                  child: const Icon(Icons.remove_rounded),
                                ),
                                Text(widget.item.quantity.toString()),
                                InkWell(
                                  onTap: () async {
                                    await context
                                        .read<CartCubit>()
                                        .updateCartItem(
                                          widget.item.copyWith(
                                            quantity: ++widget.item.quantity,
                                          ),
                                        );
                                  },
                                  child: const Icon(Icons.add_rounded),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
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
