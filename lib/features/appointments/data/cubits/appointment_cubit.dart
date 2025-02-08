// lib/features/appointments/presentation/cubit/appointment_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'appointment_state.dart';
import 'package:equatable/equatable.dart';
import 'package:holdwise/features/appointments/data/models/appointment.dart';

part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentRepository _appointmentRepository;
  final String userId;
  final bool isSpecialist;

  AppointmentCubit({
    required AppointmentRepository appointmentRepository,
    required this.userId,
    this.isSpecialist = false,
  })  : _appointmentRepository = appointmentRepository,
        super(const AppointmentState()) {
    _listenToAppointments();
  }

  void _listenToAppointments() {
    _appointmentRepository
        .streamAppointmentsForUser(userId: userId, isSpecialist: isSpecialist)
        .listen((appointments) {
      emit(state.copyWith(appointments: appointments, loading: false));
    }, onError: (error) {
      emit(state.copyWith(error: error.toString(), loading: false));
    });
  }

  Future<void> createAppointment(Appointment appointment) async {
    emit(state.copyWith(loading: true));
    try {
      await _appointmentRepository.createAppointment(appointment);
      // Optionally, trigger a notification for the specialist.
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> updateAppointment(Appointment appointment) async {
    emit(state.copyWith(loading: true));
    try {
      await _appointmentRepository.updateAppointment(appointment);
      // Optionally, trigger notifications based on update type.
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> deleteAppointment(String appointmentId) async {
    emit(state.copyWith(loading: true));
    try {
      await _appointmentRepository.deleteAppointment(appointmentId);
      // Optionally, notify the other party that the appointment has been cancelled.
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }
}
