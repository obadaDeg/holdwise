import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/features/appointments/data/cubits/appointment_cubit.dart';
import 'package:holdwise/features/appointments/data/models/appointment.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedSpecialistId;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<Map<String, dynamic>> _specialists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSpecialists();
  }

  Future<void> _fetchSpecialists() async {
    setState(() => _isLoading = true);
    try {
      final specialistsSnapshot = await FirebaseFirestore.instance
          .collection('specialists')
          .where('isActive', isEqualTo: true)
          .get();

      setState(() {
        _specialists = specialistsSnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  'name': doc.data()['displayName'] ?? 'Unknown',
                  'specialization': doc.data()['specialization'] ?? 'General',
                  'rating': doc.data()['rating'] ?? 0.0,
                })
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading specialists: $e')),
      );
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)), // Limit to 30 days
      selectableDayPredicate: (DateTime date) {
        // Disable weekends if needed
        return date.weekday < 6; // Monday to Friday
      },
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _selectedTime = null; // Reset time when date changes
      });
    }
  }

  Future<void> _pickTime() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date first')),
      );
      return;
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: false,
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      // Check if the selected time is within business hours (9 AM to 5 PM)
      if (pickedTime.hour < 9 || pickedTime.hour >= 17) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a time between 9 AM and 5 PM'),
          ),
        );
        return;
      }

      setState(() => _selectedTime = pickedTime);
    }
  }

  Widget _buildSpecialistsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _specialists.length,
      itemBuilder: (context, index) {
        final specialist = _specialists[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: RadioListTile<String>(
            value: specialist['id'],
            groupValue: _selectedSpecialistId,
            onChanged: (value) {
              setState(() => _selectedSpecialistId = value);
            },
            title: Text(specialist['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(specialist['specialization']),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    Text(' ${specialist['rating'].toStringAsFixed(1)}'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateTimeSection() {
    final dateStr = _selectedDate == null
        ? 'Select Date'
        : DateFormat('EEEE, MMMM d, y').format(_selectedDate!);
    final timeStr =
        _selectedTime == null ? 'Select Time' : _selectedTime!.format(context);

    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(dateStr),
            onTap: _pickDate,
          ),
        ),
        Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(timeStr),
            onTap: _pickTime,
          ),
        ),
      ],
    );
  }

  void _submit() async {
    if (_formKey.currentState?.validate() != true ||
        _selectedDate == null ||
        _selectedTime == null ||
        _selectedSpecialistId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final appointmentDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    // Check if the selected time is in the past
    if (appointmentDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot book appointments in the past')),
      );
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to book an appointment')),
      );
      return;
    }

    // Show confirmation dialog
    final specialist = _specialists.firstWhere(
        (s) => s['id'] == _selectedSpecialistId,
        orElse: () => {'name': 'Unknown'});

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Specialist: ${specialist['name']}'),
            Text('Date: ${DateFormat('EEEE, MMMM d, y').format(_selectedDate!)}'),
            Text('Time: ${_selectedTime!.format(context)}'),
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

    if (confirm != true) return;

    final appointment = Appointment(
      id: '',
      patientId: currentUser.uid,
      patientName: currentUser.displayName ?? 'Unknown',
      specialistId: _selectedSpecialistId!,
      specialistName: specialist['name'],
      appointmentTime: appointmentDateTime,
      status: AppointmentStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await context.read<AppointmentCubit>().bookAppointment(appointment);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment booked successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error booking appointment: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule an Appointment')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Select Specialist',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSpecialistsList(),
                    const SizedBox(height: 24),
                    const Text(
                      'Select Date & Time',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDateTimeSection(),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Book Appointment'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}