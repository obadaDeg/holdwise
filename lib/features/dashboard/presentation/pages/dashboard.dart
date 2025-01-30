import 'package:flutter/material.dart';
import 'package:holdwise/app/config/constants.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:holdwise/common/widgets/role_based_side_navbar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoleBasedAppBar(
        role: AppRoles.patient,
        title: 'Dashboard',
      ),
      drawer: RoleBasedDrawer(role: AppRoles.patient),
      body: Center(
        child: Text('Dashboard'),
      ),
    );
  }
}