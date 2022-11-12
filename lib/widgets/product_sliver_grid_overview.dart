import 'package:flutter/material.dart';

import '../model/product_model.dart';
import 'product_grid_tile.dart';

class ProductSliverGridOverview extends StatelessWidget {
  const ProductSliverGridOverview({
    Key? key,
    required this.products,
    this.isAdmin = false,
  }) : super(key: key);

  final List<ProductModel> products;
  final bool isAdmin;
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        childCount: products.length,
        (context, index) => ProductWidget(
          product: products[index],
          isAdmin: isAdmin,
        ),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisExtent: 250.0),
    );
  }
}
