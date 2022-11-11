import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/widgets/home_container.dart';
import 'package:flutter/material.dart';

class ProductOverviewScreen extends StatelessWidget {
  const ProductOverviewScreen(this.products, {super.key});
  final List<ProductModel> products;
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
          ProductSliverGridOverview(products: products, isAdmin: true),
        ],
      ),
    );
  }
}
