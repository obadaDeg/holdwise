import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/features/appointments/data/cubits/appointment_cubit.dart';
import 'package:holdwise/features/appointments/data/models/appointment.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final Appointment appointment;
  final bool isSpecialist;

  const AppointmentDetailsPage({
    Key? key,
    required this.appointment,
    required this.isSpecialist,
  }) : super(key: key);

  Future<void> _pickNewDateTime(BuildContext context, Function(DateTime) onPicked) async {
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
    final newDateTime = DateTime(newDate.year, newDate.month, newDate.day, newTime.hour, newTime.minute);
    onPicked(newDateTime);
  }

  void _reschedule(BuildContext context) {
    _pickNewDateTime(context, (newDateTime) {
      context.read<AppointmentCubit>().rescheduleAppointment(appointment, newDateTime);
      Navigator.pop(context);
    });
  }

  void _cancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
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
    context.read<AppointmentCubit>().updateAppointmentStatus(updatedAppointment);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Time: ${appointment.appointmentTime}'),
            Text('Patient: ${appointment.patientId}'),
            Text('Specialist: ${appointment.specialistId}'),
            Text('Status: ${appointment.status.toString().split('.').last}'),
            const SizedBox(height: 20),
            if (!isSpecialist)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () => _reschedule(context), child: const Text('Reschedule')),
                  ElevatedButton(onPressed: () => _cancel(context), child: const Text('Cancel')),
                ],
              ),
            if (isSpecialist)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _updateStatus(context, AppointmentStatus.confirmed),
                    child: const Text('Accept'),
                  ),
                  ElevatedButton(
                    onPressed: () => _updateStatus(context, AppointmentStatus.declined),
                    child: const Text('Decline'),
                  ),
                  ElevatedButton(onPressed: () => _reschedule(context), child: const Text('Reschedule')),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
