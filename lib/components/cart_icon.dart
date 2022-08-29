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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          
          color: background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              background = Colors.red.shade300;
            });
          },
          child: const Icon(
            Icons.shopping_cart,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
