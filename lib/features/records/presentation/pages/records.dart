import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/config/constants.dart';
import 'package:holdwise/app/config/themes.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:holdwise/features/records/presentation/pages/patient_records.dart';
import 'package:holdwise/features/records/presentation/pages/specialist_records.dart';
import 'package:holdwise/features/records/presentation/pages/admin_reports.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.read<AuthCubit>().state is AuthAuthenticated
        ? (context.read<AuthCubit>().state as AuthAuthenticated).role
        : AppRoles.patient;
    print('$role records screen');
    String title = role == AppRoles.patient 
        ? 'Your Records' 
        : role == AppRoles.specialist 
            ? 'Patient Compliance Records' 
            : 'System Analytics';

    return Scaffold(
      appBar: RoleBasedAppBar(title: title, displayActions: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildRoleBasedContent(role),
      ),
    );
  }

  Widget _buildRoleBasedContent(String role) {
    switch (role) {
      case AppRoles.specialist:
        return const SpecialistRecords();
      case AppRoles.admin:
        return const AdminReports();
      default:
        return const PatientRecords();
    }
  }
}
