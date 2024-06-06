// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/reusbale_widget/Custom_slider.dart';
import 'package:tournemnt/reusbale_widget/customLeading.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_floating_action.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';
import '../../models_classes.dart';
import '../../public_tournmnets/teams/add-teams.dart';
import '../../reusbale_widget/team_card.dart';


class ViewMyTournamentsTeams extends StatefulWidget {
  final String tournamentId;
  final String userId;
  final bool isHomeScreen ;
  final String isCompleted ;
  final int registerTeams ;
  ViewMyTournamentsTeams({required this.tournamentId,required this.userId,required this.isHomeScreen,required this.isCompleted,required this.registerTeams});

  @override
  State<ViewMyTournamentsTeams> createState() => _ViewMyTournamentsTeamsState();
}

class _ViewMyTournamentsTeamsState extends State<ViewMyTournamentsTeams> {

  bool isLoading = false ;
  int roundNumber = 0;

  void _deleteTeam(BuildContext context, String teamId) async {
    await FirebaseFirestore.instance.collection('Teams').doc(teamId).delete().then((value) async{
      await FirebaseFirestore.instance
          .collection('Tournaments')
          .doc(widget.tournamentId)
          .update({
        'registerTeams': widget.registerTeams -1,
      });
    }).timeout(const Duration(seconds: 5),onTimeout: (){
      throw ToastClass.showToastClass(context: context, message: 'Request Time Out');
    });
  }

  void _updateTeamStatus(String teamId, String updatedTeamStatus,String roundNUmber) async {
    await FirebaseFirestore.instance.collection('Teams').doc(teamId).update({
      'teamResult': updatedTeamStatus,
      'roundsQualify':roundNUmber,
    }).then((value){
      throw ToastClass.showToastClass(context: context, message: 'Team Status Updated');
    }).timeout(const Duration(seconds: 5),onTimeout: (){
      throw ToastClass.showToastClass(context: context, message: 'Request Time Out');
    }).onError((error, stackTrace) {
      print(error.toString());
      throw ToastClass.showToastClass(context: context, message: 'Something went wrong');
    });
  }

   _confirmUpdate(BuildContext context, String teamId, String message, String teamStatus) {
    int selectedRound = roundNumber; // To keep track of the selected round
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Sized(height: 0.01,),
              mediumText(title : 'Confirm $message',context: context),
              Sized(height: 0.01,),
              smallText(title: 'Are you sure you want to $message this team?',context: context),
              Sized(height: 0.01,),
              smallText(title: 'Select Round Number',context: context),
              Sized(height: 0.02,),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.1,
                child: CupertinoPicker(
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    selectedRound = index + 1; // Assuming rounds start from 1
                  },
                  children: List<Widget>.generate(20, (int index) {
                    return Center(
                      child: Text('Round ${index + 1}'),
                    );
                  }),
                ),
              ),
              Sized(height: 0.01,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child:const  Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _updateTeamStatus(teamId, teamStatus, 'This Team $message in Round $selectedRound');
                    },
                    child: const Text('Confirm Round'),
                  ),
                ],
              ),
              Sized(height: 0.01,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CustomButton(
                      width: 0.35,
                        title: 'Quarter Final', onTap: (){
                      Navigator.of(context).pop();
                      _updateTeamStatus(teamId, teamStatus, 'This Team $message in  Quarter Final');
                    }),
                    Sized(width: 0.03,),
                    CustomButton(
                        width: 0.35,
                        title: 'Semi Final', onTap: (){
                      Navigator.of(context).pop();
                      _updateTeamStatus(teamId, teamStatus, 'This Team $message in  Semi Final');
                    }),
                    Sized(width: 0.03,),
                    CustomButton(
                        width: 0.35,
                        title: 'Final', onTap: (){
                      Navigator.of(context).pop();
                      _updateTeamStatus(teamId, teamStatus, 'This Team $message in  Final');
                    }),
                  ],
                ),
              ),
              Sized(height: 0.01,),
            ],
          ),
        );
      },
    );
  }




  void startTournament({required String tournamentStatus}) async {
    try{
      isLoading = true ;
      setState(() {});
      await FirebaseFirestore.instance
          .collection('Tournaments')
          .doc(widget.tournamentId)
          .update({
        'isCompleted': tournamentStatus,
      }).timeout(const Duration(seconds: 5),onTimeout: (){
        isLoading = false ;
        ToastClass.showToastClass(context: context, message: "request time out");
        setState(() {});
      }).then((value){
        isLoading = false ;
        ToastClass.showToastClass(context: context, message: "Tournament started!");
        setState(() {});
      });
    }catch(e){
      isLoading = false ;
      ToastClass.showToastClass(context: context, message: "something went wrong");
      setState(() {});
    }
  }


  void _confirmDeleteTeam(BuildContext context, String teamId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this team?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => _deleteTeam(context, teamId),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin:const EdgeInsets.all(10),
        child: isLoading == true ? const Center(child: CircularProgressIndicator(),) : widget.isCompleted == 'false' ? CustomButton(title: 'Start Tournament', onTap: (){
          startTournament(tournamentStatus:'true');
        }) : CustomButton(title: 'Open Registrations', onTap: (){
          startTournament(tournamentStatus:'false');
        }) ,
      ),
      appBar: AppBar(
        centerTitle: false,
        title: largeText(title: 'My Tournament',context: context),
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
            return const Center(
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
              return CustomSlider(
                isTeamScreen: true,
                isHomeScreen: widget.isHomeScreen,
                deleteOnPressed: (context){
                  _confirmDeleteTeam(context, teams[index].id);
                },
                editOnPressed: (context){
                  _confirmUpdate(context, teams[index].id,'Qualify', 'win');
                },
                editOnPressedTeamScreen: (context){
                  _confirmUpdate(context, teams[index].id,'Disqualify', 'lose');
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: TeamCard(
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
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: CustomFloatingAction(onTap: (){
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