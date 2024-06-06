// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tournemnt/BottomScreen.dart';
import 'package:tournemnt/auth_screen/forgot_password-screen.dart';
import 'package:tournemnt/auth_screen/signpScreen.dart';
import 'package:tournemnt/consts/images_path.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';

import '../consts/colors.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  final  key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Sized(height: 0.04,),
                Image.asset(appLogo,height: MediaQuery.sizeOf(context).height * 0.2,alignment: Alignment.center,),
                Sized(
                  height: 0.03,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                    child: largeText(title: 'Let\'s you Login',context: context)),
                Sized(
                  height: 0.001,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: smallText(title: 'Enter your email and password.',context: context)),
                Sized(
                  height: 0.015,
                ),
                CustomTextField(
                  validate: (value) {
                    return value.isEmpty ? 'Enter Email': null ;
                  },
                  controller: emailController,
                  hintText: 'Email',
                  title: 'Email',
                ),
                Sized(
                  height: 0.02,
                ),
                CustomTextField(
                  validate: (value) {
                    return value.isEmpty ? 'Enter password': null ;
                  },
                  controller: passwordController,
                  hintText: 'Password',
                  title: 'Password',
                ),
                Sized(
                  height: 0.03,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const ForgotScreen()));
                        },
                        child: smallText(
                            title: 'Forgot Password ?',
                            context: context,
                            fontSize: 12,
                            color: blueColor))),
                Sized(
                  height: 0.03,
                ),
               isLoading == true ? const Center(child: CircularProgressIndicator(color: blueColor,),) : CustomButton(
                    title: 'Login',
                    onTap: () {
                      if(key.currentState!.validate()){
                        signInWithEmailPassword(context);
                        setState(() {});
                      }
                    }),
                Sized(
                  height: 0.2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    smallText(
                      title: 'Don\'t have an account ? ',
                      context: context,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => SignupScreen()));
                        },
                        child: smallText(
                            title: 'Create an account', fontSize: 16, context: context,color: blueColor)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signInWithEmailPassword(BuildContext context) async {
    try {
      isLoading = true;
      setState(() {});
      final String email = emailController.text.toString();
      final String password = passwordController.text.toString();
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(const Duration(seconds: 5),onTimeout: (){
        isLoading = false;
            setState(() {});
          throw  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request time out')),);
          });
      isLoading = false;
      setState(() {});
      final User? user = userCredential.user;
      if (user != null) {
        isLoading = false;
        setState(() {});
        // Navigate to the main page after successful login
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => BottomScreen(
              userId: user.uid.toString(),
            ),
          ),
        );
      }
    } catch (error) {
      isLoading = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error signing in with email and password')),);
    }
  }
}
