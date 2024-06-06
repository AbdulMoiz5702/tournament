import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tournemnt/auth_screen/login_Screen.dart';
import 'package:tournemnt/consts/colors.dart';

import 'BottomScreen.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  FirebaseAuth auth = FirebaseAuth.instance ;
  checkUserStatus() {
    Future.delayed(const Duration(seconds: 2),(){
      if(auth.currentUser != null){
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=> BottomScreen(userId: auth.currentUser!.uid,)));
      }else{
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=> LoginPage()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      body: Center(
        child: Image.asset('assets/images/splash.jpg',fit: BoxFit.cover,),
      ),
    );
  }
}
