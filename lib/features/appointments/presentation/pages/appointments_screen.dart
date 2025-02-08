// lib/features/appointments/presentation/pages/patient_appointments_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientAppointmentsPage extends StatelessWidget {
  const PatientAppointmentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.error != null) {
          return Center(child: Text('Error: ${state.error}'));
        }
        final appointments = state.appointments;
        return ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return ListTile(
              title: Text(
                'Appointment with ${appointment.specialistId}',
              ),
              subtitle: Text(
                '${appointment.appointmentTime}',
              ),
              trailing: Text(appointment.status.toString().split('.').last),
              onTap: () {
                // Navigate to a details/reschedule screen.
              },
            );
          },
        );
      },
    );
  }
}
