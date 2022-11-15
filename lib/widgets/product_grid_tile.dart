import 'package:ecommerce_app/cubit/admin/admin_cubit.dart';
import 'package:ecommerce_app/cubit/home/home_cubit.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/utils/price_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    Key? key,
    required this.product,
    this.isAdmin = false,
  }) : super(key: key);
  final ProductModel product;
  final bool isAdmin;
  @override
  Widget build(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    final adminCubit = context.read<AdminCubit>();
    return InkWell(
      onTap: () {
        if (!isAdmin) {
          homeCubit.onDetailProduct(product);
          return;
        }
        adminCubit.onDetailProduct(product);
      },
      child: Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: product.name,
              child: SizedBox(
                height: 120.0,
                width: double.infinity,
                child: product.images['image1']!,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      left: 16.0,
                    ),
                    child: Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 12.0),
                      for (int i = 0; i < product.grade; i++)
                        const Icon(Icons.star, color: Colors.yellow),
                      // Text(product.grade.toString()),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text('Đã bán ${product.sold}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                      left: 16.0,
                    ),
                    child: Text(
                      PriceHealper.format(product.price),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
