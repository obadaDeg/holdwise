import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/constants.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:holdwise/common/widgets/role_based_side_navbar.dart';
import 'package:holdwise/features/sensors/data/cubits/sensors_cubit.dart';
import 'package:holdwise/features/sensors/presentation/widgets/violation_scatter_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoleBasedAppBar(
        title: 'Dashboard',
      ),
      body: BlocBuilder<SensorCubit, SensorState>(
        builder: (context, state) {
          final orientationLog = state.orientationLog;
          final threshold = 70.0;
          final violations =
              orientationLog.where((o) => o.tiltAngle > threshold).toList();
          

          
          return SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      title: const Text('Total Violations This Hour'),
                      subtitle: Text('${violations.length}'),
                    ),
                  ),
                ),
                Card(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ListTile(
                      title: const Text('Current Tile Angle'),
                      subtitle: Text(
                        state.orientationLog.isNotEmpty
                            ? '${state.orientationLog.last.tiltAngle}'
                            : 'No orientation data available',
                      ),
                    ),
                  ),
                ),
                ViolationScatterChart(
                    violations: violations,
                    referenceDate: DateTime.now()),
              ],
            ),
          );
        },
      ),
    );
  }
}
