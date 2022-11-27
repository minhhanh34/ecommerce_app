import 'package:ecommerce_app/model/product_model.dart';
import 'package:flutter/material.dart';

import '../widgets/product_sliver_grid_overview.dart';
import '../widgets/search_screen.dart';

class ProductOverviewScreen extends StatelessWidget {
  const ProductOverviewScreen(this.products, {super.key, this.isAdmin = false});
  final List<ProductModel> products;
  final bool isAdmin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0.0,
            title: const Text('Tất cả sản phẩm'),
            floating: true,
            actions: [
              IconButton(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: SearchScreen(products, isAdmin: isAdmin),
                  );
                },
                icon: const Icon(Icons.search_rounded),
              )
            ],
          ),
          ProductSliverGridOverview(products: products, isAdmin: isAdmin),
        ],
      ),
    );
  }
}
