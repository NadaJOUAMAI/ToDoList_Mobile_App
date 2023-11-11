import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/widgets/auth_verify.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(elevation: 0),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
            .copyWith(background: Colors.red.shade50),
        scaffoldBackgroundColor: Color.fromARGB(255, 254, 239, 255),
      ),
      home: const AuthVerify(),
    ),
  );
}
