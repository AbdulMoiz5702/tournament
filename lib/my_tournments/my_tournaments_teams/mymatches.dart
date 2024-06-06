import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models_classes.dart';
import '../../reusbale_widget/tournment-card.dart';
import 'ma_matcehs_team_screen.dart';


class MyTournamentsTeams extends StatelessWidget {
  final String userId;
  MyTournamentsTeams({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Teams')
            .where('userId', isEqualTo: userId)
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

          final List<String> tournamentIds = snapshot.data!.docs
              .map((doc) => doc['tournamentId'] as String)
              .toList();

          return FutureBuilder<List<Tournament>>(
            future: _fetchTournaments(tournamentIds),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
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
                  String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                  return Container(
                    margin:const  EdgeInsets.all(5),
                    child: TournamentCard(
                      imagePath: myTournaments[index].imagePath ,
                      totalTeams:myTournaments[index].totalTeam ,
                      registerTeams: myTournaments[index].registerTeams,
                      userId: userId,
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
                            builder: (context) => MyMatchesTeamScreen(tournamentId: myTournaments[index].id,userId:userId,isHomeScreen: false,),
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
      final DocumentSnapshot tournamentSnapshot = await FirebaseFirestore.instance
          .collection('Tournaments')
          .doc(id)
          .get();

      if (tournamentSnapshot.exists) {
        final tournament = Tournament(
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
