import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/features/appointments/data/cubits/appointment_cubit.dart';
import 'package:holdwise/features/appointments/data/cubits/appointment_state.dart';
import 'package:holdwise/features/appointments/data/models/appointment.dart';
import 'package:holdwise/features/appointments/presentation/pages/appointment_details_page.dart';

class PatientAppointmentsPage extends StatelessWidget {
  final String patientId;

  const PatientAppointmentsPage({Key? key, required this.patientId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Start fetching appointments for this patient.
    context
        .read<AppointmentCubit>()
        .fetchAppointments(patientId, isSpecialist: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
      ),
      body: BlocBuilder<AppointmentCubit, AppointmentState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }
          final appointments = state.appointments;
          if (appointments.isEmpty) {
            return const Center(child: Text('No appointments found.'));
          }
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return ListTile(
                title: Text('Appointment with ${appointment.specialistId}'),
                subtitle: Text('${appointment.appointmentTime}'),
                trailing: Text(appointment.status.toString().split('.').last),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: context.read<AppointmentCubit>(),
                        child: AppointmentDetailsPage(
                          appointment: appointment,
                          isSpecialist: false,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
