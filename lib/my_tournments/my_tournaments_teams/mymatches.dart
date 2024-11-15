import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import '../../controllers/add_team_tournament_controller.dart';
import '../../controllers/token_update_controller.dart';
import '../../models_classes.dart';
import '../../reusbale_widget/tournment-card.dart';
import 'ma_matcehs_team_screen.dart';


class MyTournamentsTeams extends StatefulWidget {
  final String userId;
  MyTournamentsTeams({required this.userId});

  @override
  State<MyTournamentsTeams> createState() => _MyTournamentsTeamsState();
}

class _MyTournamentsTeamsState extends State<MyTournamentsTeams> {

  var controller = Get.put(AddTeamTournamentController());
  var tokenController = Get.put(TokenUpdateController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenController.updateTokenForUserTournamentTeam();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(stream: fireStore.collection(teamsCollection).where('userId', isEqualTo: widget.userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CustomIndicator(),
            );
          }
          final List<String> tournamentIds = snapshot.data!.docs.map((doc) => doc['tournamentId'] as String).toList();
          return FutureBuilder<List<Tournament>>(
            future: _fetchTournaments(tournamentIds),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CustomIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              final List<Tournament> myTournaments = snapshot.data ?? [];
              return ListView.builder(
                itemCount: myTournaments.length,
                itemBuilder: (context, index) {
                  DateTime date = DateTime.parse(myTournaments[index].tournmentStartDate,);
                  String formattedDate = DateFormat('EEEE, yyyy/MM/dd').format(date);
                  return Container(
                    margin:const  EdgeInsets.all(5),
                    child: TournamentCard(
                      imagePath: myTournaments[index].imagePath ,
                      totalTeams:myTournaments[index].totalTeam ,
                      registerTeams: myTournaments[index].registerTeams,
                      userId: widget.userId,
                      organizerId:myTournaments[index].organizerId,
                      tournamentName: myTournaments[index].name,
                      organizerName: myTournaments[index].organizerName,
                      organizerPhoneNumber: myTournaments[index].organizerPhoneNumber,
                      tournamentOvers: myTournaments[index].tournamentOvers,
                      tournamentFee: myTournaments[index].tournamentFee,
                      location: myTournaments[index].location,
                      isCompleted: myTournaments[index].isCompleted,
                      startDate:formattedDate,
                      onTap: (){
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => MyMatchesTeamScreen(tournamentId: myTournaments[index].id,userId:widget.userId,isHomeScreen: false,),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Tournament>> _fetchTournaments(List<String> tournamentIds) async {
    final List<Tournament> tournaments = [];
    for (final id in tournamentIds) {
      final DocumentSnapshot tournamentSnapshot = await fireStore.collection(tournamentsCollection).doc(id).get();
      if (tournamentSnapshot.exists) {
        final tournament = Tournament(
          token:tournamentSnapshot['token'] ?? '--/--/-',
          id: tournamentSnapshot.id,
          name: tournamentSnapshot['name'] ?? '--/--/-',
          organizerName:tournamentSnapshot['organizerName'] ?? '--/--/-',
          organizerPhoneNumber: tournamentSnapshot['organizerPhoneNumber'] ?? '--/--/-',
          tournamentFee: tournamentSnapshot['tournamentFee'] ?? '--/--/-',
          tournamentOvers: tournamentSnapshot['tournamentOvers'] ?? '--/--/-',
          location: tournamentSnapshot['location'] ?? '--/--/-',
          isCompleted:tournamentSnapshot['isCompleted'] ?? '--/--/-',
          tournmentStartDate: tournamentSnapshot['startDate'] ?? '--/--/-',
          organizerId: tournamentSnapshot['organizer_UserID'] ?? '--/--/-',
          totalTeam: tournamentSnapshot['totalTeams'] ?? '--/--/-',
          registerTeams: tournamentSnapshot['registerTeams'] ?? '--/--/-',
          imagePath: tournamentSnapshot['imagePath'] ?? '--/--/-',
        );
        tournaments.add(tournament);
      }
    }

    return tournaments;
  }
}
