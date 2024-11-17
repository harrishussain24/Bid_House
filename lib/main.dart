// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/screens/authentication/signUp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await dotenv.load(fileName: "lib/.env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bid House',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFfffffff),
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.appColor),
        useMaterial3: true,
      ),
      routes: {
        '/afterlogout': (context) => const SignUpScreen(),
      },
      home: const SignUpScreen(),
    );
  }
}
