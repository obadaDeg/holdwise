import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      lastDate: DateTime.now().add(const Duration(days: 30)),
      selectableDayPredicate: (DateTime date) {
        return date.weekday < 6; // Monday to Friday
      },
    );
    
    if (newDate == null) return;

    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(appointment.appointmentTime),
    );

    if (newTime == null) return;

    // Validate business hours
    if (newTime.hour < 9 || newTime.hour >= 17) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a time between 9 AM and 5 PM'),
        ),
      );
      return;
    }

    final newDateTime = DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      newTime.hour,
      newTime.minute,
    );

    // Check if the time slot is available
    final isAvailable = await _checkTimeSlotAvailability(context, newDateTime);
    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This time slot is already booked. Please select another time.'),
        ),
      );
      return;
    }

    onPicked(newDateTime);
  }

  Future<bool> _checkTimeSlotAvailability(BuildContext context, DateTime newTime) async {
    try {
      // Check for existing appointments in the same time slot (±30 minutes)
      final startWindow = newTime.subtract(const Duration(minutes: 30));
      final endWindow = newTime.add(const Duration(minutes: 30));

      final conflictingAppointments = await FirebaseFirestore.instance
          .collection('appointments')
          .where('specialistId', isEqualTo: appointment.specialistId)
          .where('appointmentTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startWindow))
          .where('appointmentTime', isLessThanOrEqualTo: Timestamp.fromDate(endWindow))
          .where('status', whereIn: ['pending', 'confirmed'])
          .get();

      return conflictingAppointments.docs.isEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> _reschedule(BuildContext context) async {
    await _pickNewDateTime(context, (newDateTime) async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Reschedule'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('New appointment time:'),
              Text(DateFormat('EEEE, MMMM d, y').format(newDateTime)),
              Text(DateFormat('h:mm a').format(newDateTime)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await context.read<AppointmentCubit>().rescheduleAppointment(appointment, newDateTime);
        
        // Send notification to other party
        await _sendRescheduleNotification(context);
        
        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    });
  }

  Future<void> _sendRescheduleNotification(BuildContext context) async {
    try {
      final notificationData = {
        'type': 'appointment_rescheduled',
        'appointmentId': appointment.id,
        'timestamp': FieldValue.serverTimestamp(),
        'recipientId': isSpecialist ? appointment.patientId : appointment.specialistId,
        'senderId': isSpecialist ? appointment.specialistId : appointment.patientId,
        'title': 'Appointment Rescheduled',
        'body': 'Your appointment has been rescheduled. Please check the new time.',
      };

      await FirebaseFirestore.instance
          .collection('notifications')
          .add(notificationData);
    } catch (e) {
      debugPrint('Error sending notification: $e');
    }
  }

  void _cancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to cancel this appointment?'),
            const SizedBox(height: 8),
            if (appointment.appointmentTime.difference(DateTime.now()).inHours < 24)
              const Text(
                'Warning: Canceling with less than 24 hours notice may incur a fee.',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<AppointmentCubit>().cancelAppointment(appointment);
              await _sendCancelNotification(context);
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendCancelNotification(BuildContext context) async {
    try {
      final notificationData = {
        'type': 'appointment_cancelled',
        'appointmentId': appointment.id,
        'timestamp': FieldValue.serverTimestamp(),
        'recipientId': isSpecialist ? appointment.patientId : appointment.specialistId,
        'senderId': isSpecialist ? appointment.specialistId : appointment.patientId,
        'title': 'Appointment Cancelled',
        'body': 'Your appointment has been cancelled.',
      };

      await FirebaseFirestore.instance
          .collection('notifications')
          .add(notificationData);
    } catch (e) {
      debugPrint('Error sending notification: $e');
    }
  }

  Future<void> _updateStatus(BuildContext context, AppointmentStatus newStatus) async {
    final String actionText = newStatus == AppointmentStatus.confirmed ? 'accept' : 'decline';
    
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${actionText.substring(0, 1).toUpperCase()}${actionText.substring(1)} Appointment'),
        content: Text('Are you sure you want to $actionText this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: newStatus == AppointmentStatus.confirmed
                  ? AppColors.success
                  : AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text(actionText.substring(0, 1).toUpperCase() + actionText.substring(1)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final updatedAppointment = appointment.copyWith(status: newStatus);
      await context.read<AppointmentCubit>().updateAppointmentStatus(updatedAppointment);
      await _sendStatusUpdateNotification(context, newStatus);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _sendStatusUpdateNotification(BuildContext context, AppointmentStatus status) async {
    try {
      final notificationData = {
        'type': 'appointment_status_updated',
        'appointmentId': appointment.id,
        'timestamp': FieldValue.serverTimestamp(),
        'recipientId': appointment.patientId,
        'senderId': appointment.specialistId,
        'title': 'Appointment ${status.toString().split('.').last}',
        'body': 'Your appointment has been ${status.toString().split('.').last}.',
      };

      await FirebaseFirestore.instance
          .collection('notifications')
          .add(notificationData);
    } catch (e) {
      debugPrint('Error sending notification: $e');
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('EEEE, MMMM d, y • h:mm a').format(dateTime);
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.confirmed:
        return AppColors.success;
      case AppointmentStatus.pending:
        return AppColors.warning;
      case AppointmentStatus.declined:
      case AppointmentStatus.cancelled:
        return AppColors.error;
      case AppointmentStatus.completed:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = _formatDateTime(appointment.appointmentTime);
    final statusColor = _getStatusColor(appointment.status);
    
    return Scaffold(
      appBar: RoleBasedAppBar(
        title: 'Appointment Details',
        displayActions: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Appointment Time',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(formattedTime),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      Row(
                        children: [
                          Icon(
                            isSpecialist ? Icons.person : Icons.medical_services,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isSpecialist ? 'Patient' : 'Specialist',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  isSpecialist
                                      ? appointment.patientName
                                      : appointment.specialistName,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      Row(
                        children: [
                          const Icon(Icons.info_outline),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Status',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  appointment.status.toString().split('.').last,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (appointment.status != AppointmentStatus.cancelled &&
                  appointment.status != AppointmentStatus.completed)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isSpecialist && appointment.status == AppointmentStatus.pending)
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _updateStatus(
                                      context, AppointmentStatus.confirmed),
                                  icon: const Icon(Icons.check),
                                  label: const Text('Accept'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.success,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _updateStatus(
                                      context, AppointmentStatus.declined),
                                  icon: const Icon(Icons.close),
                                  label: const Text('Decline'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.error,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (appointment.status != AppointmentStatus.declined)
                          Column(
                            children: [
                              if (isSpecialist &&
                                  appointment.status == AppointmentStatus.pending)
                                const Divider(height: 24),
                              ElevatedButton.icon(
                                onPressed: () => _reschedule(context),
                                icon: const Icon(Icons.schedule),
                                label: const Text('Reschedule'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                onPressed: () => _cancel(context),
                                icon: const Icon(Icons.cancel),
                                label: const Text('Cancel Appointment'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.error,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}