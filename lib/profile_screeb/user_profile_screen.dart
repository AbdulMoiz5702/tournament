import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tournemnt/auth_screen/login_Screen.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/consts/images_path.dart';
import 'package:tournemnt/my_tournments/my_tournaments_teams/mymatches.dart';
import 'package:tournemnt/profile_screeb/update_user_profile.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';
import '../auth_screen/forgot_password-screen.dart';
import '../my_1v1_challenges/myChallenges.dart';
import '../my_1v1_challenges/user_challnegs.dart';
import '../my_tournments/my_tournaments_screen/myTournamnets.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  ProfileScreen({required this.userId});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('Users').doc(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child:
                  CircularProgressIndicator()); // Show loading indicator while data is being fetched
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return smallText(
              title: 'Check you internet',
              context: context,
              color: iconColor); // Handle case when no data is found
        }
        final userData = snapshot.data!.data() as Map<String, dynamic>;
        return Scaffold(
          appBar: PreferredSize(
              preferredSize: Size(
                MediaQuery.sizeOf(context).width * 1,
                MediaQuery.sizeOf(context).height * 0.39,
              ),
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  Container(
                    color: blueColor,
                    height: MediaQuery.of(context).size.height * 0.24,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.2,
                    child: Container(
                      color: whiteColor,
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.12,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        color: secondaryWhiteColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          strokeAlign: BorderSide.strokeAlignOutside,
                          color: whiteColor,
                          width: 2,
                        ),
                        image: DecorationImage(
                          image: userData['imageLink'] == 'none'
                              ? AssetImage('assets/images/team.png') as ImageProvider
                              : NetworkImage(userData['imageLink'])
                                  as ImageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.27,
                    child: mediumText(
                        title: userData['name'],
                        context: context,
                        color: primaryTextColor),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.31,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone,color: secondaryTextColor,size: 15,),
                        Sized(width:0.02,),
                        smallText(
                            title: userData['phoneNumber'],
                            context: context,),
                      ],
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.34,
                    child:  Row(
                      children: [
                      const   Icon(Icons.location_on,color: secondaryTextColor,size: 15,),
                        Sized(width:0.02,),
                        smallText(
                            title: userData['location'].toString().toUpperCase(),
                            context: context, ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.37,
                    child:  Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: secondaryWhiteColor,
                      ),
                      child: smallText(
                        title: userData['myRole'].toString().toUpperCase(),
                        context: context, color: blueColor,fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: List.generate(
                    imageNames.length, (index){
                  return GestureDetector(
                    onTap: (){
                      switch(index){
                        case 0:
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => UpdateProfileScreen(
                                  userId: userId,
                                  userName: userData['name'],
                                  email: userData['email'],
                                  phone: userData['phoneNumber'],
                                  location: userData['location'],
                                  myRole: userData['myRole'],
                                  imageLink: userData['imageLink'],
                                )));
                          break;
                        case 1:
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      MyTournamentsScreen(userId: userId)));
                          break;
                        case 2:
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      MyTournamentsTeams(userId: userId)));
                          break;
                        case 3:
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => UserChallengesScreen(
                                    userId: userId,
                                  )));
                          break;
                        case 4:
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      UserAcceptedChallengesScreen(userId: userId)));
                          break;
                        case 5:
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const ForgotScreen()));
                          break;
                        case 6:
                          FirebaseAuth.instance.signOut().then((value) {
                            Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => LoginPage()));
                            ToastClass.showToastClass(
                                context: context, message: 'Logout Successfully');
                          });
                          break;
                        default:
                          break;

                      }
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: whiteColor,
                      child:Container(
                        padding: EdgeInsets.all(5),
                        color: whiteColor,
                        height: MediaQuery.sizeOf(context).height * 0.06,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(imagesList[index]),
                                Sized(width: 0.05,),
                                smallText(title:imageNames[index],context: context,color: isTrue[index] == true ?  redColor : secondaryTextColor,),
                              ],
                            ),
                           const  Icon(Icons.arrow_forward_ios,color: secondaryTextFieldColor,size: 15,),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
