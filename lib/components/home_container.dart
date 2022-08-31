
import 'package:ecommerce_app/components/banner.dart';
import 'package:ecommerce_app/components/products_catalog.dart';
import 'package:ecommerce_app/components/products_widget.dart';
import 'package:ecommerce_app/model/banner_model.dart';
import 'package:flutter/material.dart';

import '../model/product_model.dart';
import 'banner.dart';
import 'header_row.dart';

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
    return SingleChildScrollView(
      child: Column(
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
          ProductsWidget(products: widget.products),
        ],
      ),
    );
  }
}
