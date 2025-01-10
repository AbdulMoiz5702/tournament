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
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';
import '../../chat_screens/messages.dart';
import '../../consts/colors.dart';
import '../../controllers/Add_tournamnets_contoller.dart';
import '../../controllers/token_update_controller.dart';
import '../../models_classes.dart';
import '../../reusbale_widget/customLeading.dart';
import '../../reusbale_widget/custom_sizedBox.dart';
import '../../reusbale_widget/text_widgets.dart';
import '../../reusbale_widget/tournment-card.dart';
import '../../tournaments_detail_screen/tournamnet_detail_screen.dart';


class MyTournamentsScreen extends StatefulWidget {
  final String userId ;
  final bool isProfileScreen ;
  const MyTournamentsScreen({super.key, required this.userId,this.isProfileScreen = false});

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
    return widget.isProfileScreen == true ? BgWidget(
      child: Scaffold(
        backgroundColor: transparentColor,
        appBar: AppBar(
          leading: const CustomLeading(),
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
                        title: 'My Tournaments',
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
            child: StreamBuilder<QuerySnapshot>(
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
                    rules: doc['rules'] ?? '--/--/-',
                    startTime: doc['startTime'] ?? '--/--/-',
                    totalPlayers: doc['totalPlayers'] ?? '--/--/-',
                  );
                }).toList();
                return ListView.builder(
                  cacheExtent: 0,
                  itemCount: myTournaments.length,
                  itemBuilder: (context, index) {
                    DateTime date = DateTime.parse(myTournaments[index].tournmentStartDate,);
                    String formattedDate = DateFormat('dd MMM yyyy').format(date);
                    return CustomSlider(
                      deleteOnPressed: (context) async {
                        await  fireStore.collection(tournamentsCollection).doc(myTournaments[index].id).delete().onError((error, stackTrace){
                          throw ToastClass.showToastClass(context: context, message: ' Something went wrong');
                        }).timeout(const Duration(seconds: 5),onTimeout: (){
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
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
                          organizerId: myTournaments[index].organizerId,
                          tournamentName: myTournaments[index].name,
                          organizerName: myTournaments[index].organizerName,
                          organizerPhoneNumber: myTournaments[index].organizerPhoneNumber,
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
                      ),
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
      child: StreamBuilder<QuerySnapshot>(
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
              rules: doc['rules'] ?? '--/--/-',
              startTime: doc['startTime'] ?? '--/--/-',
              totalPlayers: doc['totalPlayers'] ?? '--/--/-',
            );
          }).toList();
          return ListView.builder(
            cacheExtent: 0,
            itemCount: myTournaments.length,
            itemBuilder: (context, index) {
              DateTime date = DateTime.parse(myTournaments[index].tournmentStartDate,);
              String formattedDate = DateFormat('dd MMM yyyy').format(date);
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
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
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
                    organizerId: myTournaments[index].organizerId,
                    tournamentName: myTournaments[index].name,
                    organizerName: myTournaments[index].organizerName,
                    organizerPhoneNumber: myTournaments[index].organizerPhoneNumber,
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}