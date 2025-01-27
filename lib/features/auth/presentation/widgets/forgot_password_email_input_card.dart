import 'package:flutter/material.dart';
import 'package:holdwise/app/utils/form_validators.dart';
import 'package:holdwise/common/widgets/custom_input_field.dart';

class ForgotPasswordEmailInputCard extends StatelessWidget {
  const ForgotPasswordEmailInputCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenPadding = MediaQuery.of(context).size.width * 0.005;

    void onSendResetEmail() {
      print('Send reset email to: ${emailController.text}');
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email input field
          CustomTextField(
            controller: emailController,
            hintText: 'Enter your email',
            icon: Icons.email,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else if (!isValidEmail(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: screenHeight * 0.02),
          // Send reset email button
          ElevatedButton(
            onPressed: onSendResetEmail,
            child: const Text('Send Reset Email'),
          ),
        ],
      ),
    );
  }
}