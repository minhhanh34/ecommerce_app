import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/widgets/product_sliver_grid_overview.dart';
import 'package:flutter/material.dart';

class ProductsByBrandScreen extends StatelessWidget {
  const ProductsByBrandScreen(
    this.products,
    this.brand, {
    super.key,
  });
  final List<ProductModel> products;
  final String brand;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(brand),
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 10.0)),
          ProductSliverGridOverview(products: products),
        ],
      ),
    );
  }
}
