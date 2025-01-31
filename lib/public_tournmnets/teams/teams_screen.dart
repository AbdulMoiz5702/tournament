import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/controllers/tournamnet_team_controller.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/custom_floating_action.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import '../../chat_screens/messages.dart';
import '../../consts/colors.dart';
import '../../models_classes.dart';
import '../../reusbale_widget/custom_sizedBox.dart';
import '../../reusbale_widget/team_card.dart';
import '../view_team_match_schedule.dart';
import 'add-teams.dart';

class TeamListPage extends StatelessWidget {
  final String tournamentId;
  final String isCompleted;
  final String userId;
  final bool isHomeScreen;
  final int registerTeams;
  final int totalTeam;
  final String token;

  TeamListPage({
    required this.tournamentId,
    required this.userId,
    required this.isHomeScreen,
    required this.isCompleted,
    required this.registerTeams,
    required this.totalTeam,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TournamentTeamController());
    return BgWidget(
      child: Scaffold(
        backgroundColor: transparentColor,
        appBar: AppBar(
          backgroundColor:transparentColor,
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
              controller.userTeamExists.value = false;
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:transparentColor,
                  border: Border.all(color: buttonColor)
              ),
              child: Icon(Icons.arrow_back,color: whiteColor,size: 18,),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 80),
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
                      Row(
                        children: [
                          largeText(
                            fontSize: 24,
                            title: 'Registered Teams info',
                            context: context,
                            fontWeight: FontWeight.w500,
                            color: whiteColor,
                          ),
                          IconButton(onPressed: (){
                            Get.to(()=> ViewTeamMatchSchedule(tournamentId: tournamentId));
                          }, icon:const  Icon(Icons.pending_actions_outlined,color: whiteColor,),),
                        ],
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
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(teamsCollection)
                .where('tournamentId', isEqualTo: tournamentId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final List<Team> teams = snapshot.data!.docs.map((doc) {
                return Team(
                  vs: doc['vs'],
                  id: doc.id,
                  name: doc['name'] ?? '--/--/-',
                  tournamentId: doc['tournamentId'] ?? '--/--/-',
                  teamLeaderName: doc['teamLeader'] ?? '--/--/-',
                  teamLeaderPhoneNumber: doc['teamLeaderNumber'] ?? '--/--/-',
                  teamResult: doc['teamResult'] ?? '--/--/-',
                  teamLocation: doc['teamLocation'] ?? '--/--/-',
                  teamId: doc['userId'] ?? '--/--/-',
                  imageLink: doc['imageLink'] ?? '--/--/-',
                  roundsQualify: doc['roundsQualify'] ?? '--/--/-',
                  token: doc['token'] ?? '--/--/-',
                );
              }).toList();

              // Update the observable outside the widget tree
              WidgetsBinding.instance.addPostFrameCallback((_) {controller.userTeamExists.value = teams.any((team) => team.teamId == userId);});

              return ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  return TeamCard(
                    vs: teams[index].vs,
                    onMessage: (){
                      Get.to(()=> MessageScreen(receiverId:userId ,receiverName: teams[index].teamLeaderName,receiverToken: teams[index].token,userId:userId,));
                    },
                    roundsQualify: teams[index].roundsQualify,
                    imagePath: teams[index].imageLink,
                    userId: userId,
                    teamId: teams[index].teamId,
                    onTap: () {},
                    teamName: teams[index].name,
                    leaderName: teams[index].teamLeaderName,
                    leaderPhone: teams[index].teamLeaderPhoneNumber,
                    location: teams[index].teamLocation,
                    teamResult: teams[index].teamResult,
                  );
                },
              );
            },
          ),
        ),
        floatingActionButton: isCompleted == 'true' || registerTeams == totalTeam
            ? Container(height: 1, width: 1)
            : Obx(
              () => controller.userTeamExists.value
              ? Container(height: 1, width: 1)
              : CustomFloatingAction(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => AddTeamPage(
                    tournamentId: tournamentId,
                    userId: userId,
                    registerTeams: registerTeams,
                    token: token,
                    isCompleted: isCompleted,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
