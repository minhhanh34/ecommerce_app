import 'package:ecommerce_app/cubit/cart/cart_cubit.dart';
import 'package:ecommerce_app/cubit/home/home_cubit.dart';

import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/utils/price_format.dart';
import 'package:ecommerce_app/widgets/header_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/cart_icon.dart';

enum TypeClick {
  addToCart,
  buy,
}

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.product}) : super(key: key);
  final ProductModel product;
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late PageController controller;
  int currentPage = 1;
  late bool isFavorite;
  late List<ProductModel> sameProducts;
  int selectColor = 0;
  int selectMemory = 0;
  int quantity = 1;
  bool navVisible = true;
  late PersistentBottomSheetController _controller;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
    isFavorite =
        context.read<HomeCubit>().favoriteProducts?.contains(widget.product) ??
            false;
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  void dispose() {
    controller.dispose();
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  void changeColor(int i) {
    _controller.setState!(() {
      selectColor = i;
    });
  }

  void displayBottomSheet(BuildContext context, TypeClick typeClick) {
    final textTheme = Theme.of(context).textTheme;
    _controller = _scaffoldKey.currentState!.showBottomSheet(
      enableDrag: false,
      (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 4),
              // Divider(
              //   indent: MediaQuery.of(context).size.width *
              //       0.35,
              //   endIndent:
              //       MediaQuery.of(context).size.width *
              //           0.35,
              //   color: Colors.black,
              //   thickness: 3.0,
              // ),
              ListTile(
                onTap: () async {
                  _controller.close();
                  await Future.delayed(
                    const Duration(milliseconds: 175),
                    _controller.close,
                  );
                  setState(() {
                    navVisible = true;
                  });
                },
                trailing: const Icon(Icons.close),
              ),
              ListTile(
                leading: widget.product.images['image1']!,
                title: Text(widget.product.name),
                subtitle: Text(
                  PriceFormat.format(
                    widget.product.price + selectMemory * 3000000,
                  ),
                  style: textTheme.titleMedium?.copyWith(color: Colors.red),
                ),
              ),
              Visibility(
                visible: widget.product.colorOption != null &&
                    widget.product.colorOption!.isNotEmpty,
                child: ListTile(
                  leading: const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text('Màu:'),
                  ),
                  title: Row(
                    children: [
                      for (int i = 0;
                          i < (widget.product.colorOption?.length ?? 0);
                          i++)
                        InkWell(
                          onTap: () {
                            changeColor(i);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: selectColor == i
                                  ? Colors.black
                                  : Colors.grey.shade100,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Color(
                                  int.parse(
                                    widget.product.colorOption![i],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: widget.product.memoryOption != null &&
                    widget.product.memoryOption!.isNotEmpty,
                child: ListTile(
                  leading: const Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text('Bộ nhớ:'),
                  ),
                  title: Wrap(
                    children: [
                      for (int i = 0;
                          i < (widget.product.memoryOption?.length ?? 0);
                          i++)
                        InkWell(
                          onTap: () {
                            _controller.setState!(() {
                              selectMemory = i;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Chip(
                              backgroundColor: selectMemory == i
                                  ? Colors.blue.shade100
                                  : Colors.white,
                              label: Text(widget.product.memoryOption![i]),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: const Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text('Số lượng:'),
                ),
                title: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _controller.setState!(() {
                          if (quantity > 1) {
                            quantity--;
                          }
                        });
                      },
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.black,
                      ),
                    ),
                    Text(quantity.toString()),
                    IconButton(
                      onPressed: () {
                        _controller.setState!(() {
                          quantity++;
                        });
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Tổng cộng:'),
                ),
                title: Text(
                  PriceFormat.format(
                    (widget.product.price + selectMemory * 3000000) * quantity,
                  ),
                  style: textTheme.titleLarge?.copyWith(
                    color: Colors.red,
                  ),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (typeClick == TypeClick.addToCart) {
                        context.read<CartCubit>().addItem(widget.product);
                      } else {
                        //TODO 
                        // by feature
                      }
                      _controller.close();
                      await Future.delayed(const Duration(milliseconds: 175));
                      setState(() {
                        navVisible = true;
                      });
                    },
                    child: const Text('Ok'),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: Visibility(
        visible: navVisible,
        child: SafeArea(
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () async {
                        setState(() {
                          navVisible = false;
                        });
                        displayBottomSheet(context, TypeClick.addToCart);
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
                    onPressed: () {
                      setState(() {
                        navVisible = false;
                      });
                      displayBottomSheet(context, TypeClick.buy);
                    },
                    child: const Text('Mua ngay'),
                  ),
                ),
              ],
            ),
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
                        setState(() {
                          currentPage = page + 1;
                        });
                      },
                      children: [
                        for (int i = 0;
                            i < widget.product.images.keys.length;
                            i++)
                          widget.product.images['image${i + 1}']!,
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
                    onPressed: () async {
                      if (isFavorite) {
                        context
                            .read<HomeCubit>()
                            .removeFavoriteProduct(widget.product);
                      } else {
                        context.read<HomeCubit>().addFavoriteProduct(
                              widget.product,
                            );
                      }
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
              const SizedBox(width: 16.0),
              for(int i = 0; i < widget.product.grade; i++)
                const Icon(Icons.star, color: Colors.yellow),
              const SizedBox(width: 16.0),
              Text('Đã bán ${widget.product.sold}'),
            ],
          ),
          ListTile(
            title: Text(
              PriceFormat.format(
                widget.product.price,
              ),
              style: textTheme.titleLarge?.copyWith(
                color: Colors.red,
              ),
            ),
          ),
          Visibility(
            visible: widget.product.colorOption != null &&
                widget.product.colorOption!.isNotEmpty,
            child: Column(
              children: [
                HeaderRow(title: 'Tùy chọn màu'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.product.colorOption?.map(
                        (color) {
                          return Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(int.parse(color)),
                            ),
                          );
                        },
                      ).toList() ??
                      [],
                ),
              ],
            ),
          ),
          Visibility(
            visible: widget.product.memoryOption != null &&
                widget.product.memoryOption!.isNotEmpty,
            child: Column(
              children: [
                HeaderRow(title: 'Tùy chọn bộ nhớ'),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: widget.product.memoryOption?.map((memory) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Chip(
                            backgroundColor: Colors.white,
                            label: Text(memory),
                          ),
                        );
                      }).toList() ??
                      [],
                ),
              ],
            ),
          ),

          // const SizedBox(height: 20),
          HeaderRow(title: 'Thông số chi tiết'),
          buildDetailInfo(),
        ],
      ),
    );
  }

  Widget buildRowInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label)),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }

  Widget buildDetailInfo() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          buildRowInfo('Tên', widget.product.name),
          const Divider(indent: 8.0, endIndent: 8.0, thickness: 2),
          buildRowInfo(
            'Màn hình',
            widget.product.screenSize ?? 'Đang cập nhật',
          ),
          const Divider(indent: 8.0, endIndent: 8.0, thickness: 2),
          buildRowInfo(
            'Độ phân giải',
            widget.product.resolution ?? 'Đang cập nhật',
          ),
          const Divider(indent: 8.0, endIndent: 8.0, thickness: 2),
          buildRowInfo(
            'Thương hiệu',
            widget.product.brand ?? 'Đang cập nhật',
          ),
          const Divider(indent: 8.0, endIndent: 8.0, thickness: 2),
          buildRowInfo(
            'Dung lượng pin',
            widget.product.batteryCapacity ?? 'Đang cập nhật',
          ),
          const Divider(indent: 8.0, endIndent: 8.0, thickness: 2),
          buildRowInfo(
            'Camera trước',
            widget.product.fontCamera ?? 'Đang cập nhật',
          ),
          const Divider(indent: 8.0, endIndent: 8.0, thickness: 2),
          buildRowInfo(
            'Camera sau',
            widget.product.rearCamera ?? 'Đang cập nhật',
          ),
          const Divider(indent: 8.0, endIndent: 8.0, thickness: 2),
          buildRowInfo(
            'Card đồ họa',
            widget.product.gpu ?? 'Đang cập nhật',
          ),
          const Divider(indent: 8.0, endIndent: 8.0, thickness: 2),
          buildRowInfo(
            'CPU',
            widget.product.cpu ?? 'Đang cập nhật',
          ),
          const Divider(indent: 8.0, endIndent: 8.0, thickness: 2),
          buildRowInfo(
            'Tốc độ CPU',
            widget.product.cpuSpeed ?? 'Đang cập nhật',
          ),
          const Divider(indent: 8.0, endIndent: 8.0, thickness: 2),
          buildRowInfo(
            'kích thước',
            widget.product.size ?? 'Đang cập nhật',
          ),
          const Divider(indent: 8.0, endIndent: 8.0, thickness: 2),
          buildRowInfo(
            'Loại màn hình',
            widget.product.displayType ?? 'Đang cập nhật',
          ),
          const Divider(indent: 8.0, endIndent: 8.0, thickness: 2),
          buildRowInfo(
            'model',
            widget.product.model ?? 'Đang cập nhật',
          ),
          const Divider(indent: 8.0, endIndent: 8.0, thickness: 2),
          buildRowInfo(
            'sims',
            widget.product.sims ?? 'Đang cập nhật',
          ),
          const Divider(indent: 8.0, endIndent: 8.0, thickness: 2),
          buildRowInfo(
            'Loại Pin',
            widget.product.batteryType ?? 'Đang cập nhật',
          ),
          const Divider(indent: 8.0, endIndent: 8.0, thickness: 2),
          buildRowInfo(
            'Trọng lượng',
            widget.product.weight ?? 'Đang cập nhật',
          ),
          const Divider(indent: 8.0, endIndent: 8.0, thickness: 2),
          buildRowInfo(
            'RAM',
            widget.product.ram ?? 'Đang cập nhật',
          ),
          const Divider(indent: 8.0, endIndent: 8.0, thickness: 2),
          buildRowInfo(
            'ROM',
            widget.product.rom ?? 'Đang cập nhật',
          ),
          const Divider(indent: 8.0, endIndent: 8.0, thickness: 2),
          buildRowInfo(
            'Wifi',
            widget.product.wifi ?? 'Đang cập nhật',
          ),
        ],
      ),
    );
  }
}
