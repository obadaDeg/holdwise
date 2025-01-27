import 'package:flutter/material.dart';

Widget buildDialog(
  BuildContext context,
  Color iconColor,
  IconData icon,
  String title,
  String message,
  VoidCallback? action,
) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isSmallScreen = constraints.maxWidth < 400;

      return AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: iconColor, size: isSmallScreen ? 24 : 30),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context)
                    .dialogTheme
                    .titleTextStyle
                    ?.copyWith(fontSize: isSmallScreen ? 16 : 20),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: Theme.of(context)
              .dialogTheme
              .contentTextStyle
              ?.copyWith(fontSize: isSmallScreen ? 14 : 16),
        ),
        actions: [
          if (action != null)
            ElevatedButton(
              onPressed: action,
              child: Text(
                'OK',
                style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
              ),
            ),
        ],
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 16),
        ),
      );
    },
  );
}
