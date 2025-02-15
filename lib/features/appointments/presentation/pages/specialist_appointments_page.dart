import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/cubits/theme_cubit/theme_cubit.dart';
import 'package:holdwise/app/routes/routes.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:holdwise/features/appointments/data/cubits/appointment_cubit.dart';
import 'package:holdwise/features/appointments/data/cubits/appointment_state.dart';
import 'package:holdwise/features/appointments/data/models/appointment.dart';
import 'package:holdwise/features/appointments/data/repositories/appointment_repository.dart';
import 'package:holdwise/features/appointments/presentation/pages/appointment_details_page.dart';
import 'package:holdwise/features/auth/data/models/user_model.dart';
import 'package:intl/intl.dart';

class SpecialistAppointmentsPage extends StatelessWidget {
  final String specialistId;

  const SpecialistAppointmentsPage({Key? key, required this.specialistId})
      : super(key: key);

  @override
  Widget build(BuildContext outerContext) {
    final isDarkMode = outerContext.read<ThemeCubit>().state == ThemeMode.dark;

    return BlocProvider(
      create: (context) => AppointmentCubit(repository: AppointmentRepository())
        ..fetchAppointments(specialistId, isSpecialist: true),
      child: Scaffold(
        appBar: RoleBasedAppBar(title: 'Appointments'),
        body: Builder(
          builder: (context) {
            return RefreshIndicator(
              color: isDarkMode ? AppColors.primary300 : AppColors.primary500,
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
                              style: TextStyle(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.bold),
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
                                  fontSize: 20,
                                  color: appointment.status ==
                                          AppointmentStatus.confirmed
                                      ? AppColors.success
                                      : appointment.status ==
                                              AppointmentStatus.pending
                                          ? AppColors.warning
                                          : AppColors.error,
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: isDarkMode
                                ? AppColors.white
                                : AppColors.gray900,
                          ),
                          onTap: () {
                            // Capture the cubit from the current context
                            final appointmentCubit =
                                BlocProvider.of<AppointmentCubit>(context,
                                    listen: false);
                            Navigator.pushNamed(
                              context,
                              AppRoutes.appointmentDetails,
                              arguments: {
                                'appointment': appointment,
                                'appointmentCubit': appointmentCubit,
                              },
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
