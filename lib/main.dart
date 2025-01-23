import 'package:firebase_core/firebase_core.dart';
import 'app/config/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:holdwise/holdwise.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

}

