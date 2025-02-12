import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:holdwise/features/appointments/data/models/appointment.dart';

class AppointmentTile extends StatelessWidget {
  final Appointment appointment;

  const AppointmentTile({Key? key, required this.appointment}) : super(key: key);

  /// Fetch the patient’s name from Firestore based on the patientId.
  Future<String> _fetchPatientName(String patientId) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(patientId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        // Assume the user document has a 'name' field.
        return data['name'] as String? ?? patientId;
      }
    } catch (e) {
      // Optionally, handle errors or log them
      debugPrint('Error fetching patient name: $e');
    }
    // Fallback to the patientId if no name is found.
    return patientId;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _fetchPatientName(appointment.patientId),
      builder: (context, snapshot) {
        // Show a loading indicator while fetching the name.
        final patientName = snapshot.connectionState == ConnectionState.waiting
            ? 'Loading...'
            : snapshot.data ?? appointment.patientId;
        return ListTile(
          title: Text(patientName),
          subtitle: Text(
            'Appointment on ${appointment.appointmentTime.toLocal()}',
          ),
          trailing: Text(
            appointment.status.toString().split('.').last,
          ),
        );
      },
    );
  }
}
