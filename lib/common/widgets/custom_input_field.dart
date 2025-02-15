import 'package:flutter/material.dart';
import 'package:holdwise/app/config/colors.dart';
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final bool obscureText;
  final int maxLines;
  final String? Function(String?)? validator;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    this.icon,
    this.obscureText = false,
    this.maxLines = 1,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: (icon != null) ? Icon(icon, color: AppColors.primary500): null,
        hintText: hintText,
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        contentPadding: EdgeInsets.symmetric(vertical: 10, 
        horizontal: (icon != null) ? 0 : 10,
        ),
        border: Theme.of(context).inputDecorationTheme.enabledBorder,
      ),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.primary600,
          ),
      validator: validator,
    );
  }
}
