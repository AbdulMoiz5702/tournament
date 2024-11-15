import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import '../BottomScreen.dart';
import '../models/user_model.dart';
import '../services/notification_sevices.dart';
import 'call_controller.dart';

class AuthController extends GetxController {

  final NotificationServices notificationServices = NotificationServices();
  var callController  = Get.put(ZegoCloudController());

  List<String> roles = [
    'Bowler',
    'Batsman',
    'Opener',
    'Fast Bowler',
    'Hitter',
  ];

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var location = TextEditingController();
  var confirmPassword = TextEditingController();
  var  myRole = ''.obs;
  var isLoading = false.obs;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    location.dispose();
    confirmPassword.dispose();
  }

  void createAccount(BuildContext context) async {
    try {
      isLoading(true);
      final String email = emailController.text.toString();
      final String password = passwordController.text.toString();
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        await notificationServices.requestNotificationPermission();
        await notificationServices.firebaseInit(context);
        try {
          String? token = await notificationServices.getDeviceToken();
          if (token != null) {
            print('Firebase Token : $token');
            userToken = token;
          } else {
            print('Error: Firebase token could not be retrieved.');
          }
        } catch (e) {
          print('Error retrieving token: $e');
        }
        final newUser = UserModel(
          userId: user.uid,
          name: nameController.text.toString(),
          email: emailController.text.toString(),
          phoneNumber: phoneController.text.toString(),
          myRole: myRole.toString(),
          location: location.text.toString(),
          token: userToken,
          isOnline: false,
          imageLink: 'none',
        );
        await fireStore.collection(usersCollection).doc(user.uid).set(newUser.toMap());
        Get.offAll(()=> BottomScreen(userId: newUser.userId));
        callController.startCall(userId: user.uid, userName: nameController.text.toString(), context: context);
      }
      isLoading(false);
    } catch (error) {
      isLoading(false);
    }
  }

  void signInWithEmailPassword(BuildContext context) async {
    try {
      isLoading(true);
      final String email = emailController.text.toString();
      final String password = passwordController.text.toString();
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(const Duration(seconds: 5),onTimeout: (){
        isLoading(false);
        throw Text('');
      });
      isLoading(false);
      final User? user = userCredential.user;
      if (user != null) {
        isLoading(false);
        await notificationServices.requestNotificationPermission();
        await notificationServices.firebaseInit(context);
        try {
          String? token = await notificationServices.getDeviceToken();
          if (token != null) {
            print('Firebase Token : $token');
            userToken = token;
          } else {
            print('Error: Firebase token could not be retrieved.');
          }
        } catch (e) {
          print('Error retrieving token: $e');
        }
        Get.offAll(()=> BottomScreen(userId: user.uid.toString(),),);
        callController.startCall(userId: user.uid, userName: callController.userName, context: context);
      }
    } catch (error) {
      isLoading(false);
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error signing in with email and password')),);
    }
  }


}