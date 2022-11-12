import 'package:ecommerce_app/admin/screens/add_and_edit_product_screen.dart';
import 'package:ecommerce_app/admin/screens/orders_screen.dart';
import 'package:ecommerce_app/cubit/admin/admin_cubit.dart';
import 'package:ecommerce_app/screen/product_page.dart';
import 'package:ecommerce_app/screen/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screen/product_overview_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminCubit = context.read<AdminCubit>();
    return BlocConsumer<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is AdminProgressOrders) {
          final route = MaterialPageRoute(
            builder: (_) => OrdersScreen(
              state.orders,
              isAdmin: true,
              isFinish: false,
            ),
          );
          Navigator.of(context).push(route);
        }
        if (state is AdminFinishedOrders) {
          final route = MaterialPageRoute(
            builder: (_) => OrdersScreen(
              state.orders,
              isAdmin: true,
              isFinish: true,
            ),
          );
          Navigator.of(context).push(route);
        }
        if (state is AdminLogout) {
          final route = MaterialPageRoute(builder: (_) => const SignInPage());
          Navigator.of(context).pushAndRemoveUntil(route, (route) => false);
        }
        if (state is AdminAllProducts) {
          builder(context) => ProductOverviewScreen(
                state.products,
                isAdmin: true,
              );
          final route = MaterialPageRoute(builder: builder);
          Navigator.of(context).push(route);
        }
        if (state is AdminProductAddition) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddAndEditProductScreen(),
            ),
          );
        }
        if (state is AdminDetailProduct) {
          builder(context) => ProductPage(
                product: state.product,
                isAdmin: true,
              );
          final route = MaterialPageRoute(builder: builder);
          Navigator.of(context).push(route);
        }
      },
      builder: (context, state) {
        if (state is AdminLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: GridView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 16.0,
                  mainAxisExtent: 60.0,
                  mainAxisSpacing: 16.0,
                ),
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        context.read<AdminCubit>().getProgressOrders(),
                    child: const Text('Đơn hàng'),
                  ),
                  ElevatedButton(
                    onPressed: () => context.read<AdminCubit>().logout(),
                    child: const Text('logout'),
                  ),
                  ElevatedButton(
                    onPressed: () => adminCubit.getFinishedOrders(),
                    child: const Text('Đơn hàng thành công'),
                  ),
                  ElevatedButton(
                    onPressed: adminCubit.onProductAddition,
                    child: const Text('Thêm sản phẩm'),
                  ),
                  ElevatedButton(
                    onPressed: adminCubit.onAllProducts,
                    child: const Text('Tất cả sản phẩm'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
