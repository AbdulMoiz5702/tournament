// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/reusbale_widget/Custom_slider.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import '../chat_screens/messages.dart';
import '../consts/colors.dart';
import '../controllers/My_Accepted_Challenges_controller.dart';
import '../reusbale_widget/accepter_card.dart';
import '../reusbale_widget/customLeading.dart';



class MyAcceptedChallenges extends StatelessWidget {
  final String challengeId;
  final String userId;
  final String isChallengeAccepted ;
  MyAcceptedChallenges(this.challengeId,this.userId,this.isChallengeAccepted);
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(MyAcceptedChallengesController());
    return BgWidget(
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
                        title: 'Challenge Details',
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
            stream: FirebaseFirestore.instance.collection(challengesCollection).doc(challengeId).snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var challengeData = snapshot.data?.data() as Map<String, dynamic>?;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    child: AccepterCard(
                      onMessage: (){
                        Get.to(()=> MessageScreen(receiverId: challengeData!['challenger'],receiverName: challengeData['teamLeaderName'],receiverToken: challengeData['token'],userId:currentUser!.uid,));
                      },
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
                          child: CircularProgressIndicator(),
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
                                controller.showEditDialog(context: context, teamId:  doc.id, teamName: doc['teamName'], teamLeaderName: doc['teamLeaderName'], teamLeaderPhone: doc['teamLeaderPhone'], location: doc['location'], challengeId: challengeId);
                              },
                              child: AccepterCard(
                                onMessage: (){
                                  Get.to(()=> MessageScreen(receiverId: doc['accepterId'],receiverName: doc['teamLeaderName'],receiverToken: doc['token'],userId:currentUser!.uid,));
                                },
                                imagePath:doc['imageLink'],
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
        ),
      ),
    );
  }
}


