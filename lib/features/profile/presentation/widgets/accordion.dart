import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/cubits/theme_cubit/theme_cubit.dart';

class Accordion extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final IconData? leadingIcon;

  const Accordion({
    super.key,
    required this.title,
    required this.children,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    TextScaler textScaler = MediaQuery.textScalerOf(context);

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        bool isDarkMode = themeMode == ThemeMode.dark;
        Color backgroundColor = isDarkMode ? AppColors.gray900 : AppColors.gray200;
        Color textColor = isDarkMode ? Colors.white : Colors.black;
        Color shadowColor = isDarkMode ? Colors.black.withOpacity(0.5) : Colors.grey.withOpacity(0.2);

        return FractionallySizedBox(
          widthFactor: screenWidth > 600 ? 0.7 : 0.95, // Adjust width for tablets
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent, // Removes default ExpansionTile divider
              ),
              child: ExpansionTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                leading: leadingIcon != null
                    ? Icon(leadingIcon, color: textColor)
                    : null,
                title: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: textScaler.scale(16),
                    color: textColor,
                  ),
                ),
                children: children,
              ),
            ),
          ),
        );
      },
    );
  }
}
