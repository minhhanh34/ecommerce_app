import 'package:ecommerce_app/model/product_model.dart';
import 'package:flutter/material.dart';

import '../widgets/product_sliver_grid_overview.dart';

class ProductOverviewScreen extends StatelessWidget {
  const ProductOverviewScreen(this.products, {super.key, this.isAdmin = false});
  final List<ProductModel> products;
  final bool isAdmin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            elevation: 0.0,
            title: Text('Tất cả sản phẩm'),
            floating: true,
          ),
          ProductSliverGridOverview(products: products, isAdmin: isAdmin),
        ],
      ),
    );
  }
}
