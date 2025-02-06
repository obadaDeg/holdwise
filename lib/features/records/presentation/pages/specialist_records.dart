import 'package:flutter/material.dart';
import 'package:holdwise/features/records/presentation/widgets/patient_list.dart';
import 'package:holdwise/features/records/presentation/widgets/posture_heatmap.dart';
import 'package:holdwise/features/records/presentation/widgets/health_risk_graph.dart';
import 'package:holdwise/features/records/presentation/widgets/specialist_notes.dart';

class SpecialistRecords extends StatefulWidget {
  const SpecialistRecords({super.key});

  @override
  _SpecialistRecordsState createState() => _SpecialistRecordsState();
}

class _SpecialistRecordsState extends State<SpecialistRecords> {
  String? selectedSpecialist;
  final List<String> specialists = [
    'Dr. Smith',
    'Dr. Johnson',
    'Dr. Brown',
    'Dr. Taylor',
  ]; // Replace with actual specialist list from your data source

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dropdown for filtering by specialist
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Filter by Specialist',
              border: OutlineInputBorder(),
            ),
            value: selectedSpecialist,
            items: specialists.map((specialist) {
              return DropdownMenuItem(
                value: specialist,
                child: Text(specialist),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSpecialist = value;
              });
            },
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              const SizedBox(height: 16),
              PatientList(specialistId: 'selectedSpecialist'),
              const SizedBox(height: 16),
              const PostureHeatmap(),
              const SizedBox(height: 16),
              const HealthRiskGraph(),
              const SizedBox(height: 16),
              const SpecialistNotes(),
            ],
          ),
        ),
      ],
    );
  }
}
