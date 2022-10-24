import 'package:ecommerce_app/cubit/home/home_cubit.dart';
import 'package:ecommerce_app/cubit/home/home_state.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/utils/price_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderContainer extends StatefulWidget {
  const OrderContainer({Key? key, required this.products}) : super(key: key);
  final List<ProductModel> products;

  @override
  State<OrderContainer> createState() => _OrderContainerState();
}

class _OrderContainerState extends State<OrderContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade100,
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is OrderState) {
            return RefreshIndicator(
              onRefresh: () async => context.read<HomeCubit>().orderRefresh(),
              child: ListView.separated(
                separatorBuilder: (_, index) => const SizedBox(height: 15),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('status'),
                        const SizedBox(height: 20),
                        Text(state.products[index].name),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              height: 80,
                              child: state.products[index].images['image1']!,
                            ),
                            Column(
                              children: const [
                                Text('mau'),
                                Text('Rom'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                                'Gia: ${PriceFormat.format(state.products[index].price)}'),
                            const Spacer(),
                            const Text('so luong'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                            'Tong cong: ${PriceFormat.format(state.products[index].price * 2)}'),
                        const SizedBox(height: 10),
                        const Text('Thanh toan khi nhan hang'),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(CupertinoIcons.trash),
                              label: const Text('Huy'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return const Text('error');
        },
      ),
    );
  }
}
