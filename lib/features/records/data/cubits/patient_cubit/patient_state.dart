// patient_state.dart

part of 'patient_cubit.dart';

abstract class PatientState {}

class PatientInitial extends PatientState {}

class PatientLoading extends PatientState {}

class PatientLoaded extends PatientState {
  final List<Patient> patients;
  PatientLoaded(this.patients);
}

class PatientError extends PatientState {
  final String message;
  PatientError(this.message);
}
