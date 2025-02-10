import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:holdwise/features/appointments/data/models/appointment.dart';

class AppointmentRepository {
  final FirebaseFirestore firestore;

  AppointmentRepository({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference get _appointments => firestore.collection('appointments');

  /// Create a new appointment.
  Future<void> createAppointment(Appointment appointment) async {
    final docRef = _appointments.doc(); // generate new document ID
    final newAppointment = appointment.copyWith(
      id: docRef.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await docRef.set(newAppointment.toFirestore());
  }

  /// Update an existing appointment.
  Future<void> updateAppointment(Appointment appointment) async {
    final updatedAppointment = appointment.copyWith(updatedAt: DateTime.now());
    await _appointments.doc(appointment.id).update(updatedAppointment.toFirestore());
  }

  /// Delete an appointment.
  Future<void> deleteAppointment(String appointmentId) async {
    await _appointments.doc(appointmentId).delete();
  }

  /// Stream appointments for a specific user.
  Stream<List<Appointment>> streamAppointmentsForUser({
    required String userId,
    required bool isSpecialist,
  }) {
    final field = isSpecialist ? 'specialistId' : 'patientId';
    return _appointments
        .where(field, isEqualTo: userId)
        .orderBy('appointmentTime')
        .snapshots()
        .map((query) =>
            query.docs.map((doc) => Appointment.fromFirestore(doc)).toList());
  }
}
