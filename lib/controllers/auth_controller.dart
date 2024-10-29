import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';

import '../BottomScreen.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {

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
        final newUser = UserModel(
          userId: user.uid,
          name: nameController.text.toString(),
          email: emailController.text.toString(),
          phoneNumber: phoneController.text.toString(),
          myRole: myRole.toString(),
          location: location.text.toString(),
        );
        await fireStore.collection(usersCollection).doc(user.uid).set(newUser.toMap());
        Get.to(()=> BottomScreen(userId: newUser.userId));
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
        Get.to(()=> BottomScreen(userId: user.uid.toString(),),);
      }
    } catch (error) {
      isLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error signing in with email and password')),);
    }
  }


}