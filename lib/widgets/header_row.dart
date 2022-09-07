import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeaderRow extends StatelessWidget {
  const HeaderRow({Key? key, required this.title, this.hasMore = false})
      : super(key: key);
  final String title;
  final bool hasMore;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          hasMore
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.forward),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
