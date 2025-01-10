import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/reusbale_widget/Custom_slider.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/customLeading.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import '../../../models_classes.dart';
import '../../../reusbale_widget/team_card.dart';
import '../../consts/colors.dart';
import '../../controllers/my_matches_team_controller.dart';
import '../../reusbale_widget/custom_sizedBox.dart';
import '../../reusbale_widget/toast_class.dart';

class MyMatchesTeamScreen extends StatefulWidget {
  final String tournamentId;
  final String userId;
  final bool isHomeScreen;
  MyMatchesTeamScreen({required this.tournamentId, required this.userId, required this.isHomeScreen});
  @override
  State<MyMatchesTeamScreen> createState() => _MyMatchesTeamScreenState();
}

class _MyMatchesTeamScreenState extends State<MyMatchesTeamScreen> {
  var controller = Get.put(MyMatchesTeamController());
  @override
  Widget build(BuildContext context) {
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
                        title: 'Teams',
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
          child: StreamBuilder<QuerySnapshot>(
            stream: fireStore.collection(teamsCollection).where('tournamentId', isEqualTo: widget.tournamentId).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const  Center(
                  child: CustomIndicator(),
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
              return ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  return widget.userId == teams[index].teamId ?  CustomSlider(
                    isTeamScreen: false,
                    isHomeScreen: widget.isHomeScreen,
                    deleteOnPressed: (context) {
                      controller.confirmDeleteTeam(context: context,teamId: teams[index].id);
                    },
                    editOnPressed: (context) {
                      controller.showEditDialog(context: context,team: teams[index]);
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: TeamCard(
                        roundsQualify: teams[index].roundsQualify,
                        imagePath:teams[index].imageLink,
                        userId: widget.userId,
                        teamId: teams[index].teamId,
                        onTap: () {},
                        teamName: teams[index].name,
                        leaderName: teams[index].teamLeaderName,
                        leaderPhone: teams[index].teamLeaderPhoneNumber,
                        location: teams[index].teamLocation,
                        teamResult: teams[index].teamResult,
                      ),
                    ),
                  ) : Container(
                    margin: EdgeInsets.all(5),
                    child: TeamCard(
                      roundsQualify: teams[index].roundsQualify,
                      imagePath:teams[index].imageLink,
                      userId: widget.userId,
                      teamId: teams[index].teamId,
                      onTap: () {},
                      teamName: teams[index].name,
                      leaderName: teams[index].teamLeaderName,
                      leaderPhone: teams[index].teamLeaderPhoneNumber,
                      location: teams[index].teamLocation,
                      teamResult: teams[index].teamResult,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
