import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tournemnt/consts/colors.dart';
import 'Splash_screen.dart';
import 'auth_screen/login_Screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: whiteColor,
        appBarTheme:const AppBarTheme(
          centerTitle: true,
          color: whiteColor,
        ),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

