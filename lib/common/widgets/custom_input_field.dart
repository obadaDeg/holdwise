import 'package:flutter/material.dart';
import 'package:holdwise/app/config/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.primary500),
        hintText: hintText,
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: Theme.of(context).inputDecorationTheme.enabledBorder,
      ),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.primary600,
          ),
      validator: validator,
    );
  }
}
