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
    final theme = Theme.of(context); // Get current theme
    final dialogTheme = theme.dialogTheme; // Use app-wide dialog theme

    return Dialog(
      backgroundColor: Colors.transparent, // Transparent background for stack effect
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Main Alert Dialog
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: BoxDecoration(
              color: dialogTheme.backgroundColor ?? theme.colorScheme.surface,
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
                  style: dialogTheme.titleTextStyle ?? theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: dialogTheme.contentTextStyle ?? theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onCancel != null)
                      TextButton(
                        onPressed: onCancel,
                        child: Text(
                          'Cancel',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),
                    if (onConfirm != null)
                      ElevatedButton(
                        onPressed: onConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Confirm',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
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
                backgroundColor: theme.colorScheme.surface,
                radius: 35,
                child: Icon(icon, color: AppColors.danger, size: 40),
              ),
            ),
        ],
      ),
    );
  }
}
