// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/reusbale_widget/Custom_slider.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_floating_action.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/services/notification_sevices.dart';
import '../../controllers/my_tournamnets_teams.dart';
import '../../models_classes.dart';
import '../../public_tournmnets/teams/add-teams.dart';
import '../../reusbale_widget/team_card.dart';


class ViewMyTournamentsTeams extends StatelessWidget {
  final String tournamentId;
  final String userId;
  final bool isHomeScreen ;
  final String isCompleted ;
  final int registerTeams ;
  final String token ;
  ViewMyTournamentsTeams({required this.tournamentId,required this.userId,required this.isHomeScreen,required this.isCompleted,required this.registerTeams,required this.token});

  @override
  Widget build(BuildContext context) {
    NotificationServices notificationServices = NotificationServices();
    var controller = Get.put(MyTournamentsTeamsController());
    return Scaffold(
      bottomNavigationBar: Obx(()=> Container(
        margin:const EdgeInsets.all(10),
        child: controller.isLoading.value == true ? const Center(child: CustomIndicator(),) : isCompleted == 'false' ? CustomButton(title: 'Start Tournament', onTap: (){
          controller.startTournament(tournamentStatus:'true',tournamentId: tournamentId,context: context);
          notificationServices.sendNotificationToAllUsers(
              'Tournament Started! 🏆',
              'The competition is on! Good luck and give it your best! 🔥',
            teamsCollection
          );
        }) : CustomButton(title: 'Open Registrations', onTap: (){
          controller.startTournament(tournamentStatus:'false',tournamentId: tournamentId,context: context);
    notificationServices.sendNotificationToAllUsers(
        'Registration Now Open! 📝',
        'Join the tournament and secure your spot! Don’t miss out! 🎉',
    teamsCollection
    );
        }) ,
      ),),
      appBar: AppBar(
        centerTitle: false,
        title: largeText(title: 'My Tournament',context: context),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStore.collection(teamsCollection).where('tournamentId', isEqualTo:tournamentId).snapshots(),
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
                isHomeScreen: isHomeScreen,
                deleteOnPressed: (context){
                  controller.confirmDeleteTeam(context: context,teamId: teams[index].id,tournamentId: tournamentId,registerTeams: registerTeams);
                  notificationServices.sendNotificationToSingleUser(token, '🚫 Tournament Exit', 'Don\'t give up! There are more tournaments to come. 💪 Keep practicing!');

                },
                editOnPressed: (context){
                  controller.confirmUpdate(context: context, teamId: teams[index].id, message: 'Qualify',teamStatus: 'win');
                  notificationServices.sendNotificationToSingleUser(token, '🎉 You Qualified!', 'Amazing progress! Keep going strong and make it all the way! 🎯');
                },
                editOnPressedTeamScreen: (context){
                  controller.confirmUpdate(context: context, teamId: teams[index].id, message: 'Disqualify',teamStatus: 'lose');
                  notificationServices.sendNotificationToSingleUser(token, '😞 Tough Luck!', 'Every setback is a setup for a comeback! 🌟 Keep pushing forward!');
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: TeamCard(
                    roundsQualify: teams[index].roundsQualify,
                    imagePath:teams[index].imageLink,
                    userId: userId,
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
            builder: (context) => AddTeamPage(tournamentId: tournamentId,userId: userId,registerTeams: registerTeams,token: token,),
          ),
        );
      }),
    );
  }
}