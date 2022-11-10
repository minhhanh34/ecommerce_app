import 'package:ecommerce_app/cubit/cart/cart_cubit.dart';
import 'package:ecommerce_app/cubit/home/home_cubit.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/screen/product_page.dart';
import 'package:ecommerce_app/utils/alert_dialog.dart';
import 'package:ecommerce_app/utils/price_format.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/header_row.dart';
import 'package:flutter/material.dart';

class FavoriteProductContainer extends StatefulWidget {
  const FavoriteProductContainer({Key? key, required this.favoritedProducts})
      : super(key: key);
  final List<ProductModel> favoritedProducts;
  @override
  State<FavoriteProductContainer> createState() =>
      _FavoriteProductContainerState();
}

class _FavoriteProductContainerState extends State<FavoriteProductContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade100,
      child: Column(
        children: [
          HeaderRow(title: 'Sản phẩm yêu thích'),
          Expanded(
            child: RefreshIndicator(
              onRefresh: context.read<HomeCubit>().favoriteRefresh,
              child: ListView.builder(
                itemCount: widget.favoritedProducts.length,
                itemBuilder: (context, index) {
                  ProductModel product = widget.favoritedProducts[index];
                  return Dismissible(
                    key: Key(product.name),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (context) => const CustomAlertDialog(
                          title: 'Xác nhận',
                          content: 'Bạn có chắc muốn xóa?',
                        ),
                      );
                    },
                    background: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      context.read<HomeCubit>().removeFavoriteProduct(product);
                    },
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductPage(product: product),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Card(
                          borderOnForeground: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 2,
                          child: ListTile(
                            leading: Hero(
                              tag: product.name,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: 60,
                                  maxWidth: 60,
                                ),
                                child: product.images['image1']!,
                              ),
                            ),
                            isThreeLine: true,
                            title: Text(
                              product.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  PriceHealper.format(product.price),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(color: Colors.red),
                                ),
                                Row(
                                  children: [
                                    for (int i = 0; i < product.grade; i++)
                                      const Icon(
                                        Icons.star,
                                        size: 14,
                                        color: Colors.yellow,
                                      ),
                                    const Spacer(),
                                    Text('đã bán: ${product.sold}'),
                                    // const Spacer(),
                                    // IconButton(
                                    //   onPressed: () {},
                                    //   icon: const Icon(
                                    //       Icons.add_shopping_cart_rounded),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              color: Colors.pink.shade900,
                              onPressed: () {
                                BlocProvider.of<CartCubit>(context)
                                    .addItem(product);
                              },
                              icon: const Icon(
                                Icons.add_shopping_cart_outlined,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
