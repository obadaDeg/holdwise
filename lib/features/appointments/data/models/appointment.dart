import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Available statuses include:
/// - pending: appointment requested
/// - confirmed: appointment accepted
/// - declined: appointment declined
/// - completed: appointment finished
/// - cancelled: appointment cancelled by the patient or specialist
enum AppointmentStatus { pending, confirmed, declined, completed, cancelled }

class Appointment {
  final String id;
  final String patientId;
  final String specialistId;
  final String specialistName; // <-- New field for display name
  final String patientName; // <-- New field for display name
  final DateTime appointmentTime;
  final AppointmentStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Appointment({
    required this.id,
    required this.patientId,
    required this.specialistId,
    required this.specialistName,
    required this.patientName,
    required this.appointmentTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Appointment copyWith({
    String? id,
    String? patientId,
    String? specialistId,
    String? patientName,
    DateTime? appointmentTime,
    AppointmentStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      specialistId: specialistId ?? this.specialistId,
      specialistName: specialistName ?? this.specialistName,
      patientName: patientName ?? this.patientName,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    log('data: $data');
    return Appointment(
      id: doc.id,
      patientId: data['patientId'] as String,
      specialistId: data['specialistId'] as String,
      specialistName: data['specialistName'] as String,
      patientName: data['patientName'] as String,
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
      'patientName': patientName, // Store the display name
      'appointmentTime': Timestamp.fromDate(appointmentTime),
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  static AppointmentStatus _statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppointmentStatus.pending;
      case 'confirmed':
        return AppointmentStatus.confirmed;
      case 'declined':
        return AppointmentStatus.declined;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      default:
        return AppointmentStatus.pending;
    }
  }
}
