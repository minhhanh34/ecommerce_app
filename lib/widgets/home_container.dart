import 'package:ecommerce_app/cubit/home/home_cubit.dart';
import 'package:ecommerce_app/cubit/home/home_state.dart';
import 'package:ecommerce_app/model/banner_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screen/all_products_page.dart';
import '../widgets/products_catalog.dart';
import '../model/product_model.dart';
import 'banner.dart';
import 'header_row.dart';
import 'product_grid_tile.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({Key? key, required this.banners, required this.products})
      : super(key: key);
  final BannerModel banners;
  final List<ProductModel> products;

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var column = Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        HeaderBanner(model: widget.banners),
        HeaderRow(
          title: 'Danh mục',
          hasMore: true,
        ),
        const ProductsCatalog(),
        HeaderRow(
          title: 'Sản phẩm gợi ý',
          hasMore: true,
          onPress: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (_) => AllProductsPage(products: widget.products)),
            );
          },
        ),
        // Expanded(
        //   child: ProductsWidget(products: widget.products),
        // ),
      ],
    );
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is GoToTopScreen) {
          controller.animateTo(
            controller.position.minScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInQuad,
          );
        }
      },
      child: RefreshIndicator(
        onRefresh: () => context.read<HomeCubit>().mainRefresh(),
        child: CustomScrollView(
          controller: controller,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([column]),
            ),
            ProductSliverGridOverview(products: widget.products),
          ],
        ),
      ),
    );
  }
}

class ProductSliverGridOverview extends StatelessWidget {
  const ProductSliverGridOverview({
    Key? key,
    required this.products,
  }) : super(key: key);

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        childCount: products.length,
        (context, index) => ProductWidget(product: products[index]),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisExtent: 250.0),
    );
  }
}
