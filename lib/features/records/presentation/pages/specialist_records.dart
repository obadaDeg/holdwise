import 'package:flutter/material.dart';
import 'package:holdwise/features/records/presentation/widgets/patient_list.dart';
import 'package:holdwise/features/records/presentation/widgets/posture_heatmap.dart';
import 'package:holdwise/features/records/presentation/widgets/health_risk_graph.dart';
import 'package:holdwise/features/records/presentation/widgets/specialist_notes.dart';

class SpecialistRecords extends StatelessWidget {
  const SpecialistRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(height: 16),
        PatientList(),
        SizedBox(height: 16),
        PostureHeatmap(),
        SizedBox(height: 16),
        HealthRiskGraph(),
        SizedBox(height: 16),
        SpecialistNotes(),
      ],
    );
  }
}
