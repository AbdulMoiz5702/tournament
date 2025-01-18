import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/public_tournmnets/teams/teams_screen.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/tournaments_detail_screen/tournamnet_detail_screen.dart';
import '../chat_screens/messages.dart';
import '../models_classes.dart';
import '../reusbale_widget/custom_floating_action.dart';
import '../reusbale_widget/tournment-card.dart';
import 'add_tournments.dart';


class TournamentListPage extends StatelessWidget {
  final String userId ;
  const TournamentListPage({super.key, required this.userId});
  @override
  Widget build(BuildContext context) {
    return BgWidget(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.sizeOf(context).height * 0.12,
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              smallText(title: 'Explore',color: whiteColor.withOpacity(0.85),fontSize: 14),
              Sized(height: 0.005,),
              largeText(title: 'Tournaments',context: context,fontWeight: FontWeight.w500,color: whiteColor),
              Sized(height: 0.01,),
              smallText(title: 'Here Below the list of Tournaments',color: secondaryTextColor.withOpacity(0.85),fontWeight: FontWeight.w500),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: fireStore.collection(tournamentsCollection).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child:CustomIndicator(height: 0.1,width: 0.2,),
              );
            }
            final List<Tournament> tournaments = snapshot.data!.docs.map((doc) {
              return Tournament(
                token:doc['token'] ?? '--/--/-',
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
                rules: doc['rules'] ?? '--/--/-',
                startTime: doc['startTime'] ?? '--/--/-',
                totalPlayers: doc['totalPlayers'] ?? '--/--/-',
              );
            }).toList();
            return Container(
              color: whiteColor,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal:15),
                cacheExtent: 0,
                itemCount: tournaments.length,
                itemBuilder: (context, index) {
                  DateTime date = DateTime.parse(tournaments[index].tournmentStartDate,);
                  String formattedDate = DateFormat('dd MMM yyyy').format(date);
                  var data = tournaments[index];
                  return TournamentCard(
                    startTime: tournaments[index].startTime,
                    viewTeams: (){

                    },
                    seeDetails: (){
                      Get.to(()=> TournamentDetailScreen(data: data,));
                    },
                    onMessage: (){
                      Get.to(()=> MessageScreen(receiverId: tournaments[index].organizerId,receiverName: tournaments[index].organizerName,receiverToken: tournaments[index].token,userId:userId,));
                    },
                    imagePath: tournaments[index].imagePath ,
                    totalTeams:tournaments[index].totalTeam,
                    registerTeams: tournaments[index].registerTeams,
                    userId: userId,
                    organizerId:tournaments[index].organizerId,
                    tournamentName: tournaments[index].name,
                    organizerName: tournaments[index].organizerName,
                    organizerPhoneNumber: tournaments[index].organizerPhoneNumber,
                    tournamentFee: tournaments[index].tournamentFee,
                    location: tournaments[index].location,
                    isCompleted: tournaments[index].isCompleted,
                    startDate:formattedDate,
                    onTap: (){
                      Get.to(()=> TeamListPage(tournamentId: tournaments[index].id,userId: userId,isHomeScreen: true,isCompleted: tournaments[index].isCompleted,registerTeams:tournaments[index].registerTeams,totalTeam: tournaments[index].totalTeam,token: tournaments[index].token,),);
                    },
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: CustomFloatingAction(onTap: (){
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => AddTournamentPage(userId: userId,),
            ),
          );
        },),
      ),
    );
  }
}