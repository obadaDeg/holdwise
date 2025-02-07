import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:holdwise/app/holdwise_app.dart';
import 'package:holdwise/features/sensors/data/cubits/sensors_cubit.dart';
import 'package:holdwise/features/sensors/data/models/orientation_data.dart';
import 'package:holdwise/features/sensors/data/models/sensor_data.dart';
import 'package:holdwise/features/sensors/data/services/sensors_service.dart';
import 'package:holdwise/features/sensors/data/services/background_services.dart';
import 'app/config/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _initializeNotifications();
  await initializeBackgroundService();

  final sensorService = HoldWiseSensorService();
  final sensorCubit = SensorCubit(sensorService);

  // Listen for background service updates
  FlutterBackgroundService().on("update").listen((event) {
    if (event != null) {
      print("📥 Received Update in Main App: $event");

      if (event.containsKey("sensorData")) {
        final sensorData = SensorData.fromMap(event["sensorData"]);
        sensorCubit.updateSensorData(sensorData);
      }

      if (event.containsKey("orientation")) {
        final orientationData = OrientationData.fromMap(event["orientation"]);
        sensorCubit.updateOrientation(orientationData);
      }
    }
  });

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then((_) {
    runApp(BlocProvider(
      create: (context) => sensorCubit,
      child: HoldWiseApp(),
    ));
  });
}


Future<void> _initializeNotifications() async {
  var result = await FlutterNotificationChannel().registerNotificationChannel(
    description: 'For Showing Chat Notifications',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chat Notifications',
  );
  debugPrint('Notification Channel Result: $result');
}


// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => ThemeCubit(),
//       child: BlocBuilder<ThemeCubit, ThemeMode>(
//         builder: (context, themeMode) {
//           return MaterialApp(
//             title: 'HoldWise',
//             theme: AppTheme.lightTheme(context),
//             darkTheme: AppTheme.darkTheme(context),
//             themeMode: themeMode,
//             home: const HomePage(),
//           );
//         },
//       ),
//     );
//   }
// }
// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('HoldWise App Theme'),
//           actions: [
//             IconButton(
//               icon: Icon(
//                 context.read<ThemeCubit>().state == ThemeMode.dark
//                     ? Icons.light_mode
//                     : Icons.dark_mode,
//               ),
//               onPressed: () {
//                 context.read<ThemeCubit>().toggleTheme();
//               },
//             ),
//           ],
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'Tab 1'),
//               Tab(text: 'Tab 2'),
//               Tab(text: 'Tab 3'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             _buildTabContent(context, 'Welcome to HoldWise!'),
//             _buildTabContent(context, 'Explore Features'),
//             _buildTabContent(context, 'Settings & Info'),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             _showCustomDialog(context);
//           },
//           child: const Icon(Icons.add),
//         ),
//       ),
//     );
//   }

//   Widget _buildTabContent(BuildContext context, String title) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Text(
//             title,
//             style: Theme.of(context).textTheme.headlineLarge,
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () {},
//             child: const Text('Elevated Button'),
//           ),
//           const SizedBox(height: 16),
//           LinearProgressIndicator(),
//           const SizedBox(height: 16),
//           CircularProgressIndicator(),
//         ],
//       ),
//     );
//   }

//   void _showCustomDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Modal Title',
//               style: Theme.of(context).dialogTheme.titleTextStyle),
//           content: Text('This is the modal content.',
//               style: Theme.of(context).dialogTheme.contentTextStyle),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('CLOSE'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }