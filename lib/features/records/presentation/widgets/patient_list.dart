import 'package:flutter/material.dart';

class PatientList extends StatelessWidget {
  final String specialistId;
  PatientList({Key? key, required this.specialistId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Patient List'),
    );
  }
}
