import 'package:flutter/material.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoleBasedAppBar(title: 'Schedule an appointment', displayActions: false),
      body: Center(
        child: Text('Schedule'),
      ),
    );
  }
}