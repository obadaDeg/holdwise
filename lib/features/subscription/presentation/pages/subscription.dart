import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/cubits/theme_cubit/theme_cubit.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:holdwise/app/routes/routes.dart';

/// --------------------------------------------------------------------------
/// 1. Define Enums and Cubit for Subscription & Payment state management.
/// --------------------------------------------------------------------------
enum SubscriptionPlan { monthly, yearly }

enum PaymentMethod { creditCard, paypal, jawwalPay, reflect, inAppPurchase }

class SubscriptionCubit extends Cubit<SubscriptionPlan?> {
  SubscriptionCubit() : super(null);

  void selectPlan(SubscriptionPlan plan) => emit(plan);
}

/// --------------------------------------------------------------------------
/// 2. The main Subscription screen remains unchanged.
/// --------------------------------------------------------------------------
class Subscription extends StatelessWidget {
  const Subscription({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (_) => SubscriptionCubit(),
      child: Scaffold(
        appBar: RoleBasedAppBar(
          title: 'HoldWise Premium',
          displayActions: false,
        ),
        body: Padding(
          padding: EdgeInsets.all(size.width * 0.04),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.workspace_premium,
                  size: size.width * 0.2,
                  color: Colors.amber,
                ),
                SizedBox(height: size.height * 0.02),
                const Text(
                  'Unlock HoldWise Premium',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.01),
                const Text(
                  'Enhance your posture awareness with exclusive features.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: size.height * 0.02),
                FeatureComparisonTable(isDarkMode: isDarkMode, size: size),
                SizedBox(height: size.height * 0.03),
                PricingSection(isDarkMode: isDarkMode, size: size),
                SizedBox(height: size.height * 0.02),
                SubscriptionButton(size: size),
                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// --------------------------------------------------------------------------
/// 3. FeatureComparisonTable remains unchanged.
/// --------------------------------------------------------------------------
class FeatureComparisonTable extends StatelessWidget {
  final bool isDarkMode;
  final Size size;

  const FeatureComparisonTable(
      {required this.isDarkMode, required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.gray800 : AppColors.gray100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Free vs. Premium',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.01),
          Table(
            border: TableBorder.symmetric(
              inside: const BorderSide(width: 1, color: Colors.grey),
            ),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
            },
            children: [
              _buildTableRow(['Feature', 'Free', 'Premium'], isHeader: true),
              _buildTableRow(['Basic posture reminders', true, true]),
              _buildTableRow(
                  ['Real-time posture correction alerts', true, true]),
              _buildTableRow(
                  ['Detailed posture analytics and reports', false, true]),
              _buildTableRow(
                  ['Custom reminders and posture exercises', false, true]),
              _buildTableRow(
                  ['AI-driven posture improvement insights', false, true]),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(List<dynamic> values, {bool isHeader = false}) {
    return TableRow(
      decoration: isHeader ? const BoxDecoration(color: Colors.black12) : null,
      children: values.map((value) {
        if (value is String) {
          return Padding(
            padding: EdgeInsets.all(size.width * 0.02),
            child: Text(
              value,
              style: isHeader
                  ? const TextStyle(fontWeight: FontWeight.bold)
                  : null,
            ),
          );
        } else if (value is bool) {
          return Padding(
            padding: EdgeInsets.all(size.width * 0.02),
            child: Center(
              child: Icon(
                value ? Icons.check : Icons.close,
                color: value ? AppColors.success : AppColors.danger,
              ),
            ),
          );
        }
        return Container();
      }).toList(),
    );
  }
}

/// --------------------------------------------------------------------------
/// 4. PricingSection remains as previously updated.
/// --------------------------------------------------------------------------
class PlanOption extends StatelessWidget {
  final SubscriptionPlan plan;
  final String title;
  final String? subtitle;
  final SubscriptionPlan? selectedPlan;
  final VoidCallback onTap;

  const PlanOption({
    Key? key,
    required this.plan,
    required this.title,
    this.subtitle,
    required this.selectedPlan,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSelected = plan == selectedPlan;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary500.withOpacity(0.8)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary500 : AppColors.white,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: AppColors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PricingSection extends StatelessWidget {
  final bool isDarkMode;
  final Size size;

  const PricingSection({
    Key? key,
    required this.isDarkMode,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionPlan?>(
      builder: (context, selectedPlan) {
        return Container(
          padding: EdgeInsets.all(size.width * 0.04),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.tertiary500 : AppColors.tertiary200,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Choose Your Plan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 16),
              // Monthly Option
              PlanOption(
                plan: SubscriptionPlan.monthly,
                title: '\$4.99/month',
                selectedPlan: selectedPlan,
                onTap: () {
                  context
                      .read<SubscriptionCubit>()
                      .selectPlan(SubscriptionPlan.monthly);
                },
              ),
              // Yearly Option with a subtitle
              PlanOption(
                plan: SubscriptionPlan.yearly,
                title: '\$49.99/year',
                subtitle: 'Save \$10/year',
                selectedPlan: selectedPlan,
                onTap: () {
                  context
                      .read<SubscriptionCubit>()
                      .selectPlan(SubscriptionPlan.yearly);
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Cancel anytime. Start your journey to a healthier posture today!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SubscriptionButton extends StatelessWidget {
  final Size size;

  const SubscriptionButton({required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionPlan?>(
      builder: (context, selectedPlan) {
        final isPlanSelected = selectedPlan != null;
        return ElevatedButton(
          onPressed: isPlanSelected
              ? () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.billing,
                    arguments: selectedPlan,
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary500,
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.1,
              vertical: size.height * 0.02,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Subscribe Now',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        );
      },
    );
  }
}

/// --------------------------------------------------------------------------
/// 5. Updated BillingPage with multiple payment methods and an engaging style.
/// --------------------------------------------------------------------------
class BillingPage extends StatefulWidget {
  final SubscriptionPlan? selectedPlan;

  const BillingPage({super.key, this.selectedPlan});

  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final _formKey = GlobalKey<FormState>();

  // Payment method selection state. Default to Credit Card.
  PaymentMethod _selectedPaymentMethod = PaymentMethod.creditCard;

  // Controllers for Credit Card payment
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _confirmPayment() {
    if (_selectedPaymentMethod == PaymentMethod.creditCard) {
      if (_formKey.currentState?.validate() ?? false) {
        // TODO: Integrate your credit card payment processing logic.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credit Card Payment Confirmed!')),
        );
      }
    } else {
      // TODO: Process alternative payment methods (e.g. redirect to PayPal).
      String method = _selectedPaymentMethod.toString().split('.').last;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Confirmed with $method!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String planText = widget.selectedPlan == SubscriptionPlan.monthly
        ? '\$4.99/month'
        : '\$49.99/year';

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        // Use a gradient background for a modern feel.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary500, AppColors.tertiary500],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header Card with plan details.
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.credit_card,
                          size: 48,
                          color: AppColors.primary500,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Billing Details',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You selected the $planText plan.',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

                // Payment Method Selector
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Select Payment Method',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: PaymentMethod.values.map((method) {
                          return PaymentMethodOption(
                            method: method,
                            isSelected: _selectedPaymentMethod == method,
                            onTap: () {
                              setState(() {
                                _selectedPaymentMethod = method;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Animated Payment Details Section
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _selectedPaymentMethod == PaymentMethod.creditCard
                      ? Card(
                          key: const ValueKey('creditCardForm'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Name on Card',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your name.';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _cardController,
                                    decoration: const InputDecoration(
                                      labelText: 'Card Number',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value.length < 16) {
                                        return 'Please enter a valid card number.';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _expiryController,
                                          decoration: const InputDecoration(
                                            labelText: 'Expiry Date',
                                            hintText: 'MM/YY',
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Enter expiry date';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _cvvController,
                                          decoration: const InputDecoration(
                                            labelText: 'CVV',
                                            border: OutlineInputBorder(),
                                          ),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty ||
                                                value.length < 3) {
                                              return 'Enter a valid CVV';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Card(
                          key: const ValueKey('otherPaymentInfo'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Text(
                                'You will be redirected to ${_selectedPaymentMethod.toString().split('.').last} to complete your payment.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                ),

                const SizedBox(height: 20),

                // Confirm & Pay Button
                ElevatedButton(
                  onPressed: _confirmPayment,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1,
                      vertical: size.height * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: AppColors.primary500,
                    elevation: 6,
                  ),
                  child: const Text(
                    'Confirm & Pay',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A custom widget for selecting a payment method.
class PaymentMethodOption extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodOption({
    Key? key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  String get methodLabel {
    switch (method) {
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.paypal:
        return 'PayPal';
      case PaymentMethod.jawwalPay:
        return 'Jawwal Pay';
      case PaymentMethod.reflect:
        return 'Reflect';
      case PaymentMethod.inAppPurchase:
        return 'In-App Purchase';
    }
  }

  IconData get methodIcon {
    switch (method) {
      case PaymentMethod.creditCard:
        return Icons.credit_card;
      case PaymentMethod.paypal:
        return Icons.account_balance_wallet;
      case PaymentMethod.jawwalPay:
        return Icons.phone_android;
      case PaymentMethod.reflect:
        return Icons.sync;
      case PaymentMethod.inAppPurchase:
        return Icons.mobile_screen_share;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary500.withOpacity(0.8)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary500 : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary500.withOpacity(0.4),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              methodIcon,
              size: 32,
              color: isSelected ? Colors.white : Colors.black,
            ),
            const SizedBox(height: 8),
            Text(
              methodLabel,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
