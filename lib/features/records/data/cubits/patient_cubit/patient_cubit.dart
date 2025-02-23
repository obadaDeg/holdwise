import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:holdwise/features/records/data/models/patient.dart';
part 'patient_state.dart';

class PatientCubit extends Cubit<PatientState> {
  PatientCubit() : super(PatientInitial());

  Future<void> fetchPatients(String specialistId) async {
    try {
      emit(PatientLoading());
      final querySnapshot = await FirebaseFirestore.instance
          .collection('specialists')
          .doc(specialistId)
          .collection('patients')
          // .where('specialistId', isEqualTo: specialistId)
          .get();      
      final patients = querySnapshot.docs.map((doc) {
        return Patient.fromJson(doc.data(), doc.id);
      }).toList();

      emit(PatientLoaded(patients));
    } catch (e) {
      emit(PatientError(e.toString()));
      print("❌ Error fetching patients: $e");
    }
  }
}
