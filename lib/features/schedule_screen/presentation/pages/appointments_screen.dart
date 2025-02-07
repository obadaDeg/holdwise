import 'package:flutter/material.dart';
 
class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({Key? key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule an appointment'),
      ),
      body: Center(
        child: Text('Schedule'),
      ),
    );
  }
}