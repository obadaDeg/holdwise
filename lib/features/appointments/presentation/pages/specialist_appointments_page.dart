import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/features/appointments/data/cubits/appointment_cubit.dart';
import 'package:holdwise/features/appointments/data/cubits/appointment_state.dart';
import 'package:holdwise/features/appointments/data/models/appointment.dart';
import 'package:holdwise/features/appointments/presentation/pages/appointment_details_page.dart';

class SpecialistAppointmentsPage extends StatelessWidget {
  final String specialistId;

  const SpecialistAppointmentsPage({Key? key, required this.specialistId})
      : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    try {
      context
          .read<AppointmentCubit>()
          .fetchAppointments(specialistId, isSpecialist: true);
    } catch (e) {
      print(e);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Requests'),
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
            return const Center(child: Text('No appointment requests.'));
          }
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return ListTile(
                title: Text('Appointment with ${appointment.patientId}'),
                subtitle: Text('${appointment.appointmentTime}'),
                trailing: Text(appointment.status.toString().split('.').last),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AppointmentDetailsPage(
                        appointment: appointment,
                        isSpecialist: true,
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
