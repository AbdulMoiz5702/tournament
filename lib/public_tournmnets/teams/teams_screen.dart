import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tournemnt/reusbale_widget/Custom_slider.dart';
import 'package:tournemnt/reusbale_widget/customLeading.dart';
import 'package:tournemnt/reusbale_widget/custom_floating_action.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';

import '../../models_classes.dart';
import '../../reusbale_widget/team_card.dart';
import 'add-teams.dart';

class TeamListPage extends StatefulWidget {
  final String tournamentId;
  final String isCompleted;
  final String userId;
  final bool isHomeScreen ;
  final int registerTeams ;
  final int totalTeam ;
  TeamListPage({required this.tournamentId,required this.userId,required this.isHomeScreen,required this.isCompleted,required this.registerTeams,required this.totalTeam});

  @override
  State<TeamListPage> createState() => _TeamListPageState();
}

class _TeamListPageState extends State<TeamListPage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: largeText(title: 'All Teams',context: context),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Teams').where('tournamentId', isEqualTo: widget.tournamentId).snapshots(),
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
          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              return TeamCard(
                roundsQualify: teams[index].roundsQualify,
                imagePath:teams[index].imageLink,
                userId: widget.userId,
                teamId:teams[index].teamId,
                onTap: (){},
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
      floatingActionButton: widget.isCompleted == 'true' || widget.registerTeams == widget.totalTeam ? Container(height: 1,width: 1,):CustomFloatingAction(onTap: (){
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => AddTeamPage(tournamentId: widget.tournamentId,userId: widget.userId,registerTeams: widget.registerTeams,),
          ),
        );
      }),
    );
  }
}