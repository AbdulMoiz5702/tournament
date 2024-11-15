import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tournemnt/auth_screen/login_Screen.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/controllers/splash_controller.dart';
import 'consts/firebase_consts.dart';
import 'controllers/call_controller.dart';
import 'controllers/set_status_controller.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var controller  = Get.put(SplashController());
  var callController  = Get.put(ZegoCloudController());
  var statusController = Get.put(SetStatusController());
  checkUserStatus() {
    Future.delayed(const Duration(seconds: 2),(){
      if(auth.currentUser != null){
        controller.initialize(context);
        callController.startCall(userId: currentUser!.uid, userName: callController.userName, context: context);
        statusController.setStatus(isOnline: true);
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
