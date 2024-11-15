import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/controllers/token_update_controller.dart';
import 'package:tournemnt/my_1v1_challenges/view_my_challenges.dart';
import 'package:tournemnt/reusbale_widget/Custom_slider.dart';
import 'package:tournemnt/reusbale_widget/challenge_card.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import '../controllers/User_Challenges_controller.dart';

class UserChallengesScreen extends StatefulWidget {
  final String userId;
  UserChallengesScreen({required this.userId});

  @override
  State<UserChallengesScreen> createState() => _UserChallengesScreenState();
}

class _UserChallengesScreenState extends State<UserChallengesScreen> {
  var controller = Get.put(UserChallengesController());
  var tokenController = Get.put(TokenUpdateController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenController.updateUserChallengerToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(challengesCollection)
            .where('challenger', isEqualTo: widget.userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CustomIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              DateTime date = DateTime.parse(doc['startDate']); // Assuming 'startDate' is a string
              String formattedDate = DateFormat('EEEE, yyyy/MM/dd').format(date); // You can adjust the format
              return Container(
                margin: EdgeInsets.all(5),
                child: CustomSlider(
                  isTeamScreen: false,
                  deleteOnPressed: (context){
                    controller.deleteChallenge(context: context, challengeId: doc.id);
                  },
                  editOnPressed: (context){
                    controller.showEditDialog(context: context, challengeId: doc.id, teamName: doc['challengerTeamName'], leaderName: doc['teamLeaderName'], leaderPhone: doc['challengerLeaderPhone'], location:  doc['location']);
                  },
                  child: ChallengeCard(
                    startDate: formattedDate,
                    imagePath: doc['imagePath'],
                      challengerTeamName: doc['challengerTeamName'],
                      teamLeaderName: doc['teamLeaderName'],
                      challengerLeaderPhone: doc['challengerLeaderPhone'],
                      location: doc['location'],
                      matchOvers: doc['Overs'],
                      teamCount: doc['teamCount'],
                      userId: widget.userId,
                      challengerId: doc['challenger'],
                      isChallengeAccepted: doc['isChallengeAccepted'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewMyChallenges(doc.id, widget.userId, doc['isChallengeAccepted'])),
                        );
                      }),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
