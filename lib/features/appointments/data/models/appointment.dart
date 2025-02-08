// lib/features/appointments/data/models/appointment.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum AppointmentStatus { pending, confirmed, declined, completed }

class Appointment {
  final String id;
  final String patientId;
  final String specialistId;
  final DateTime appointmentTime;
  final AppointmentStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Appointment({
    required this.id,
    required this.patientId,
    required this.specialistId,
    required this.appointmentTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Appointment(
      id: doc.id,
      patientId: data['patientId'] as String,
      specialistId: data['specialistId'] as String,
      appointmentTime: (data['appointmentTime'] as Timestamp).toDate(),
      status: _statusFromString(data['status'] as String),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'patientId': patientId,
      'specialistId': specialistId,
      'appointmentTime': Timestamp.fromDate(appointmentTime),
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  static AppointmentStatus _statusFromString(String status) {
    switch (status) {
      case 'pending':
        return AppointmentStatus.pending;
      case 'confirmed':
        return AppointmentStatus.confirmed;
      case 'declined':
        return AppointmentStatus.declined;
      case 'completed':
        return AppointmentStatus.completed;
      default:
        return AppointmentStatus.pending;
    }
  }
}
