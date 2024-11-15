import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/1v1_challenges/add_challenges.dart';
import 'package:tournemnt/1v1_challenges/view_challnege_screen.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/reusbale_widget/custom_floating_action.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';

import '../reusbale_widget/challenge_card.dart';

class ChallengesListScreen extends StatelessWidget {
  final String userId ;
  ChallengesListScreen({required this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: largeText(title: '1 v 1 Challenges',context: context),
      ),
      body: StreamBuilder(
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
              String formattedDate = DateFormat('EEEE, yyyy/MM/dd').format(date); // You can adjust the format
              return Container(
                margin: EdgeInsets.all(5),
                child: ChallengeCard(
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
                  matchOvers: doc['Overs'],
                  challengerId:doc['challenger'],
                  location:doc['location'],
                  teamCount:doc['teamCount'],
                  userId: userId,
                  isChallengeAccepted: doc['isChallengeAccepted'],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton:CustomFloatingAction(onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => AddChallengeScreen(userId: userId,)),
        );
      },)
    );
  }
}

