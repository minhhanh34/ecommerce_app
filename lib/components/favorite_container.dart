import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/components/header_row.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/screen/product_page.dart';
import 'package:ecommerce_app/utils/price_format.dart';
import 'package:flutter/material.dart';

class FavoriteProductContainer extends StatefulWidget {
  const FavoriteProductContainer({Key? key}) : super(key: key);

  @override
  State<FavoriteProductContainer> createState() =>
      _FavoriteProductContainerState();
}

class _FavoriteProductContainerState extends State<FavoriteProductContainer> {
  Future<List<ProductModel>> getFavoritProducts(String user) async {
    List<ProductModel> productModels = [];
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('favorite').doc(user).get();
    Map<String, dynamic> data = snapshot.data()!['favorite'];
    for (DocumentReference<Map<String, dynamic>> product in data.values) {
      DocumentSnapshot<Map<String, dynamic>> prodData = await product.get();

      productModels.add(
        ProductModel(
          name: prodData.data()!['name'],
          imageUrls: prodData.data()!['imageURL'],
          price: prodData.data()!['price'],
          sold: prodData.data()!['sold'],
          grade: prodData.data()!['grade'],
        ),
      );
    }
    return productModels;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade100,
      child: Column(
        children: [
          const HeaderRow(title: 'Sản phẩm yêu thích'),
          FutureBuilder<List<ProductModel>?>(
            future: getFavoritProducts('user1'),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      ProductModel product = snapshot.data![index];
                      return Dismissible(
                        key: Key(product.name),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProductPage(product: product),
                              ),
                            );
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Card(
                              borderOnForeground: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 2,
                              child: ListTile(
                                leading: Hero(
                                  tag: product.name,
                                  child: CachedNetworkImage(
                                    imageUrl: product.imageUrls['image1'],
                                    placeholder: (context, url) {
                                      return Container(
                                        color: Colors.grey.shade300,
                                        child: const Icon(Icons.image),
                                      );
                                    },
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                isThreeLine: true,
                                title: Text(
                                  product.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${PriceFormat.format(product.price)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(color: Colors.red),
                                    ),
                                    Row(
                                      children: [
                                        for (int i = 0; i < product.grade; i++)
                                          const Icon(
                                            Icons.star,
                                            size: 14,
                                            color: Colors.yellow,
                                          ),
                                        const Spacer(),
                                        Text('đã bán: ${product.sold}'),
                                        // const Spacer(),
                                        // IconButton(
                                        //   onPressed: () {},
                                        //   icon: const Icon(
                                        //       Icons.add_shopping_cart_rounded),
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  color: Colors.pink.shade900,
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.add_shopping_cart_outlined,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return const Expanded(
                child: Center(
                  child: Text('Bạn chưa có sản phẩm yêu thích!'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
