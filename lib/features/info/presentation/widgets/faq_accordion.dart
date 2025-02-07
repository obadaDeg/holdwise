import 'package:flutter/material.dart';
import 'package:holdwise/app/config/colors.dart';

class FaqAccordion extends StatelessWidget {
  final String question;
  final String answer;

  const FaqAccordion({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    TextScaler textScaler = MediaQuery.textScalerOf(context);

    return FractionallySizedBox(
      widthFactor: screenWidth > 600 ? 0.85 : 0.99,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.gray700,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.gray900,
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              question,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: textScaler.scale(16),
              ),
            ),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenWidth * 0.02,
                ),
                child: Text(
                  answer,
                  style: TextStyle(fontSize: textScaler.scale(14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
