import 'package:flutter/material.dart';

class AccountContainer extends StatefulWidget {
  const AccountContainer({Key? key}) : super(key: key);

  @override
  State<AccountContainer> createState() => _AccountContainerState();
}

class _AccountContainerState extends State<AccountContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(child: Text('Account')),
    );
  }
}
