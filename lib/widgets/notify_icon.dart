import 'package:flutter/material.dart';

class NotifyIcon extends StatefulWidget {
  const NotifyIcon({Key? key}) : super(key: key);

  @override
  State<NotifyIcon> createState() => _NotifyIconState();
}

class _NotifyIconState extends State<NotifyIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.notifications_rounded),
    );
  }
}
