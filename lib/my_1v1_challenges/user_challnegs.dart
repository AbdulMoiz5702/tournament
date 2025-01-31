import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/challenge_card.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import '../challenges_details/challenges_details_screen.dart';
import '../chat_screens/messages.dart';
import '../controllers/token_update_controller.dart';
import '../reusbale_widget/customLeading.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';
import 'myAccepted_challenges.dart';

class UserAcceptedChallengesScreen extends StatelessWidget {
  final String userId;
  final bool isProfileScreen ;
  const UserAcceptedChallengesScreen({super.key,required this.userId,this.isProfileScreen = false});
  @override
  Widget build(BuildContext context) {
    var tokenController = Get.put(TokenUpdateController());
    return isProfileScreen == true ? BgWidget(
      child: Scaffold(
        backgroundColor: transparentColor,
        appBar: AppBar(
          leading: CustomLeading(),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 55),
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.sizeOf(context).width * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Sized(height: 0.005),
                      largeText(
                        title: 'Accepted Challenges',
                        context: context,
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                      ),
                      Sized(height: 0.005),
                      smallText(
                        title: 'Enter Your Valid Information .',
                        color: secondaryTextColor.withOpacity(0.85),
                        fontWeight: FontWeight.w500,
                      ),
                      Sized(height: 0.005),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          color: whiteColor,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection(challengesCollection).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CustomIndicator(),
                );
              }
              return ListView(
                children: snapshot.data!.docs.map((challengeDoc) {
                  return StreamBuilder(
                    stream: fireStore
                        .collection(challengesCollection)
                        .doc(challengeDoc.id)
                        .collection(challengesTeamCollection)
                        .where('accepterId', isEqualTo:userId)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> teamSnapshot) {
                      tokenController.updateTokenForUserAcceptedChallenges(docId: challengeDoc.id);
                      if (!teamSnapshot.hasData) {
                        return const SizedBox.shrink();
                      }
                      if (teamSnapshot.data!.docs.isNotEmpty) {
                        final challengeData = challengeDoc.data() as Map<String, dynamic>;
                        DateTime date = DateTime.parse(challengeData['startDate']); // Assuming 'startDate' is a string
                        String formattedDate = DateFormat('dd MMM yyyy').format(date);
                        return ChallengeCard(
                            age: challengeData['age'],
                            area: challengeData['area'],
                            startTime:  challengeData['startTime'],
                            seeDetails: (){
                              Get.to(()=> ChallengesDetailsScreen(data: challengeData,));
                            },
                            onMessage: (){
                              Get.to(()=> MessageScreen(receiverId: challengeData['challenger'],receiverName: challengeData['teamLeaderName'],receiverToken: challengeData['token'],userId:currentUser!.uid,));
                            },
                            startDate: formattedDate,
                            imagePath: challengeData['imagePath'],
                            challengerTeamName: challengeData['challengerTeamName'],
                            teamLeaderName: challengeData['teamLeaderName'],
                            challengerLeaderPhone:
                            challengeData['challengerLeaderPhone'],
                            location: challengeData['location'],
                            matchOvers: challengeData['Over'],
                            teamCount: challengeData['teamCount'],
                            userId: userId,
                            challengerId: challengeData['challenger'],
                            isChallengeAccepted:
                            challengeData['isChallengeAccepted'],
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => MyAcceptedChallenges(
                                        challengeDoc.id,
                                        userId,
                                        challengeData['isChallengeAccepted'])),
                              );
                            });
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    ) : StreamBuilder(
      stream: FirebaseFirestore.instance.collection(challengesCollection).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CustomIndicator(),
          );
        }
        return ListView(
          children: snapshot.data!.docs.map((challengeDoc) {
            return StreamBuilder(
              stream: fireStore
                  .collection(challengesCollection)
                  .doc(challengeDoc.id)
                  .collection(challengesTeamCollection)
                  .where('accepterId', isEqualTo:userId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> teamSnapshot) {
                tokenController.updateTokenForUserAcceptedChallenges(docId: challengeDoc.id);
                if (!teamSnapshot.hasData) {
                  return const SizedBox.shrink();
                }
                if (teamSnapshot.data!.docs.isNotEmpty) {
                  final challengeData = challengeDoc.data() as Map<String, dynamic>;
                  DateTime date = DateTime.parse(challengeData['startDate']); // Assuming 'startDate' is a string
                  String formattedDate = DateFormat('dd MMM yyyy').format(date);
                  return ChallengeCard(
                      age: challengeData['age'],
                      area: challengeData['area'],
                      startTime:  challengeData['startTime'],
                      seeDetails: (){
                        Get.to(()=> ChallengesDetailsScreen(data: challengeData,));
                      },
                      onMessage: (){
                        Get.to(()=> MessageScreen(receiverId: challengeData['challenger'],receiverName: challengeData['teamLeaderName'],receiverToken: challengeData['token'],userId:currentUser!.uid,));
                      },
                      startDate: formattedDate,
                      imagePath: challengeData['imagePath'],
                      challengerTeamName: challengeData['challengerTeamName'],
                      teamLeaderName: challengeData['teamLeaderName'],
                      challengerLeaderPhone: challengeData['challengerLeaderPhone'],
                      location: challengeData['location'],
                      matchOvers: challengeData['Over'],
                      teamCount: challengeData['teamCount'],
                      userId: userId,
                      challengerId: challengeData['challenger'],
                      isChallengeAccepted:
                      challengeData['isChallengeAccepted'],
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => MyAcceptedChallenges(
                                  challengeDoc.id,
                                  userId,
                                  challengeData['isChallengeAccepted'])),
                        );
                      });
                } else {
                  return const SizedBox.shrink();
                }
              },
            );
          }).toList(),
        );
      },
    );
  }
}
