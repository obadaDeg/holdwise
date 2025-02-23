import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/app/cubits/theme_cubit/theme_cubit.dart';
import 'package:holdwise/features/records/data/cubits/patient_cubit/patient_cubit.dart';
import 'package:holdwise/features/records/data/models/patient.dart';
import 'package:holdwise/features/records/presentation/pages/patient_statistics_screen.dart';
class SpecialistRecords extends StatefulWidget {
  const SpecialistRecords({Key? key}) : super(key: key);

  @override
  _SpecialistRecordsState createState() => _SpecialistRecordsState();
}

class _SpecialistRecordsState extends State<SpecialistRecords> {
  @override
  Widget build(BuildContext context) {
    // Retrieve the specialist ID from the AuthCubit state.
    final authState = context.read<AuthCubit>().state;
    final specialistId = (authState as AuthAuthenticated).user.uid;
    // Use ThemeCubit for dark/light mode if needed.
    final isDarkMode = context.read<ThemeCubit>().state == ThemeMode.dark;

    return BlocProvider(
      create: (_) => PatientCubit()..fetchPatients(specialistId),
      child: BlocBuilder<PatientCubit, PatientState>(
        builder: (context, state) {
          if (state is PatientLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PatientLoaded) {
            final patients = state.patients;
            if (patients.isEmpty) {
              return const Center(child: Text('No patients found.'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PatientCubit>().fetchPatients(specialistId);
              },
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                itemCount: patients.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(patient.imageUrl),
                      ),
                      title: Text(
                        patient.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PatientStatisticsScreen(
                              patientId: patient.id,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          } else if (state is PatientError) {
            return Center(
              child: Text(
                'Could not load patients.',
                style: TextStyle(color: AppColors.error),
              ),
            );
          }
          return const Center(child: Text('No patients found.'));
        },
      ),
    );
  }
}
