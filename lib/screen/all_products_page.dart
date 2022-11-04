import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/utils/price_format.dart';
import 'package:flutter/material.dart';

class AllProductsPage extends StatelessWidget {
  const AllProductsPage({Key? key, required this.products}) : super(key: key);
  final List<ProductModel> products;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text('Tất cả sản phẩm'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 120,
                      maxWidth: MediaQuery.of(context).size.width * 0.5,
                    ),
                    child: products[index].images['image1']!),
                Text(
                  PriceFormat.format(products[index].price),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.red,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
