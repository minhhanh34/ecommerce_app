import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/admin/screens/add_and_edit_product_screen.dart';
import 'package:ecommerce_app/model/cart_item.dart';
import 'package:ecommerce_app/model/order_model.dart';

import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/utils/generator.dart';
import 'package:ecommerce_app/utils/libs.dart';
import 'package:ecommerce_app/utils/price_format.dart';
import 'package:ecommerce_app/widgets/header_row.dart';

import '../widgets/cart_icon.dart';

enum TypeClick {
  addToCart,
  buy,
}

class ProductPage extends StatefulWidget {
  const ProductPage({
    Key? key,
    required this.product,
    this.isAdmin = false,
  }) : super(key: key);
  final ProductModel product;
  final bool isAdmin;
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // late PageController controller;
  // int currentPage = 1;
  // late bool isFavorite;
  // late List<ProductModel> sameProducts;
  int selectColor = 0;
  int selectMemory = 0;
  int quantity = 1;
  bool navVisible = true;
  late PersistentBottomSheetController _controller;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late CachedNetworkImage imageOption;

  @override
  void initState() {
    super.initState();
    // controller = PageController(initialPage: 0);
    // isFavorite =
    //     context.read<HomeCubit>().favoriteProducts?.contains(widget.product) ??
    //         false;
    _scaffoldKey = GlobalKey<ScaffoldState>();
    imageOption = widget.product.images['image1']!;
  }

  @override
  void dispose() {
    // controller.dispose();
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  void changeColor(int i) {
    _controller.setState!(() {
      selectColor = i;
      imageOption = CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: widget.product.colorOption![i]['imageURL'],
        placeholder: (context, url) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Icon(Icons.image),
          );
        },
      );
    });
  }

  void goToOrder() {
    final homeCubit = context.read<HomeCubit>();
    int orderTabIndex = 2;
    final route = MaterialPageRoute(builder: (_) => const HomePage());
    Navigator.of(context).pushReplacement(route);
    homeCubit.onNavTap(orderTabIndex);
  }

  void displayBottomSheet(BuildContext context, TypeClick typeClick) {
    final textTheme = Theme.of(context).textTheme;
    _controller = _scaffoldKey.currentState!.showBottomSheet(
      backgroundColor: Colors.white,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.65,
      ),
      enableDrag: false,
      (context) {
        final homeCubit = context.read<HomeCubit>();
        return Column(
          children: [
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 90.0,
                          maxHeight: 90.0,
                        ),
                        child: imageOption,
                      ),
                      title: Text(widget.product.name),
                      subtitle: Text(
                        PriceHealper.format(
                          (widget.product.memoryOption != null &&
                                  widget.product.memoryOption!.isNotEmpty)
                              ? widget.product.memoryOption![selectMemory]
                                  ['price']
                              : widget.product.price,
                        ),
                        style:
                            textTheme.titleMedium?.copyWith(color: Colors.red),
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
                                          widget.product.colorOption![i]
                                              ['color'],
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
                                    label: Text(widget.product.memoryOption![i]
                                        ['memory']),
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
                      leading: const Text('Tổng cộng:'),
                      title: Text(
                        PriceHealper.format(
                          (widget.product.memoryOption != null &&
                                  widget.product.memoryOption!.isNotEmpty)
                              ? (widget.product.memoryOption![selectMemory]
                                      ['price'] *
                                  quantity)
                              : (widget.product.price * quantity),
                        ),
                        style: textTheme.titleLarge?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: () async {
                    if (typeClick == TypeClick.addToCart) {
                      final spref = await SharedPreferences.getInstance();
                      final uid = spref.getString('uid');
                      final ref = await ProductRepository()
                          .getQueryDocumentSnapshot(widget.product.name);
                      final cartItem = CartItem(
                        id: Generator.generateString(),
                        uid: uid!,
                        color: widget.product.colorOption![selectColor]
                            ['color'],
                        imageURL: widget.product.colorOption![selectColor]
                            ['imageURL'],
                        memory: widget.product.memoryOption![selectMemory]
                            ['memory'],
                        price: widget.product.memoryOption![selectMemory]
                            ['price'],
                        quantity: quantity,
                        ref: ref.reference,
                      );
                      if (!mounted) return;
                      final result =
                          await context.read<CartCubit>().addItem(cartItem);
                      if (result) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                                content: Text('Đã thêm vào giỏ hàng!')),
                          );
                      } else {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text('Sản phẩm đã có trong giỏ hàng!'),
                            ),
                          );
                      }
                    } else {
                      final spref = await SharedPreferences.getInstance();
                      final uid = spref.getString('uid');
                      final querySnapshot =
                          await (homeCubit.homeService as HomeServiceIml)
                              .productService
                              .repository
                              .getQueryDocumentSnapshot(widget.product.name);
                      final ref = querySnapshot.reference;
                      final user = await homeCubit.userRefresh();
                      final recipient = user.name;
                      final order = OrderModel(
                        recipient: recipient,
                        uid: uid!,
                        order: [
                          {
                            'color': widget.product.colorOption![selectColor]
                                ['color'],
                            'memory': widget.product.memoryOption![selectMemory]
                                ['memory'],
                            'quantity': quantity,
                            'imageURL': widget.product.colorOption![selectColor]
                                ['imageURL'],
                            'price': widget.product.memoryOption![selectMemory]
                                ['price'],
                            'ref': ref,
                          }
                        ],
                        date: DateTime.now(),
                        id: Generator.generateString(),
                        status: 'Chờ xác nhận',
                        address: '',
                      );
                      if (!mounted) return;
                      await context.read<HomeCubit>().addOrder(order);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: const Text('Đặt hàng thành công!'),
                            action: SnackBarAction(
                              label: 'Xem đơn hàng',
                              onPressed: goToOrder,
                            ),
                          ),
                        );
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
            width: double.infinity,
            child: Builder(builder: (context) {
              if (widget.isAdmin) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            AddAndEditProductScreen(product: widget.product),
                      ),
                    );
                  },
                  child: const Text('Cập nhật sản phẩm'),
                );
              }
              return Row(
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
              );
            }),
          ),
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(widget.product.name),
        centerTitle: true,
        elevation: 0,
        actions: [
          Visibility(visible: !widget.isAdmin, child: const CartIcon()),
        ],
      ),
      body: ListView(
        children: [
          ImageSlidable(
            widget.product,
            isAdmin: widget.isAdmin,
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
              for (int i = 0; i < widget.product.grade; i++)
                const Icon(Icons.star, color: Colors.yellow),
              const SizedBox(width: 16.0),
              Text('Đã bán ${widget.product.sold}'),
            ],
          ),
          ListTile(
            title: Text(
              PriceHealper.format(
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
                        (option) {
                          return Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(int.parse(option['color'])),
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
                            label: Text(memory['memory']),
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

class ImageSlidable extends StatefulWidget {
  const ImageSlidable(this.product, {super.key, this.isAdmin = false});
  final ProductModel product;
  final bool isAdmin;

  @override
  State<ImageSlidable> createState() => _ImageSlidableState();
}

class _ImageSlidableState extends State<ImageSlidable> {
  late PageController controller;
  int currentPage = 1;
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
    isFavorite =
        context.read<HomeCubit>().favoriteProducts?.contains(widget.product) ??
            false;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
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
                  for (int i = 0; i < widget.product.images.keys.length; i++)
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
          Visibility(
            visible: !widget.isAdmin,
            child: Positioned(
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
          ),
        ],
      ),
    );
  }
}
