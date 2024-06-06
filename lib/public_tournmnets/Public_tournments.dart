import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/public_tournmnets/teams/teams_screen.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import '../models_classes.dart';
import '../reusbale_widget/custom_floating_action.dart';
import '../reusbale_widget/tournment-card.dart';
import 'add_tournments.dart';


class TournamentListPage extends StatefulWidget {
  final String userId ;
  TournamentListPage({required this.userId});
  @override
  State<TournamentListPage> createState() => _TournamentListPageState();
}

class _TournamentListPageState extends State<TournamentListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: largeText(title: 'Tournaments',context: context,fontWeight: FontWeight.w200,color: secondaryTextColor),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Tournaments').snapshots(),
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
          final List<Tournament> tournaments = snapshot.data!.docs.map((doc) {
            return Tournament(
              id: doc.id,
              name: doc['name'] ?? '--/--/-',
              organizerName:doc['organizerName'] ?? '--/--/-',
              organizerPhoneNumber: doc['organizerPhoneNumber'] ?? '--/--/-',
              tournamentFee: doc['tournamentFee'] ?? '--/--/-',
              tournamentOvers: doc['tournamentOvers'] ?? '--/--/-',
              location: doc['location'] ?? '--/--/-',
              isCompleted:doc['isCompleted'] ?? '--/--/-',
              tournmentStartDate: doc['startDate'] ?? '--/--/-',
              organizerId: doc['organizer_UserID'] ?? '--/--/-',
              totalTeam: doc['totalTeams'] ?? '--/--/-',
              registerTeams: doc['registerTeams'] ?? '--/--/-',
              imagePath: doc['imagePath'] ?? '--/--/-',
            );
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal:8),
            cacheExtent: 0,
            itemCount: tournaments.length,
            itemBuilder: (context, index) {
              DateTime date = DateTime.parse(tournaments[index].tournmentStartDate,);
              String formattedDate = DateFormat('yyyy-MM-dd').format(date);
              return TournamentCard(
                imagePath: tournaments[index].imagePath ,
                totalTeams:tournaments[index].totalTeam ,
                registerTeams: tournaments[index].registerTeams,
                userId: widget.userId,
                organizerId:tournaments[index].organizerId,
                tournamentName: tournaments[index].name,
                organizerName: tournaments[index].organizerName,
                organizerPhoneNumber: tournaments[index].organizerPhoneNumber,
                tournamentOvers: tournaments[index].tournamentOvers,
                tournamentFee: tournaments[index].tournamentFee,
                location: tournaments[index].location,
                isCompleted: tournaments[index].isCompleted,
                startDate:formattedDate,
                onTap: (){
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => TeamListPage(tournamentId: tournaments[index].id,userId: widget.userId,isHomeScreen: true,isCompleted: tournaments[index].isCompleted,registerTeams:tournaments[index].registerTeams,totalTeam: tournaments[index].totalTeam,),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: CustomFloatingAction(onTap: (){
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => AddTournamentPage(userId: widget.userId,),
          ),
        );
      },),
    );
  }
}