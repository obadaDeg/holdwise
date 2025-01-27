import 'package:flutter/material.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/utils/build_dialog.dart';

class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onConfirm;

  const SuccessDialog({
    required this.title,
    required this.message,
    this.onConfirm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildDialog(
      context,
      AppColors.success,
      Icons.check_circle_outline,
      title,
      message,
      onConfirm,
    );
  }
}