import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/widgets/home_container.dart';
import 'package:flutter/material.dart';

class AllProductsPage extends StatelessWidget {
  const AllProductsPage({Key? key, required this.products}) : super(key: key);
  final List<ProductModel> products;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Tất cả sản phẩm'),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(height: 8.0),
          ),
          ProductSliverGridOverview(products: products),
          const SliverToBoxAdapter(
            child: SizedBox(height: 8.0),
          ),
        ],
      ),
    );
  }
}
