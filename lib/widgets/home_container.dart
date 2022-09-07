
import 'package:ecommerce_app/model/banner_model.dart';
import 'package:flutter/material.dart';

import '../widgets/products_catalog.dart';
import '../model/product_model.dart';
import 'banner.dart';
import 'header_row.dart';
import 'product_widget.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({Key? key, required this.banners, required this.products})
      : super(key: key);
  final BannerModel banners;
  final List<ProductModel> products;

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  @override
  Widget build(BuildContext context) {
    var column = Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        HeaderBanner(model: widget.banners),
        const HeaderRow(
          title: 'Danh mục',
          hasMore: true,
        ),
        const ProductsCatalog(),
        const HeaderRow(
          title: 'Sản phẩm gợi ý',
          hasMore: true,
        ),
        // Expanded(
        //   child: ProductsWidget(products: widget.products),
        // ),
      ],
    );
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([column]),
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            childCount: widget.products.length,
            (context, index) =>
                ProductWidget(product: widget.products[index]),
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
        ),
      ],
    );
  }
}
