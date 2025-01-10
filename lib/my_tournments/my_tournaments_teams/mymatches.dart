import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import '../../chat_screens/messages.dart';
import '../../consts/colors.dart';
import '../../controllers/add_team_tournament_controller.dart';
import '../../controllers/token_update_controller.dart';
import '../../models_classes.dart';
import '../../reusbale_widget/customLeading.dart';
import '../../reusbale_widget/custom_sizedBox.dart';
import '../../reusbale_widget/text_widgets.dart';
import '../../reusbale_widget/tournment-card.dart';
import '../../tournaments_detail_screen/tournamnet_detail_screen.dart';
import 'ma_matcehs_team_screen.dart';


class MyTournamentsTeams extends StatefulWidget {
  final String userId;
  final bool isProfileScreen ;
  const MyTournamentsTeams({super.key,required this.userId,this.isProfileScreen = false});

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
                        title: 'My Teams',
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: StreamBuilder<QuerySnapshot>(stream: fireStore.collection(teamsCollection).where('userId', isEqualTo: widget.userId).snapshots(),
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
                        String formattedDate = DateFormat('dd MMM yyyy').format(date);
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: TournamentCard(
                            startTime: myTournaments[index].startTime,
                            seeDetails: (){
                              Get.to(()=> TournamentDetailScreen(data: myTournaments[index],));
                            },
                            onMessage: (){
                              Get.to(()=> MessageScreen(receiverId: myTournaments[index].organizerId,receiverName: myTournaments[index].organizerName,receiverToken: myTournaments[index].token,userId:currentUser!.uid,));
                            },
                            imagePath: myTournaments[index].imagePath ,
                            totalTeams:myTournaments[index].totalTeam ,
                            registerTeams: myTournaments[index].registerTeams,
                            userId: widget.userId,
                            organizerId:myTournaments[index].organizerId,
                            tournamentName: myTournaments[index].name,
                            organizerName: myTournaments[index].organizerName,
                            organizerPhoneNumber: myTournaments[index].organizerPhoneNumber,
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
          ),
        ),
      ),
    ) : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: StreamBuilder<QuerySnapshot>(stream: fireStore.collection(teamsCollection).where('userId', isEqualTo: widget.userId).snapshots(),
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
                  String formattedDate = DateFormat('dd MMM yyyy').format(date);
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: TournamentCard(
                      startTime: myTournaments[index].startTime,
                      seeDetails: (){
                        Get.to(()=> TournamentDetailScreen(data: myTournaments[index],));
                      },
                      onMessage: (){
                        Get.to(()=> MessageScreen(receiverId: myTournaments[index].organizerId,receiverName: myTournaments[index].organizerName,receiverToken: myTournaments[index].token,userId:currentUser!.uid,));
                      },
                      imagePath: myTournaments[index].imagePath ,
                      totalTeams:myTournaments[index].totalTeam ,
                      registerTeams: myTournaments[index].registerTeams,
                      userId: widget.userId,
                      organizerId:myTournaments[index].organizerId,
                      tournamentName: myTournaments[index].name,
                      organizerName: myTournaments[index].organizerName,
                      organizerPhoneNumber: myTournaments[index].organizerPhoneNumber,
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
          rules: tournamentSnapshot['rules'] ?? '--/--/-',
          startTime: tournamentSnapshot['startTime'] ?? '--/--/-',
          totalPlayers: tournamentSnapshot['totalPlayers'] ?? '--/--/-',
        );
        tournaments.add(tournament);
      }
    }

    return tournaments;
  }
}
