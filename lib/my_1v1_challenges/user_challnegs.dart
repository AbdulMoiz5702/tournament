import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tournemnt/reusbale_widget/challenge_card.dart';
import '../1v1_challenges/view_challnege_screen.dart';
import 'myAccepted_challenges.dart';

class UserAcceptedChallengesScreen extends StatefulWidget {
  final String userId;

  UserAcceptedChallengesScreen({required this.userId});

  @override
  State<UserAcceptedChallengesScreen> createState() => _UserAcceptedChallengesScreenState();
}

class _UserAcceptedChallengesScreenState extends State<UserAcceptedChallengesScreen> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('challenges').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((challengeDoc) {
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('challenges')
                    .doc(challengeDoc.id)
                    .collection('teams')
                    .where('accepterId', isEqualTo: widget.userId)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> teamSnapshot) {
                  if (!teamSnapshot.hasData) {
                    return const SizedBox.shrink();
                  }
                  if (teamSnapshot.data!.docs.isNotEmpty) {
                    final challengeData = challengeDoc.data() as Map<String, dynamic>;
                    return Container(
                      margin: EdgeInsets.all(8),
                      child: ChallengeCard(
                          startDate: challengeData['startDate'],
                          imagePath: challengeData['imagePath'],
                          challengerTeamName: challengeData['challengerTeamName'],
                          teamLeaderName: challengeData['teamLeaderName'],
                          challengerLeaderPhone:
                              challengeData['challengerLeaderPhone'],
                          location: challengeData['location'],
                          matchOvers: challengeData['Overs'],
                          teamCount: challengeData['teamCount'],
                          userId: widget.userId,
                          challengerId: challengeData['challenger'],
                          isChallengeAccepted:
                              challengeData['isChallengeAccepted'],
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => MyAcceptedChallenges(
                                      challengeDoc.id,
                                      widget.userId,
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
