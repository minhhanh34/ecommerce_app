import 'package:flutter/cupertino.dart';

class OrderContainer extends StatefulWidget {
  const OrderContainer({Key? key}) : super(key: key);

  @override
  State<OrderContainer> createState() => _OrderContainerState();
}

class _OrderContainerState extends State<OrderContainer> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Order'));
  }
}
