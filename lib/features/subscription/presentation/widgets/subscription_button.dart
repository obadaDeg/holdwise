
// import 'package:flutter/material.dart';
// import 'package:holdwise/app/config/colors.dart';
// class SubscriptionButton extends StatelessWidget {
//   final Size size;

//   const SubscriptionButton({required this.size, super.key});

//   @override
//   Widget build(BuildContext context) {
//     final subscriptionModel = Provider.of<SubscriptionModel>(context);
//     final isPlanSelected = subscriptionModel.selectedPlan != null;

//     return ElevatedButton(
//       onPressed: isPlanSelected
//           ? () {
//               Navigator.pushNamed(context, AppRoutes.billing);
//             }
//           : null,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.primary500,
//         padding: EdgeInsets.symmetric(
//           horizontal: size.width * 0.1,
//           vertical: size.height * 0.02,
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       child: const Text(
//         'Subscribe Now',
//         style: TextStyle(fontSize: 18, color: Colors.white),
//       ),
//     );
//   }
// }
