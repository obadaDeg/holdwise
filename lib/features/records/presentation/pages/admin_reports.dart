import 'package:flutter/material.dart';
import 'package:holdwise/features/records/presentation/widgets/active_users_chart.dart';
import 'package:holdwise/features/records/presentation/widgets/retention_metrics.dart';
import 'package:holdwise/features/records/presentation/widgets/posture_effectiveness.dart';
import 'package:holdwise/features/records/presentation/widgets/financial_summary.dart';
import 'package:holdwise/features/records/presentation/widgets/system_performance.dart';

class AdminReports extends StatelessWidget {
  const AdminReports({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(height: 16),
        ActiveUsersChart(),
        SizedBox(height: 16),
        RetentionMetrics(),
        SizedBox(height: 16),
        PostureEffectiveness(),
        SizedBox(height: 16),
        FinancialSummary(),
        SizedBox(height: 16),
        SystemPerformance(),
      ],
    );
  }
}
