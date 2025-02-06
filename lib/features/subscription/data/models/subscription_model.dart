import 'package:flutter/material.dart';

enum SubscriptionPlan { monthly, yearly }

class SubscriptionModel extends ChangeNotifier {
  SubscriptionPlan? _selectedPlan;
  SubscriptionPlan? get selectedPlan => _selectedPlan;

  void selectPlan(SubscriptionPlan plan) {
    _selectedPlan = plan;
    notifyListeners();
  }
}