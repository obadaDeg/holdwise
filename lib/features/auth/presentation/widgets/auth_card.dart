import 'package:flutter/material.dart';
import 'package:holdwise/app/config/constants.dart';

/// A reusable card widget to display the content of authentication pages.
/// It provides consistent styling and structure for all auth-related forms.
class AuthCard extends StatelessWidget {
  final Widget child;

  const AuthCard({required this.child, Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.getBorderRadius(context)),
      ),
      child: Padding(
        padding: EdgeInsets.all(Constants.getPadding(context)),
        child: child,
      ),
    );
  }
}
