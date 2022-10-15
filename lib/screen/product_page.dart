import 'package:ecommerce_app/cubit/cart/cart_cubit.dart';

import 'package:ecommerce_app/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/cart_icon.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.product}) : super(key: key);
  final ProductModel product;
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late PageController controller;
  int currentPage = 1;
  bool isFavorite = false;
  late List<ProductModel> sameProducts;
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
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: BlocBuilder<CartCubit, CartState>(
                  builder: (_, state) => ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {
                      context.read<CartCubit>().addItem(widget.product);
                    },
                    child: const Text('Thêm vào giỏ hàng'),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  onPressed: () {},
                  child: const Text('Mua ngay'),
                ),
              ),
            ],
          ),
        ),
      ),
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
                        // setState(() {
                        //   currentPage = page + 1;
                        // });
                      },
                      children: [
                        for (int i = 0;
                            i < widget.product.images.keys.length;
                            i++)
                          widget.product.images['image${i + 1}']!,
                        // CachedNetworkImage(
                        //   imageUrl: widget.product.imageURL['image${i + 1}'],
                        //   fit: BoxFit.cover,
                        //   placeholder: (_, value) => Container(
                        //     color: Colors.grey.shade800,
                        //     child: const Center(
                        //       child: Icon(
                        //         Icons.image,
                        //         size: 24,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ]),
                ),
                Positioned(
                  right: 4,
                  bottom: 8,
                  child: Text(
                    '$currentPage/${widget.product.imageURL.keys.length}',
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
          Row(
            children: [
              const SizedBox(width: 20),
              const Text('Tùy chọn màu: '),
              const SizedBox(width: 20),
              Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(height: 10),
                  const Text('Đỏ'),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(height: 10),
                  const Text('Xanh'),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(height: 10),
                  const Text('Trắng'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
