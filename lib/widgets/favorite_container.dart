import 'package:ecommerce_app/model/cart_item.dart';
import 'package:ecommerce_app/model/product_model.dart';
import 'package:ecommerce_app/screen/product_page.dart';
import 'package:ecommerce_app/utils/alert_dialog.dart';
import 'package:ecommerce_app/utils/generator.dart';
import 'package:ecommerce_app/utils/libs.dart';
import 'package:ecommerce_app/utils/price_format.dart';
import 'package:ecommerce_app/widgets/empty_item.dart';
import '../widgets/header_row.dart';

class FavoriteProductContainer extends StatefulWidget {
  const FavoriteProductContainer({Key? key, required this.favoritedProducts})
      : super(key: key);
  final List<ProductModel> favoritedProducts;
  @override
  State<FavoriteProductContainer> createState() =>
      _FavoriteProductContainerState();
}

class _FavoriteProductContainerState extends State<FavoriteProductContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade100,
      child: Column(
        children: [
          HeaderRow(title: 'Sản phẩm yêu thích'),
          Visibility(
            visible: widget.favoritedProducts.isEmpty,
            child: const Expanded(
              child: EmptyItem(
                message: 'Bạn chưa có sản phẩm yêu thích',
                child: Icon(
                  Icons.heart_broken_outlined,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.favoritedProducts.isNotEmpty,
            child: Expanded(
              child: RefreshIndicator(
                onRefresh: context.read<HomeCubit>().favoriteRefresh,
                child: ListView.builder(
                  itemCount: widget.favoritedProducts.length,
                  itemBuilder: (context, index) {
                    ProductModel product = widget.favoritedProducts[index];
                    return Dismissible(
                      key: Key(product.name),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (context) => const CustomAlertDialog(
                            title: 'Xác nhận',
                            content: 'Bạn có chắc muốn xóa?',
                          ),
                        );
                      },
                      background: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) {
                        context
                            .read<HomeCubit>()
                            .removeFavoriteProduct(product);
                      },
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductPage(product: product),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Card(
                            borderOnForeground: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 2,
                            child: ListTile(
                              leading: Hero(
                                tag: product.name,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: 60,
                                    maxWidth: 60,
                                  ),
                                  child: product.images['image1']!,
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
                                    PriceHealper.format(product.price),
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
                                     
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Visibility(
                                visible: !product.isOutOf,
                                child: IconButton(
                                  color: Colors.pink.shade900,
                                  onPressed: () async {
                                    final spref =
                                        await SharedPreferences.getInstance();
                                    final uid = spref.getString('uid');
                                    final ref = await ProductRepository()
                                        .getQueryDocumentSnapshot(product.name);
                                    final cartItem = CartItem(
                                      id: Generator.generateString(),
                                      uid: uid!,
                                      color: product.colorOption[0]['color'],
                                      imageURL: product.colorOption[0]
                                          ['imageURL'],
                                      memory: product.memoryOption[0]['memory'],
                                      price: product.memoryOption[0]['price'],
                                      quantity: 1,
                                      ref: ref.reference,
                                    );
                                    if (!mounted) return;
                                    BlocProvider.of<CartCubit>(context)
                                        .addItem(cartItem);
                                  },
                                  icon: const Icon(
                                    Icons.add_shopping_cart_outlined,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
