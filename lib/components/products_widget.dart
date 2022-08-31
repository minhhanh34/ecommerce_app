import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/screen/product_page.dart';
import 'package:ecommerce_app/utils/price_format.dart';
import 'package:flutter/material.dart';

class ProductsWidget extends StatefulWidget {
  const ProductsWidget({Key? key, required this.products}) : super(key: key);
  final List<ProductModel> products;

  @override
  State<ProductsWidget> createState() => ProductsWidgetState();
}

class ProductsWidgetState extends State<ProductsWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.products.map((ProductModel product) {
        void onTap() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductPage(product: product),
            ),
          );
        }

        return GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Stack(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Hero(
                            tag: product.name,
                            child: product.images['image1']!,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text(
                              product.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${PriceFormat.format(product.price)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    color: Colors.red,
                                    fontSize: 18,
                                  ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                for (int i = 0; i < product.grade; i++)
                                  const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 18,
                                  ),
                              ],
                            ),

                            // Text('Danh gia: ${product.grade}'),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                textAlign: TextAlign.left,
                                'Đã bán: ${product.sold}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
