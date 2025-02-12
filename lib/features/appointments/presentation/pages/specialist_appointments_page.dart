import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:holdwise/features/appointments/data/cubits/appointment_cubit.dart';
import 'package:holdwise/features/appointments/data/cubits/appointment_state.dart';
import 'package:holdwise/features/appointments/data/models/appointment.dart';
import 'package:holdwise/features/appointments/data/repositories/appointment_repository.dart';
import 'package:holdwise/features/appointments/presentation/pages/appointment_details_page.dart';
import 'package:holdwise/features/auth/data/models/user_model.dart';
import 'package:intl/intl.dart'; // For date formatting

class SpecialistAppointmentsPage extends StatelessWidget {
  final String specialistId;

  const SpecialistAppointmentsPage({Key? key, required this.specialistId})
      : super(key: key);

  @override
  Widget build(BuildContext outerContext) {
    return BlocProvider(
      create: (context) => AppointmentCubit(repository: AppointmentRepository())
        ..fetchAppointments(specialistId, isSpecialist: true),
      child: Scaffold(
        appBar: RoleBasedAppBar(title: 'Appointments'),
        body: Builder(
          builder: (context) {
            // This context is now under the BlocProvider.
            return RefreshIndicator(
              onRefresh: () async {
                // Now this context will correctly find the AppointmentCubit.
                context
                    .read<AppointmentCubit>()
                    .fetchAppointments(specialistId, isSpecialist: true);
              },
              child: BlocBuilder<AppointmentCubit, AppointmentState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.error != null) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: Text(
                              'Could not load appointments, try again.',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  final appointments = state.appointments;
                  if (appointments.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: const Center(
                            child: Text(
                              'No appointment requests.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = appointments[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(
                            'Appointment with ${appointment.patientName}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                'Time: ${DateFormat.yMMMd().add_jm().format(appointment.appointmentTime)}',
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Status: ${appointment.status.toString().split('.').last}',
                                style: TextStyle(
                                  color: appointment.status ==
                                          AppointmentStatus.confirmed
                                      ? Colors.green
                                      : appointment.status ==
                                              AppointmentStatus.pending
                                          ? Colors.orange
                                          : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: context.read<AppointmentCubit>(),
                                  child: AppointmentDetailsPage(
                                    appointment: appointment,
                                    isSpecialist: true,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
