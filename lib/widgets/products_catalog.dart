import 'package:flutter/material.dart';

class ProductsCatalog extends StatelessWidget {
  const ProductsCatalog({Key? key}) : super(key: key);

  final products = const [
    'Iphone',
    'Samsung',
    'Oppo',
    'Xiaomi',
    'Gaming\nPhone'
  ];

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
