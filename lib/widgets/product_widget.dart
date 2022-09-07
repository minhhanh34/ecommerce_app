import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/screen/product_page.dart';
import 'package:ecommerce_app/utils/price_format.dart';
import 'package:flutter/material.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({Key? key, required this.product}) : super(key: key);
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ProductPage(product: product))),
      child: Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: product.name,
              child: product.images['image1']!,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                left: 16.0,
              ),
              child: Text(
                product.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 4,
                left: 16.0,
              ),
              child: Text(
                PriceFormat.format(product.price),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
