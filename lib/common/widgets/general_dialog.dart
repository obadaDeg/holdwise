import 'package:flutter/material.dart';

class GeneralDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const GeneralDialog({
    required this.title,
    required this.message,
    this.onConfirm,
    this.onCancel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).dialogTheme.titleTextStyle,
      ),
      content: Text(
        message,
        style: Theme.of(context).dialogTheme.contentTextStyle,
      ),
      actions: [
        if (onCancel != null)
          TextButton(
            onPressed: onCancel,
            child: const Text('Cancel'),
          ),
        if (onConfirm != null)
          ElevatedButton(
            onPressed: onConfirm,
            child: const Text('Confirm'),
          ),
      ],
    );
  }
}
