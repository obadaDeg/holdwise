// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:holdwise/features/records/data/cubits/patient_cubit/patient_cubit.dart';
// import 'package:holdwise/features/records/data/models/patient.dart';
// import 'package:holdwise/features/records/presentation/pages/patient_statistics_screen.dart';

// class PatientList extends StatelessWidget {
//   final String specialistId;

//   const PatientList({Key? key, required this.specialistId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => PatientCubit()..fetchPatients(specialistId),
//       child: BlocBuilder<PatientCubit, PatientState>(
//         builder: (context, patients) {
//           if (patients.isEmpty) {
//             return const Center(child: Text('No patients found.'));
//           }

//           return ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: patients.length,
//             itemBuilder: (context, index) {
//               final patient = patients[index];
//               return ListTile(
//                 title: Text(patient.name),
//                 onTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (_) => PatientStatisticsScreen(patientId: patient.id),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
