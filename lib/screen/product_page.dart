import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/components/cart_icon.dart';
import 'package:ecommerce_app/components/header_row.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:flutter/material.dart';

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
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {},
                  child: const Text('Thêm vào giỏ hàng'),
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
          const HeaderRow(
            title: 'Sản phẩm tương tự',
            hasMore: true,
          ),
          SizedBox(
            height: 200,
            child: FutureBuilder<List<ProductModel>>(
              future: getAllProducts(),
              builder: (_, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              height: 150,
                              imageUrl:
                                  snapshot.data![index].imageURL['image1'],
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                left: 12,
                              ),
                              child: Text(snapshot.data![index].name,
                                  style: Theme.of(context).textTheme.headline6),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<ProductModel>> getAllProducts() async {
    // if (sameProducts.isNotEmpty) return Future.value(sameProducts);
    final docs = await FirebaseFirestore.instance.collection('products').get();
    sameProducts =
        docs.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      final data = doc.data();
      return ProductModel(
        name: data['name'],
        imageURL: data['imageURL'],
        price: data['price'],
        grade: data['grade'],
        //isFavorite: data['isFavorite'],
        sold: data['sold'],
      );
    }).toList();
    return sameProducts;
  }

  // Widget buildColorOptions(List<Color> colors) {
  //   return ListView.builder(
  //     scrollDirection: Axis.horizontal,
  //     itemCount: colors.length,
  //     itemBuilder: (context, index) => Container(
  //       padding: isSelected == index ? const EdgeInsets.all(4.0) : null,
  //       color: isSelected == index ? Colors.black : Colors.transparent,
  //       width: 20,
  //       height: 20,
  //       child: Container(color: colors[index]),
  //     ),
  //   );
  // }
}
