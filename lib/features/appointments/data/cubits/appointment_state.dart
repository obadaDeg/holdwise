import 'package:equatable/equatable.dart';
import 'package:holdwise/features/appointments/data/models/appointment.dart';

class AppointmentState extends Equatable {
  final List<Appointment> appointments;
  final bool isLoading;
  final String? error;

  const AppointmentState({
    this.appointments = const [],
    this.isLoading = false,
    this.error,
  });

  AppointmentState copyWith({
    List<Appointment>? appointments,
    bool? isLoading,
    String? error,
  }) {
    return AppointmentState(
      appointments: appointments ?? this.appointments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [appointments, isLoading, error];
}
