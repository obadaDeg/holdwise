import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:holdwise/features/appointments/data/models/appointment.dart';

class AppointmentValidationService {
  final FirebaseFirestore _firestore;

  AppointmentValidationService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<ValidationResult> validateAppointmentCreation(Appointment appointment) async {
    // Check if the appointment time is in the past
    if (appointment.appointmentTime.isBefore(DateTime.now())) {
      return ValidationResult(
        isValid: false,
        message: 'Cannot book appointments in the past',
      );
    }

    // Check if the appointment is during business hours (9 AM to 5 PM)
    final hour = appointment.appointmentTime.hour;
    if (hour < 9 || hour >= 17) {
      return ValidationResult(
        isValid: false,
        message: 'Appointments must be between 9 AM and 5 PM',
      );
    }

    // Check if the appointment is on a weekend
    if (appointment.appointmentTime.weekday > 5) {
      return ValidationResult(
        isValid: false,
        message: 'Appointments cannot be scheduled on weekends',
      );
    }

    // Check for time slot availability
    final isAvailable = await _checkTimeSlotAvailability(
      appointment.specialistId,
      appointment.appointmentTime,
    );
    if (!isAvailable) {
      return ValidationResult(
        isValid: false,
        message: 'This time slot is not available',
      );
    }

    // Check specialist availability status
    final specialistDoc = await _firestore
        .collection('specialists')
        .doc(appointment.specialistId)
        .get();
    
    if (!specialistDoc.exists) {
      return ValidationResult(
        isValid: false,
        message: 'Specialist not found',
      );
    }

    final specialistData = specialistDoc.data() as Map<String, dynamic>;
    if (!(specialistData['isActive'] ?? false)) {
      return ValidationResult(
        isValid: false,
        message: 'Specialist is not currently accepting appointments',
      );
    }

    // Check patient appointment limits
    final patientAppointmentsCount = await _getPatientActiveAppointmentsCount(
      appointment.patientId,
    );
    if (patientAppointmentsCount >= 3) {
      return ValidationResult(
        isValid: false,
        message: 'Maximum number of active appointments reached',
      );
    }

    return ValidationResult(isValid: true);
  }

  Future<ValidationResult> validateAppointmentReschedule(
    Appointment appointment,
    DateTime newTime,
  ) async {
    // Check cancellation window for existing appointment
    final hoursUntilAppointment = appointment.appointmentTime
        .difference(DateTime.now())
        .inHours;
    if (hoursUntilAppointment < 24) {
      return ValidationResult(
        isValid: false,
        message: 'Appointments must be rescheduled at least 24 hours in advance',
      );
    }

    // Create a temporary appointment object with the new time
    final tempAppointment = appointment.copyWith(appointmentTime: newTime);
    
    // Reuse creation validation logic
    return validateAppointmentCreation(tempAppointment);
  }

  Future<ValidationResult> validateAppointmentCancellation(
    Appointment appointment,
  ) async {
    // Check if the appointment is already cancelled or completed
    if (appointment.status == AppointmentStatus.cancelled ||
        appointment.status == AppointmentStatus.completed) {
      return ValidationResult(
        isValid: false,
        message: 'Cannot cancel a ${appointment.status} appointment',
      );
    }

    // Check cancellation window
    final hoursUntilAppointment = appointment.appointmentTime
        .difference(DateTime.now())
        .inHours;
    if (hoursUntilAppointment < 24) {
      return ValidationResult(
        isValid: true,
        message: 'Late cancellation fee may apply',
        warning: true,
      );
    }

    return ValidationResult(isValid: true);
  }

  Future<bool> _checkTimeSlotAvailability(
    String specialistId,
    DateTime appointmentTime,
  ) async {
    final startWindow = appointmentTime.subtract(const Duration(minutes: 30));
    final endWindow = appointmentTime.add(const Duration(minutes: 30));

    final conflictingAppointments = await _firestore
        .collection('appointments')
        .where('specialistId', isEqualTo: specialistId)
        .where('appointmentTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startWindow))
        .where('appointmentTime',
            isLessThanOrEqualTo: Timestamp.fromDate(endWindow))
        .where('status', whereIn: ['pending', 'confirmed'])
        .get();

    return conflictingAppointments.docs.isEmpty;
  }

  Future<int> _getPatientActiveAppointmentsCount(String patientId) async {
    final activeAppointments = await _firestore
        .collection('appointments')
        .where('patientId', isEqualTo: patientId)
        .where('status', whereIn: ['pending', 'confirmed'])
        .count()
        .get();

    return activeAppointments.count!;
  }
}

class ValidationResult {
  final bool isValid;
  final String? message;
  final bool warning;

  ValidationResult({
    required this.isValid,
    this.message,
    this.warning = false,
  });
}