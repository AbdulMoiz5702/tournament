import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/1v1_challenges/add_challenges.dart';
import 'package:tournemnt/1v1_challenges/view_challnege_screen.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/custom_floating_action.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';

import '../challenges_details/challenges_details_screen.dart';
import '../chat_screens/messages.dart';
import '../consts/colors.dart';
import '../reusbale_widget/challenge_card.dart';
import '../reusbale_widget/custom_sizedBox.dart';

class ChallengesListScreen extends StatelessWidget {
  final String userId ;
  const ChallengesListScreen({super.key,required this.userId});
  @override
  Widget build(BuildContext context) {
    return BgWidget(
      child: Scaffold(
          backgroundColor: transparentColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 30),
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
                          fontSize: 18,
                          title: 'Friendly and Challenges Match ',
                          context: context,
                          fontWeight: FontWeight.w500,
                          color: whiteColor,
                        ),
                        Sized(height: 0.005),
                        smallText(
                          title: 'Here Below the list of Challenges',
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
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  DateTime date = DateTime.parse(doc['startDate']); // Assuming 'startDate' is a string
                  String formattedDate = DateFormat('dd MMM yyyy').format(date);
                  return ChallengeCard(
                    age: doc['age'],
                    area: doc['area'],
                    startTime:  doc['startTime'],
                    seeDetails: (){
                      Get.to(()=> ChallengesDetailsScreen(data: doc,));
                    },
                    onMessage: (){
                      Get.to(()=> MessageScreen(receiverId: doc['challenger'],receiverName: doc['teamLeaderName'],receiverToken: doc['token'],userId:userId,));
                    },
                    onTap: (){
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => ViewChallengeScreen(doc.id,userId,doc['isChallengeAccepted'])),
                      );
                    },
                    startDate: formattedDate,
                    imagePath: doc['imagePath'],
                    challengerTeamName:doc['challengerTeamName'],
                    teamLeaderName:doc['teamLeaderName'] ,
                    challengerLeaderPhone: doc['challengerLeaderPhone'],
                    matchOvers: doc['Over'],
                    challengerId:doc['challenger'],
                    location:doc['location'],
                    teamCount:doc['teamCount'],
                    userId: userId,
                    isChallengeAccepted: doc['isChallengeAccepted'],
                  );
                }).toList(),
              );
            },
          ),
        ),
        floatingActionButton:CustomFloatingAction(onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => AddChallengeScreen(userId: userId,)),
          );
        },)
      ),
    );
  }
}

