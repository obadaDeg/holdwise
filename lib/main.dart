import 'package:firebase_core/firebase_core.dart';
import 'package:holdwise/pages/auth_page/reset_password_page.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:holdwise/holdwise.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  
  runApp(const HoldWise());
  // runApp(PasswordResetPage());
}

