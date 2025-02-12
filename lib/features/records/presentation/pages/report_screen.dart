// report_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:holdwise/features/records/data/services/firebase_services.dart';
import 'package:holdwise/features/records/presentation/widgets/activity_breakdown.dart';
import 'package:holdwise/features/records/presentation/widgets/violation_trend_chart.dart';

class ReportScreen extends StatelessWidget {
  final firebaseServices = FirestoreServices();
  ReportScreen({Key? key}) : super(key: key);

  Future<Map<String, double>> _fetchReportData() async {
    return await firebaseServices.getActivityBreakdownReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoleBasedAppBar(title: 'Activity Report', displayActions: false),
      body: FutureBuilder<Map<String, double>>(
        future: _fetchReportData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No activity data available."));
          }

          final reportData = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ActivityBreakdown(activityData: reportData),
              const SizedBox(height: 20),
              const Text("App Usage Report",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              const Text(
                "Other Reports",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Optionally, you can add other reporting widgets here.
              // For example: a line chart to show violation trends over time.
              const ViolationBarChart(),
            ],
          );
        },
      ),
    );
  }
}
