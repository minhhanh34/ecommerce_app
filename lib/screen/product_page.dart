import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/components/cart_icon.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.product}) : super(key: key);
  final ProductModel product;
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int isSelected = 0;
  late PageController controller;
  int currentPage = 1;
  bool isFavorite = false;
  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(widget.product.name),
        centerTitle: true,
        elevation: 0,
        actions: const [
          CartIcon(),
        ],
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 1.5,
            child: Stack(
              children: [
                Hero(
                  tag: widget.product.name,
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    controller: controller,
                    onPageChanged: (page) {
                      setState(() {
                        currentPage = page + 1;
                      });
                    },
                    children: [
                      for (int i = 0;
                          i < widget.product.imageUrls.keys.length;
                          i++)
                        CachedNetworkImage(
                          imageUrl: widget.product.imageUrls['image${i + 1}'],
                          fit: BoxFit.cover,
                          placeholder: (_, value) => Container(
                            color: Colors.grey.shade800,
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  right: 4,
                  bottom: 8,
                  child: Text(
                    '$currentPage/${widget.product.imageUrls.keys.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: isFavorite
                        ? const Icon(
                            Icons.favorite_rounded,
                            color: Colors.red,
                          )
                        : const Icon(Icons.favorite_outline),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              widget.product.name,
              style: textTheme.bodyLarge!.copyWith(
                fontSize: 24,
              ),
            ),
          ),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: const [
          //      Padding(
          //       padding: EdgeInsets.only(left: 16.0),
          //       child: Text('Màu:'),
          //     ),

          //   ],
          // ),
        ],
      ),
    );
  }

  Widget buildColorOptions(List<Color> colors) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: colors.length,
      itemBuilder: (context, index) => Container(
        padding: isSelected == index ? const EdgeInsets.all(4.0) : null,
        color: isSelected == index ? Colors.black : Colors.transparent,
        width: 20,
        height: 20,
        child: Container(color: colors[index]),
      ),
    );
  }
}
