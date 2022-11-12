import 'package:flutter/material.dart';

import '../model/product_model.dart';
import 'product_sliver_grid_overview.dart';

class SearchScreen extends SearchDelegate {
  SearchScreen(this.products);
  final List<ProductModel> products;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        FocusScope.of(context).requestFocus();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<ProductModel> matchQuery = [];
    for (var product in products) {
      if (product.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(product);
      }
    }
    return query.isNotEmpty
        ? CustomScrollView(
            slivers: [
              SliverAppBar(
                toolbarHeight: 40.0,
                leadingWidth: double.infinity,
                pinned: true,
                automaticallyImplyLeading: false,
                leading: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 8.0),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Kết quả',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SliverGrid(
              //   delegate: SliverChildBuilderDelegate(
              //     childCount: matchQuery.length,
              //     (context, index) => ProductWidget(product: matchQuery[index]),
              //   ),
              //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 2, mainAxisExtent: 240.0),
              // ),
              ProductSliverGridOverview(products: matchQuery),
            ],
          )
        : const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final matchQuery = <String>[];
    for (var product in products) {
      if (product.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(product.name.toLowerCase());
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            // FocusScope.of(context).requestFocus(FocusNode());
            query = matchQuery[index];
            showResults(context);
          },
          title: Text(matchQuery[index]),
        );
      },
    );
  }
}
