// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/reusbale_widget/Custom_slider.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import '../controllers/View_My_Challenges_controller.dart';
import '../reusbale_widget/accepter_card.dart';



class ViewMyChallenges extends StatelessWidget {
  final String challengeId;
  final String userId;
  final String isChallengeAccepted ;
  ViewMyChallenges(this.challengeId,this.userId,this.isChallengeAccepted);
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ViewMyChallengesController());
    return Scaffold(
      appBar: AppBar(
        title: largeText(title: 'Challenge Details',context: context),
      ),
      body: StreamBuilder(
        stream: fireStore.collection(challengesCollection).doc(challengeId).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CustomIndicator(),
            );
          }
          var challengeData = snapshot.data?.data() as Map<String, dynamic>?;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(5),
                child: AccepterCard(
                  imagePath: '${challengeData?['imagePath'] ?? '---/--/-'}',
                  userId:userId,
                  accpterId: '${challengeData?['challenger'] ?? '---/--/-'}',
                  accepterTeamName:'${challengeData?['challengerTeamName'] ?? '---/--/-'}',
                  location: '${challengeData?['location'] ?? '---/--/-'}',
                  teamLeaderName: '${challengeData?['teamLeaderName'] ?? '---/--/-'}',
                  accepterLeaderPhone: '${challengeData?['challengerLeaderPhone'] ?? '---/--/-'}',
                  onTap: () {},
                ),
              ),
              Sized(height: 0.02,),
              mediumText(title: 'VS',context: context),
              Sized(height: 0.02,),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection(challengesCollection).doc(challengeId).collection(challengesTeamCollection).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const  Center(
                      child: CustomIndicator(),
                    );
                  }
                  return Column(
                    children: snapshot.data!.docs.map((doc) {
                      return Container(
                        margin: EdgeInsets.all(5),
                        child: CustomSlider(
                          isTeamScreen: false,
                          deleteOnPressed: (context){
                           controller.deleteTeam(context: context, teamId: doc.id, challengeId: challengeId);
                          },
                          editOnPressed: (context){
                            controller.showEditDialog(context: context, teamId: doc.id, teamName: doc['teamName'], teamLeaderName: doc['teamLeaderName'], teamLeaderPhone: doc['teamLeaderPhone'], location: doc['location'], challengeId: challengeId);
                          },
                          child: AccepterCard(
                            imagePath: doc['imageLink'],
                            userId: userId,
                            accpterId:doc['accepterId'],
                            accepterTeamName:doc['teamName'],
                            location: doc['location'],
                            teamLeaderName: doc['teamLeaderName'],
                            accepterLeaderPhone: doc['teamLeaderPhone'],
                            onTap: () {},
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}


