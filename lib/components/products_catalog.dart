import 'package:flutter/material.dart';

class ProductsCatalog extends StatefulWidget {
  const ProductsCatalog({Key? key}) : super(key: key);

  @override
  State<ProductsCatalog> createState() => _ProductsCatalogState();
}

class _ProductsCatalogState extends State<ProductsCatalog> {
  final products = ['Iphone', 'Samsung', 'Oppo', 'Xiaomi', 'Gaming\nPhone'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemExtent: 100,
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            child: Center(
              child: Text(
                products[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
