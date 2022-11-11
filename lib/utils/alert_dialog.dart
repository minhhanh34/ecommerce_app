import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    this.title = '',
    this.content = '',
    this.actions = const ['Yes', 'No'],
  });
  final String title;
  final String content;
  final List<String> actions;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        for (var action in actions)
          TextButton(
            onPressed: () {
              if (action.toLowerCase() == 'yes') {
                return Navigator.of(context).pop(true);
              }
              return Navigator.of(context).pop(false);
            },
            child: Text(action),
          ),
      ],
    );
  }
}
