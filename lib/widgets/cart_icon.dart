import 'package:ecommerce_app/screen/cart_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartIcon extends StatefulWidget {
  const CartIcon({Key? key}) : super(key: key);
  @override
  State<CartIcon> createState() => _CartIconState();
}

class _CartIconState extends State<CartIcon> {
  Color background = Colors.white;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => CartPage(
              products: const [],
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.black,
                size: 30.0,
              ),
            ),
          ),
          Positioned(
            top: 5,
            right: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('4'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
