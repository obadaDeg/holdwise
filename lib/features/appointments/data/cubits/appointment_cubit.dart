import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/features/appointments/data/models/appointment.dart';
import 'package:holdwise/features/appointments/data/repositories/appointment_repository.dart';
import 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final AppointmentRepository _repository;

  AppointmentCubit({required AppointmentRepository repository})
      : _repository = repository,
        super(const AppointmentState());

  /// Book a new appointment.
  Future<void> bookAppointment(Appointment appointment) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _repository.createAppointment(appointment);
      emit(state.copyWith(isLoading: false));
      // (Optionally, refresh or update your appointment stream.)
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Reschedule an appointment (update time and reset status to pending).
  Future<void> rescheduleAppointment(Appointment appointment, DateTime newTime) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final updatedAppointment = appointment.copyWith(
        appointmentTime: newTime,
        status: AppointmentStatus.pending,
      );
      await _repository.updateAppointment(updatedAppointment);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Cancel an appointment by updating its status.
  Future<void> cancelAppointment(Appointment appointment) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final updatedAppointment = appointment.copyWith(
        status: AppointmentStatus.cancelled,
      );
      await _repository.updateAppointment(updatedAppointment);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Update appointment status (e.g., accept or decline a request).
  Future<void> updateAppointmentStatus(Appointment appointment) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _repository.updateAppointment(appointment);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Listen to the stream of appointments for the given user.
  void fetchAppointments(String userId, {required bool isSpecialist}) {
    emit(state.copyWith(isLoading: true, error: null));
    _repository.streamAppointmentsForUser(userId: userId, isSpecialist: isSpecialist).listen((appointments) {
      emit(state.copyWith(appointments: appointments, isLoading: false));
    }, onError: (error) {
      emit(state.copyWith(isLoading: false, error: error.toString()));
    });
  }
}
