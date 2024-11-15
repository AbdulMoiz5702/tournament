import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/controllers/tournamnet_team_controller.dart';
import 'package:tournemnt/reusbale_widget/custom_floating_action.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import '../../models_classes.dart';
import '../../reusbale_widget/team_card.dart';
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            controller.userTeamExists.value = false;
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: false,
        title: largeText(title: 'All Teams', context: context),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<Team> teams = snapshot.data!.docs.map((doc) {
            return Team(
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
            );
          }).toList();

          // Update the observable outside the widget tree
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.userTeamExists.value =
                teams.any((team) => team.teamId == userId);
          });

          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              return TeamCard(
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
