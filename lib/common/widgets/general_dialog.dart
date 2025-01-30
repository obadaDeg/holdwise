import 'package:flutter/material.dart';
import 'package:holdwise/app/config/colors.dart';

class GeneralDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon; // Optional icon
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const GeneralDialog({
    required this.title,
    required this.message,
    this.icon,
    this.onConfirm,
    this.onCancel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // Make background transparent
      child: Stack(
        clipBehavior: Clip.none, // Allow overflow
        alignment: Alignment.topCenter,
        children: [
          // Main Alert Dialog
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).dialogTheme.titleTextStyle ??
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: Theme.of(context).dialogTheme.contentTextStyle ??
                      const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onCancel != null)
                      TextButton(
                        onPressed: onCancel,
                        child: const Text('Cancel'),
                      ),
                    if (onConfirm != null)
                      ElevatedButton(
                        onPressed: onConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger, // Danger color
                        ),
                        child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Floating Warning Icon
          if (icon != null)
            Positioned(
              top: -30, // Exceed the border
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 35,
                child: Icon(icon, color: AppColors.danger, size: 40),
              ),
            ),
        ],
      ),
    );
  }
}
