import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/controllers/token_update_controller.dart';
import 'package:tournemnt/my_1v1_challenges/view_my_challenges.dart';
import 'package:tournemnt/reusbale_widget/Custom_slider.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/challenge_card.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import '../challenges_details/challenges_details_screen.dart';
import '../chat_screens/messages.dart';
import '../controllers/User_Challenges_controller.dart';
import '../reusbale_widget/customLeading.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';
import 'challenge_update_screen.dart';

class UserChallengesScreen extends StatefulWidget {
  final String userId;
  final bool isProfileScreen ;
  const UserChallengesScreen({super.key,required this.userId,this.isProfileScreen = false});

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
    return widget.isProfileScreen == true ? BgWidget(
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
                        title: 'My Challenges',
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
                  String formattedDate = DateFormat('dd MMM yyyy').format(date);
                  return CustomSlider(
                    isTeamScreen: false,
                    deleteOnPressed: (context){
                      controller.deleteChallenge(context: context, challengeId: doc.id);
                    },
                    editOnPressed: (context){
                      Get.to(()=> UpdateChallengePage(challenge: doc,));
                    //  controller.showEditDialog(context: context, challengeId: doc.id, teamName: doc['challengerTeamName'], leaderName: doc['teamLeaderName'], leaderPhone: doc['challengerLeaderPhone'], location:  doc['location']);
                    },
                    child: ChallengeCard(
                        age: doc['age'],
                        area: doc['area'],
                        startTime:  doc['startTime'],
                        seeDetails: (){
                          Get.to(()=> ChallengesDetailsScreen(data: doc,));
                        },
                        onMessage: (){
                          Get.to(()=> MessageScreen(receiverId: doc['challenger'],receiverName: doc['teamLeaderName'],receiverToken: doc['token'],userId:currentUser!.uid,));
                        },
                        startDate: formattedDate,
                        imagePath: doc['imagePath'],
                        challengerTeamName: doc['challengerTeamName'],
                        teamLeaderName: doc['teamLeaderName'],
                        challengerLeaderPhone: doc['challengerLeaderPhone'],
                        location: doc['location'],
                        matchOvers: doc['Over'],
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
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    ) : StreamBuilder(
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
            String formattedDate = DateFormat('dd MMM yyyy').format(date);
            return CustomSlider(
              isTeamScreen: false,
              deleteOnPressed: (context){
                controller.deleteChallenge(context: context, challengeId: doc.id);
              },
              editOnPressed: (context){
                Get.to(()=>UpdateChallengePage(challenge: doc));
              },
              child: ChallengeCard(
                  age: doc['age'],
                  area: doc['area'],
                  startTime:  doc['startTime'],
                  seeDetails: (){
                    Get.to(()=> ChallengesDetailsScreen(data: doc,));
                  },
                  onMessage: (){
                    Get.to(()=> MessageScreen(receiverId: doc['challenger'],receiverName: doc['teamLeaderName'],receiverToken: doc['token'],userId:currentUser!.uid,));
                  },
                  startDate: formattedDate,
                  imagePath: doc['imagePath'],
                  challengerTeamName: doc['challengerTeamName'],
                  teamLeaderName: doc['teamLeaderName'],
                  challengerLeaderPhone: doc['challengerLeaderPhone'],
                  location: doc['location'],
                  matchOvers: doc['Over'],
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
            );
          }).toList(),
        );
      },
    );
  }
}
