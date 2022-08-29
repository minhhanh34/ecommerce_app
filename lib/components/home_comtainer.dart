import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/components/products_catalog.dart';
import 'package:ecommerce_app/components/products_widget.dart';
import 'package:flutter/material.dart';

import '../model/product_model.dart';
import 'Banner.dart';
import 'header_row.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({Key? key}) : super(key: key);

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  Future<List<ProductModel>> getAllProducts() async {
    final docs = await FirebaseFirestore.instance.collection('products').get();
    return docs.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      final data = doc.data();
      return ProductModel(
        name: data['name'],
        imageUrls: data['imageURL'],
        price: data['price'],
        grade: data['grade'],
        //isFavorite: data['isFavorite'],
        sold: data['sold'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          const HeaderBanner(),
          const HeaderRow(
            title: 'Danh mục',
            hasMore: true,
          ),
          const ProductsCatalog(),
          const HeaderRow(
            title: 'Sản phẩm gợi ý',
            hasMore: true,
          ),
          //buildProducts(products),
          FutureBuilder<List<ProductModel>>(
            future: getAllProducts(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return ProductsWidget(products: snapshot.data!);
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
