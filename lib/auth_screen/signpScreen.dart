// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tournemnt/BottomScreen.dart';
import 'package:tournemnt/auth_screen/login_Screen.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/consts/images_path.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';
import 'package:tournemnt/models_classes.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  String? myRole;
  bool isLoading = false;

  final key = GlobalKey<FormState>();

  List<String> roles = [
    'Bowler',
    'Batsman',
    'Opener',
    'Fast Bowler',
    'Hitter',
  ];

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
              children: [
                Sized(
                  height: 0.06,
                ),
                Sized(
                  height: 0.03,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: largeText(title: 'Create Account',context: context)),
                Sized(
                  height: 0.001,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: smallText(title: 'Enter your valid information to join our app.',context: context)),
                Sized(
                  height: 0.02,
                ),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter UserName': null ;
                  },
                  controller: nameController,
                  hintText: 'Username',
                  title: 'Username',
                ),
                Sized(
                  height: 0.02,
                ),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter Phone No': null ;
                  },
                  controller: phoneController,
                  hintText: 'Phone',
                  keyboardType: TextInputType.number,
                  title:  'Phone'
                ),
                Sized(
                  height: 0.02,
                ),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter Address': null ;
                  },
                  controller: location,
                  hintText: 'Address',
                  title:'Address',
                ),
                Sized(height: 0.02,),
                CustomTextField(
                  validate: (value){
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
                  validate: (value){
                    return value.isEmpty ? 'Enter Password': null ;
                  },
                  controller: passwordController,
                  hintText: 'Password',
                  title: 'Password',
                ),
                Sized(
                  height: 0.02,
                ),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Retype Password': null ;
                  },
                  controller: confirmPassword,
                  hintText: 'Confirm Password',
                  title: 'Confirm Password',
                ),
                Sized(height: 0.03,),
                Align(
                  alignment: Alignment.centerLeft,
                    child: smallText(title: 'My Role in Team:',context: context,fontSize: 10,color: iconColor)),
                Sized(height: 0.01,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(roles.length, (index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setState(() {
                        myRole = roles[index];
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Chip(
                        autofocus: true,
                        backgroundColor: myRole == roles[index]
                            ? blueColor// Highlight selected role
                            : secondaryWhiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        label: smallText(
                          title: roles[index],
                          context: context,
                          fontSize: 10,
                          color:myRole == roles[index] ?  whiteColor : secondaryTextColor
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
                Sized(
                  height: 0.03,
                ),
              isLoading == true ?const  Center(child: CircularProgressIndicator(color: blueColor,),):  CustomButton(
                    title: 'Create Account',
                    onTap: () {
                      if(key.currentState!.validate() ){
                        if(confirmPassword.text.toString() == passwordController.text.toString()){
                          if(myRole!.isNotEmpty){
                            signInWithEmailPassword(context);
                          }else{
                            ToastClass.showToastClass(context: context, message: 'Please Select Role in your team');
                          }
                        }else{
                          ToastClass.showToastClass(context: context, message: 'Confirm Password and Password must be same');
                        }
                      }else{
                        ToastClass.showToastClass(context: context, message: 'Please Fill all the Fields');
                      }
                    }),
                Sized(
                  height: 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    smallText(
                      title: 'Already have an account ?  ',
                      context: context,
                      color: iconColor
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: smallText(
                            title: 'Login', fontSize: 16, context: context,color: blueColor)),
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
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      isLoading = false;
      setState(() {});
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
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set(newUser.toMap());
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => BottomScreen(userId: newUser.userId),
          ),
        );
        throw ToastClass.showToastClass(context: context, message: 'Signup Successfully');
      }
    } catch (error) {
      isLoading = false;
      setState(() {});
      throw ToastClass.showToastClass(context: context, message: 'Failed to signup : Error $error');
    }
  }
}
