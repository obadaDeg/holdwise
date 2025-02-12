import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:holdwise/app/holdwise_app.dart';
import 'package:holdwise/features/notifications/data/cubits/notification_cubit.dart';
import 'package:holdwise/features/sensors/data/cubits/sensors_cubit.dart';
import 'package:holdwise/features/sensors/data/models/orientation_data.dart';
import 'package:holdwise/features/sensors/data/models/sensor_data.dart';
import 'package:holdwise/features/sensors/data/repositories/sensor_repository.dart';
import 'package:holdwise/features/sensors/data/services/local_database.dart';
import 'package:holdwise/features/sensors/data/services/sensors_service.dart';
import 'package:holdwise/features/sensors/data/services/background_services.dart';
import 'app/config/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 2. Configure notification channel
  await _initializeNotifications();

  // 3. Initialize background service
  await initializeBackgroundService();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 4. Create local database instance.
  // Make sure your generated file 'local_database.g.dart' exists
  final localDatabase = LocalDatabase();

  // 5. Create the sensor repository using the local database.
  final sensorRepository = SensorRepository(localDatabase);

  // 6. Create sensor service & cubits (single instances)
  final sensorService = HoldWiseSensorService();
  final notificationsCubit = NotificationsCubit();
  final sensorCubit = SensorCubit(
    sensorService,
    notificationsCubit: notificationsCubit,
    sensorRepository: sensorRepository,
  );

  // 7. Listen for background service updates.
  FlutterBackgroundService().on("update").listen((event) {
    if (event != null) {
      if (event.containsKey("sensorData")) {
        final sensorData = SensorData.fromMap(event["sensorData"]);
        log(sensorData.toString());
        sensorCubit.updateSensorData(sensorData);
      }
      if (event.containsKey("orientation")) {
        final orientationData = OrientationData.fromMap(event["orientation"]);
        sensorCubit.updateOrientation(orientationData);
      }
    }
  });

  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sensorCubit),
        BlocProvider.value(value: notificationsCubit),
      ],
      child: const HoldWiseApp(),
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

Future<void> _initializeNotifications() async {
  var result = await FlutterNotificationChannel().registerNotificationChannel(
    description: 'For background posture notifications',
    id: 'holdwise_posture_channel',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'HoldWise Posture Alerts',
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