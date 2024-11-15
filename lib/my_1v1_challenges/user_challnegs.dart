import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/reusbale_widget/challenge_card.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import '../controllers/token_update_controller.dart';
import 'myAccepted_challenges.dart';

class UserAcceptedChallengesScreen extends StatelessWidget {
  final String userId;
  UserAcceptedChallengesScreen({required this.userId});
  @override
  Widget build(BuildContext context) {
    var tokenController = Get.put(TokenUpdateController());
    return Scaffold(
      body: StreamBuilder(
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
                    String formattedDate = DateFormat('EEEE, yyyy/MM/dd').format(date); // You can adjust the format
                    return Container(
                      margin: EdgeInsets.all(8),
                      child: ChallengeCard(
                          startDate: formattedDate,
                          imagePath: challengeData['imagePath'],
                          challengerTeamName: challengeData['challengerTeamName'],
                          teamLeaderName: challengeData['teamLeaderName'],
                          challengerLeaderPhone:
                              challengeData['challengerLeaderPhone'],
                          location: challengeData['location'],
                          matchOvers: challengeData['Overs'],
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
                          }),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
