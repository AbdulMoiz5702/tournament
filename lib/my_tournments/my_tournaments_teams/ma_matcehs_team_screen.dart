import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/reusbale_widget/Custom_slider.dart';
import 'package:tournemnt/reusbale_widget/customLeading.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import '../../../models_classes.dart';
import '../../../reusbale_widget/team_card.dart';
import '../../controllers/my_matches_team_controller.dart';
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
    return Scaffold(
      appBar: AppBar(
        leading: CustomLeading(),
        title: largeText(title: 'All Teams', context: context),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              return CustomSlider(
                isTeamScreen: false,
                isHomeScreen: widget.isHomeScreen,
                deleteOnPressed: (context) {
                  widget.userId == teams[index].teamId
                      ? controller.confirmDeleteTeam(context: context,teamId: teams[index].id)
                      : ToastClass.showToastClass(
                          context: context,
                          message: 'You are not allowed to modify other teams');
                },
                editOnPressed: (context) {
                  widget.userId == teams[index].teamId
                      ? controller.showEditDialog(context: context,team: teams[index])
                      : ToastClass.showToastClass(context: context, message: 'You are not allowed to modify other teams');
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
              );
            },
          );
        },
      ),
    );
  }
}
