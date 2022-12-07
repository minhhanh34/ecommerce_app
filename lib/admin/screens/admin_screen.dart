import 'package:ecommerce_app/admin/screens/add_product_screen.dart';
import 'package:ecommerce_app/admin/screens/orders_screen.dart';
import 'package:ecommerce_app/cubit/admin/admin_cubit.dart';
import 'package:ecommerce_app/screen/product_screen.dart';
import 'package:ecommerce_app/screen/sign_in_screen.dart';
import 'package:ecommerce_app/utils/alert_dialog.dart';
import 'package:ecommerce_app/utils/price_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screen/product_overview_screen.dart';
import '../../widgets/loading_wiget.dart';
import 'revenue.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminCubit = context.read<AdminCubit>();
    return BlocListener<AdminCubit, AdminState>(
      listener: (context, state) async {
        final navigator = Navigator.of(context);
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
          final route = MaterialPageRoute(builder: (_) => const SignInScreen());
          navigator.pushAndRemoveUntil(route, (route) => false);
        }
        if (state is AdminAllProducts) {
          builder(context) => ProductOverviewScreen(
                state.products,
                isAdmin: true,
              );
          final route = MaterialPageRoute(builder: builder);
          navigator.push(route);
        }
        if (state is AdminProductAddition) {
          navigator.push(
            MaterialPageRoute(
              builder: (_) => const AddProductScreen(),
            ),
          );
        }
        if (state is AdminDetailProduct) {
          builder(context) => ProductScreen(
                product: state.product,
                isAdmin: true,
              );
          final route = MaterialPageRoute(builder: builder);
          navigator.push(route);
        }
        if (state is AdminRevenue) {
          builder(context) => RevenueScreen(
                revenue: state.revenue,
                orders: state.orders,
              );
          final route = MaterialPageRoute(builder: builder);
          Navigator.of(context).push(route);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.blue.shade100,
        appBar: AppBar(
          title: const Text('Quản trị'),
          elevation: 0,
          centerTitle: true,
        ),
        body: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            if (state is AdminInitial) {
              adminCubit.initialize();
              return const LoadingWidget();
            }
            if (state is AdminLoading) {
              return const LoadingWidget();
            }
            if (state is AdminLoaded) {
              return RefreshIndicator(
                onRefresh: adminCubit.onRefresh,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    const SizedBox(height: 16.0),
                    Card(
                      child: ListTile(
                        onTap: adminCubit.onAllProducts,
                        title: const Text('Tất cả sản phẩm'),
                        subtitle: Text(adminCubit.productsCounts.toString()),
                        leading: const Icon(CupertinoIcons.layers_alt_fill),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        onTap: adminCubit.onProductAddition,
                        title: const Text('Thêm sản phẩm'),
                        leading: const Icon(Icons.add_circle_rounded),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        onTap: adminCubit.onProgressOrders,
                        title: const Text('Đơn hàng'),
                        subtitle:
                            Text(adminCubit.progressOrdersCounts.toString()),
                        leading: const Icon(Icons.all_inbox_rounded),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        onTap: adminCubit.onFinishedOrders,
                        title: const Text('Đơn hàng thành công'),
                        subtitle:
                            Text(adminCubit.finishedOrdersCounts.toString()),
                        leading: const Icon(Icons.done_all_rounded),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        onTap: adminCubit.onRevenue,
                        title: const Text('Doanh thu'),
                        subtitle: Text(PriceHealper.format(adminCubit.revenue)),
                        leading: const Icon(Icons.monetization_on_rounded),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        onTap: () async {
                          builder(context) => const CustomAlertDialog(
                                title: 'Đăng xuất',
                                content: 'Bạn có chắc muốn đăng xuất?',
                              );
                          bool confirm = await showDialog(
                            context: context,
                            builder: builder,
                          );
                          if (!confirm) return;
                          adminCubit.logout();
                        },
                        title: const Text('Đăng xuất'),
                        leading: const Icon(Icons.logout_rounded),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const LoadingWidget();
          },
        ),
      ),
    );
  }
}
