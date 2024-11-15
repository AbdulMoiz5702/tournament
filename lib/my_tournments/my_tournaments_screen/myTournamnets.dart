import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/my_tournments/my_tournaments_screen/tournament_update_screen.dart';
import 'package:tournemnt/my_tournments/my_tournaments_screen/view_my_tournaments.dart';
import 'package:tournemnt/reusbale_widget/Custom_slider.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';
import '../../controllers/Add_tournamnets_contoller.dart';
import '../../controllers/token_update_controller.dart';
import '../../models_classes.dart';
import '../../reusbale_widget/tournment-card.dart';


class MyTournamentsScreen extends StatefulWidget {
  final String userId ;
  const MyTournamentsScreen({super.key, required this.userId});

  @override
  State<MyTournamentsScreen> createState() => _MyTournamentsScreenState();
}

class _MyTournamentsScreenState extends State<MyTournamentsScreen>  with WidgetsBindingObserver{

  var controller = Get.put(AddTournamentsController());
  var tokenController = Get.put(TokenUpdateController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokenController.updateTokenForUserTournaments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStore.collection(tournamentsCollection).where('organizer_UserID', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
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
          final List<Tournament> myTournaments = snapshot.data!.docs.map((doc) {
            return Tournament(
              id: doc.id,
              token:doc['token'] ?? '--/--/-',
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
              imagePath:doc['imagePath'] ?? '--/--/-',
            );
          }).toList();
          return ListView.builder(
            cacheExtent: 0,
            itemCount: myTournaments.length,
            itemBuilder: (context, index) {
              DateTime date = DateTime.parse(myTournaments[index].tournmentStartDate); // Assuming 'startDate' is a string
              String formattedDate = DateFormat('EEEE, yyyy/MM/dd').format(date); // You can adjust the format
              return CustomSlider(
                deleteOnPressed: (context) async {
                  await  fireStore.collection(tournamentsCollection).doc(myTournaments[index].id).delete().onError((error, stackTrace){
                    throw ToastClass.showToastClass(context: context, message: ' Something went wrong');
                  }).timeout(Duration(seconds: 5),onTimeout: (){
                    return  ToastClass.showToastClass(context: context, message: 'Request Time Out');
                  });
                },
                editOnPressed: (context){
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => UpdateTournamentPage(
                        tournament: myTournaments[index],
                      ),
                    ),
                  );
                },
                child: TournamentCard(
                  imagePath: myTournaments[index].imagePath ,
                  totalTeams:myTournaments[index].totalTeam ,
                  registerTeams: myTournaments[index].registerTeams,
                  userId: widget.userId,
                  organizerId: myTournaments[index].organizerId,
                  tournamentName: myTournaments[index].name,
                  organizerName: myTournaments[index].organizerName,
                  organizerPhoneNumber: myTournaments[index].organizerPhoneNumber,
                  tournamentOvers: myTournaments[index].tournamentOvers,
                  tournamentFee: myTournaments[index].tournamentFee,
                  location: myTournaments[index].location,
                  isCompleted: myTournaments[index].isCompleted,
                  startDate: formattedDate,
                  onTap: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ViewMyTournamentsTeams(tournamentId: myTournaments[index].id,userId:widget.userId,isHomeScreen:false,isCompleted:myTournaments[index].isCompleted,registerTeams: myTournaments[index].registerTeams,token: myTournaments[index].token,),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}