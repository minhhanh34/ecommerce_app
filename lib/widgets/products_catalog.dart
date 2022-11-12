import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home/home_cubit.dart';

class ProductsCatalog extends StatelessWidget {
  const ProductsCatalog({Key? key}) : super(key: key);

  final brands = const ['Iphone', 'Samsung', 'Oppo', 'Xiaomi', 'Gaming Phone'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        itemExtent: 100.0,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () =>
                context.read<HomeCubit>().productsByBrand(brands[index]),
            child: Card(
              color: Theme.of(context).secondaryHeaderColor,
              elevation: 4.0,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    brands[index],
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
