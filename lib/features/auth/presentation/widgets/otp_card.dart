import 'package:flutter/material.dart';
import 'package:holdwise/app/config/colors.dart';

/// A reusable OTP Card for verifying email or resetting passwords.
class OTPCard extends StatefulWidget {
  final String title;
  final String description;
  final void Function(String) onSubmit; // Callback when OTP is submitted
  final VoidCallback? onResend; // Callback for Resend Code button

  const OTPCard({
    required this.title,
    required this.description,
    required this.onSubmit,
    this.onResend,
    Key? key,
  }) : super(key: key);

  @override
  State<OTPCard> createState() => _OTPCardState();
}

class _OTPCardState extends State<OTPCard> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (_) => FocusNode()); // For better focus control

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final otp = _controllers.map((controller) => controller.text).join();
      widget.onSubmit(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Dynamic spacing and sizing
    final otpFieldWidth = screenWidth * 0.12;
    final verticalSpacing = screenHeight * 0.02;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: verticalSpacing),
          // Description
          Text(
            widget.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: verticalSpacing * 2),
          // OTP Input Fields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              6,
              (index) => SizedBox(
                width: otpFieldWidth,
                child: TextFormField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    counterText: '',
                  ),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.primary600,
                      ),
                  maxLength: 1,
                  onChanged: (value) {
                    if (value.isNotEmpty && index < 5) {
                      _focusNodes[index + 1].requestFocus();
                    } else if (value.isEmpty && index > 0) {
                      _focusNodes[index - 1].requestFocus();
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: verticalSpacing * 2),
          // Submit Button
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.015,
                horizontal: screenWidth * 0.1,
              ),
            ),
            child: const Text('Verify'),
          ),
          SizedBox(height: verticalSpacing),
          // Resend OTP Button
          widget.onResend == null
              ? const SizedBox()
              : TextButton(
                  onPressed: widget.onResend,
                  child: const Text('Resend Code'),
                ),
        ],
      ),
    );
  }
}
