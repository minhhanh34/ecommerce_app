import 'package:flutter/material.dart';

class HistoryContainer extends StatefulWidget {
  const HistoryContainer({Key? key}) : super(key: key);

  @override
  State<HistoryContainer> createState() => _HistoryContainerState();
}

class _HistoryContainerState extends State<HistoryContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(child: Text('History')),
    );
  }
}
