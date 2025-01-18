import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tournemnt/auth_screen/login_Screen.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/consts/images_path.dart';
import 'package:tournemnt/my_tournments/my_tournaments_teams/mymatches.dart';
import 'package:tournemnt/profile_screeb/update_user_profile.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';
import '../auth_screen/forgot_password-screen.dart';
import '../consts/firebase_consts.dart';
import '../my_1v1_challenges/myChallenges.dart';
import '../my_1v1_challenges/user_challnegs.dart';
import '../my_tournments/my_tournaments_screen/myTournamnets.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  const ProfileScreen({super.key,required this.userId});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: fireStore.collection(usersCollection).doc(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child:CustomIndicator());
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
                    decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage(bgImage),fit: BoxFit.cover),
                    ),
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
                              ? const AssetImage(profilePic) as ImageProvider
                              : NetworkImage(userData['imageLink'])
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.27,
                    child: mediumText(
                        title: userData['name'],
                        context: context,
                        color: blackColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.31,
                    child: smallText(
                        title: userData['phoneNumber'],
                        fontSize: 10.0,fontWeight: FontWeight.w500,color: cardTextColor),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.34,
                    child:  smallText(
                        title: userData['location'].toString().toUpperCase(),fontSize: 10.0,fontWeight: FontWeight.w500,color: cardTextColor),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.37,
                    child:  mediumText(
                      fontSize: 14.0,
                      title: userData['myRole'].toString().toUpperCase(),
                      context: context, color: userRoleColor,fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          body: Container(
            color: whiteColor,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    color: whiteColor,
                    child: Column(
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
                                            MyTournamentsScreen(userId: userId,isProfileScreen: true,)));
                                break;
                              case 2:
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            MyTournamentsTeams(userId: userId,isProfileScreen: true,)));
                                break;
                              case 3:
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => UserChallengesScreen(
                                          userId: userId,
                                          isProfileScreen: true,
                                        )));
                                break;
                              case 4:
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            UserAcceptedChallengesScreen(userId: userId,isProfileScreen: true,)));
                                break;
                              case 5:
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>  ForgotScreen()));
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(color: detailsBoxBorderColor)
                            ),
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            height: MediaQuery.sizeOf(context).height * 0.065,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(imagesList[index],color: buttonColor,),
                                    Sized(width: 0.05,),
                                 smallText(title: imageNames[index], fontSize: 14.0,fontWeight: FontWeight.w500,color:isTrue[index] == true ?  redColor : userProfileTextColor),
                                  ],
                                ),
                                 Icon(Icons.arrow_forward_ios,color: cardTextColor.withOpacity(0.5),size: 15,),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
