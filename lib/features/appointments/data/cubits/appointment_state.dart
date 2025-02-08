part of 'appointment_cubit.dart';

class AppointmentState extends Equatable {
  final List<Appointment> appointments;
  final bool loading;
  final String? error;

  const AppointmentState({
    this.appointments = const [],
    this.loading = false,
    this.error,
  });

  AppointmentState copyWith({
    List<Appointment>? appointments,
    bool? loading,
    String? error,
  }) {
    return AppointmentState(
      appointments: appointments ?? this.appointments,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [appointments, loading, error];
}
