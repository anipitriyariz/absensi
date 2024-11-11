// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_demo/firebase_options.dart';
// import 'package:flutter_demo/presentation/home_page.dart';
import 'package:absensi/presentation/login_page.dart';
// import 'package:absensi/presentation/register_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_demo/presentation/login_page.dart';
// import 'package:google_fonts/google_fonts.dart';

void main() async {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const LoginPage(),
    );
  }
}
