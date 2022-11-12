import 'package:flutter/material.dart';
class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    this.isSelected = false,
    this.leading,
    required this.ontap,
    required this.title,
    this.trailing,
  }) : super(key: key);

  final bool isSelected;
  final VoidCallback ontap;
  final IconData? leading;
  final String title;
  final IconData? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: isSelected,
      selectedTileColor: Colors.pink.shade100,
      selectedColor: Colors.white,
      onTap: ontap,
      leading: Icon(leading),
      trailing: Icon(trailing),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
