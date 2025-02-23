import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/cubits/theme_cubit/theme_cubit.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:holdwise/features/records/data/cubits/hourly_summary_cubit/hourly_summary_cubit.dart';
import 'package:holdwise/features/records/data/models/hourly_summary.dart';

class PatientStatisticsScreen extends StatelessWidget {
  final String patientId;

  const PatientStatisticsScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Note: accessing ThemeCubit here is okay if it's provided higher in the tree.
    return BlocProvider(
      create: (_) => HourlySummariesCubit()..fetchSummariesForPatient(patientId),
      child: Builder(
        builder: (context) {
          final isDarkMode = context.read<ThemeCubit>().state == ThemeMode.dark;
          return Scaffold(
            appBar: RoleBasedAppBar(title: 'Patient Statistics', displayActions: false),
            body: RefreshIndicator(
              onRefresh: () async {
                // Now context is below the BlocProvider, so this works correctly.
                await context.read<HourlySummariesCubit>().fetchSummariesForPatient(patientId);
              },
              child: BlocBuilder<HourlySummariesCubit, List<HourlySummary>>(
                builder: (context, summaries) {
                  if (summaries.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Center(child: Text('No summaries available.')),
                        )
                      ],
                    );
                  }

                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: summaries.length,
                    itemBuilder: (context, index) {
                      final summary = summaries[index];
                      return ListTile(
                        title: Text('Hour: ${summary.dateTime.hour}'),
                        subtitle: Text('Posture Violations: ${summary.postureViolations}'),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
