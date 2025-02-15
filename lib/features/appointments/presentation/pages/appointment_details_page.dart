import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:holdwise/features/appointments/data/cubits/appointment_cubit.dart';
import 'package:holdwise/features/appointments/data/models/appointment.dart';
import 'package:intl/intl.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final Appointment appointment;
  final bool isSpecialist;

  const AppointmentDetailsPage({
    Key? key,
    required this.appointment,
    required this.isSpecialist,
  }) : super(key: key);

  Future<void> _pickNewDateTime(
      BuildContext context, Function(DateTime) onPicked) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: appointment.appointmentTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (newDate == null) return;
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(appointment.appointmentTime),
    );
    if (newTime == null) return;
    final newDateTime = DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      newTime.hour,
      newTime.minute,
    );
    onPicked(newDateTime);
  }

  void _reschedule(BuildContext context) {
    _pickNewDateTime(context, (newDateTime) {
      context
          .read<AppointmentCubit>()
          .rescheduleAppointment(appointment, newDateTime);
      Navigator.pop(context);
    });
  }

  void _cancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content:
            const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              context.read<AppointmentCubit>().cancelAppointment(appointment);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _updateStatus(BuildContext context, AppointmentStatus newStatus) {
    final updatedAppointment = appointment.copyWith(status: newStatus);
    context
        .read<AppointmentCubit>()
        .updateAppointmentStatus(updatedAppointment);
    Navigator.pop(context);
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('EEE, MMM d, y • hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = _formatDateTime(appointment.appointmentTime);
    return Scaffold(
      appBar: RoleBasedAppBar(
        title: 'Appointment Details',
        displayActions: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Appointment Details Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.access_time,
                            color: Theme.of(context).primaryColor),
                        title: const Text(
                          'Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(formattedTime),
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(Icons.person,
                            color: Theme.of(context).primaryColor),
                        title: const Text(
                          'Patient',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(appointment.patientId),
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(Icons.medical_services,
                            color: Theme.of(context).primaryColor),
                        title: const Text(
                          'Specialist',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(appointment.specialistId),
                      ),
                      const Divider(),
                      ListTile(
                        leading: Icon(Icons.info,
                            color: Theme.of(context).primaryColor),
                        title: const Text(
                          'Status',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          appointment.status.toString().split('.').last,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Action Buttons
              if (!isSpecialist)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _reschedule(context),
                      icon: const Icon(Icons.schedule),
                      label: const Text('Reschedule'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _cancel(context),
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        foregroundColor: AppColors.error
                      ),
                    ),
                  ],
                ),
              if (isSpecialist)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () =>
                          _updateStatus(context, AppointmentStatus.confirmed),
                      icon: const Icon(Icons.check),
                      label: const Text('Accept'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        foregroundColor: AppColors.success,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () =>
                          _updateStatus(context, AppointmentStatus.declined),
                      icon: const Icon(Icons.close),
                      label: const Text('Decline'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        foregroundColor: AppColors.error,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _reschedule(context),
                      icon: const Icon(Icons.schedule),
                      label: const Text('Reschedule'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
