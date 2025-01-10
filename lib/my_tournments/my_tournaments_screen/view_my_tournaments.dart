// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/public_tournmnets/match_schedule.dart';
import 'package:tournemnt/reusbale_widget/Custom_slider.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_floating_action.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';
import 'package:tournemnt/services/notification_sevices.dart';
import '../../consts/colors.dart';
import '../../controllers/my_tournamnets_teams.dart';
import '../../models_classes.dart';
import '../../public_tournmnets/teams/add-teams.dart';
import '../../public_tournmnets/view_team_match_schedule.dart';
import '../../reusbale_widget/customLeading.dart';
import '../../reusbale_widget/custom_sizedBox.dart';
import '../../reusbale_widget/team_card.dart';


class ViewMyTournamentsTeams extends StatefulWidget {
  // Existing properties
  final String tournamentId;
  final String userId;
  final bool isHomeScreen;
  final String isCompleted;
  final int registerTeams;
  final String token;

  ViewMyTournamentsTeams({
    required this.tournamentId,
    required this.userId,
    required this.isHomeScreen,
    required this.isCompleted,
    required this.registerTeams,
    required this.token,
  });

  @override
  _ViewMyTournamentsTeamsState createState() => _ViewMyTournamentsTeamsState();
}

class _ViewMyTournamentsTeamsState extends State<ViewMyTournamentsTeams> {
  final NotificationServices notificationServices = NotificationServices();
  final controller = Get.put(MyTournamentsTeamsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.isMatchStarted.value = widget.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return BgWidget(
      child: Scaffold(
        bottomNavigationBar: Obx(() => Container(
          color: whiteColor,
          child: Container(
            color: whiteColor,
            margin: const EdgeInsets.all(10),
            child: controller.isLoading.value
                ? const Center(
              child: CustomIndicator(),
            )
                : Obx(
                  ()=> controller.isMatchStarted.value == 'false'
                  ? CustomButton(title: 'Start Tournament',
                                onTap: () {
                    controller.startTournament(
                    tournamentStatus: 'true',
                    tournamentId: widget.tournamentId,
                    context: context,
                  );
                  notificationServices.sendNotificationToAllUsers(
                    'Tournament Started! 🏆',
                    'The competition is on! Good luck and give it your best! 🔥',
                    teamsCollection,
                  );
                                },
                              )
                  : CustomButton(
                                title: 'Open Registrations',
                                onTap: () {
                  controller.startTournament(
                    tournamentStatus: 'false',
                    tournamentId: widget.tournamentId,
                    context: context,
                  );
                  notificationServices.sendNotificationToAllUsers(
                    'Registration Now Open! 📝',
                    'Join the tournament and secure your spot! 🎉',
                    teamsCollection,
                  );
                                },
                              ),
                ),
          ),
        )),
        backgroundColor: transparentColor,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
              controller.selectedTeams.clear();
            },
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:transparentColor,
                  border: Border.all(color: buttonColor)
              ),
              child: const Icon(Icons.arrow_back,color: whiteColor,size: 18,),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 55),
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
                      Row(
                        children: [
                          largeText(
                            title: 'My Tournament',
                            context: context,
                            fontWeight: FontWeight.w500,
                            color: whiteColor,
                          ),
                          Obx(()=> controller.selectedTeams.length <=1 ? IconButton(onPressed: (){
                            Get.to(()=> ViewTeamMatchSchedule(tournamentId: widget.tournamentId,));
                          }, icon: const Icon(Icons.pending_actions_outlined,color: whiteColor,)): IconButton(onPressed: (){
                            Get.to(()=> MatchSchedule(tournamentId: widget.tournamentId, teamOneName: controller.selectedTeams[0].name, teamTwoName: controller.selectedTeams[1].name, teamOneId: controller.selectedTeams[0].id, teamTwoId: controller.selectedTeams[1].id, teamOneToken: controller.selectedTeams[0].token, teamTwoToken: controller.selectedTeams[1].token));
                          }, icon:const Icon(Icons.edit_calendar_outlined,color: whiteColor))),
                        ],
                      ),
                      Sized(height: 0.01),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          color: whiteColor,
          child: StreamBuilder<QuerySnapshot>(
            stream: fireStore
                .collection(teamsCollection)
                .where('tournamentId', isEqualTo: widget.tournamentId)
                .snapshots(),
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
                  vs: doc['vs'],
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
                  token: doc['token'] ?? '--/--/-',
                );
              }).toList();

              return ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  final team = teams[index];
                  return GestureDetector(
                    onLongPress: () {
                      teams[index].vs == true ? ToastClass.showToastClass(context: context, message: 'This team match is already fixed') :controller.toggleTeamSelection(team);
                    },
                    child: Obx(
                      (){
                        final isSelected = controller.selectedTeams.contains(team);
                        return CustomSlider(
                          isTeamScreen: true,
                          isHomeScreen: widget.isHomeScreen,
                          deleteOnPressed: (context){
                            controller.confirmDeleteTeam(context: context,teamId: teams[index].id,tournamentId: widget.tournamentId,registerTeams: widget.registerTeams);
                            notificationServices.sendNotificationToSingleUser(widget.token, '🚫 Tournament Exit', 'Don\'t give up! There are more tournaments to come. 💪 Keep practicing!');

                          },
                          editOnPressed: (context){
                            controller.confirmUpdate(context: context, teamId: teams[index].id, message: 'Qualify',teamStatus: 'win');
                            notificationServices.sendNotificationToSingleUser(widget.token, '🎉 You Qualified!', 'Amazing progress! Keep going strong and make it all the way! 🎯');
                          },
                          editOnPressedTeamScreen: (context){
                            controller.confirmUpdate(context: context, teamId: teams[index].id, message: 'Disqualify',teamStatus: 'lose');
                            notificationServices.sendNotificationToSingleUser(widget.token, '😞 Tough Luck!', 'Every setback is a setup for a comeback! 🌟 Keep pushing forward!');
                          },
                          child: Container(
                            margin:const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: isSelected ? tCardBgColor.withOpacity(0.3) : transparentColor,
                            ),
                            child: TeamCard(
                              roundsQualify: team.roundsQualify,
                              imagePath: team.imageLink,
                              userId: widget.userId,
                              teamId: team.teamId,
                              onTap: () {},
                              teamName: team.name,
                              leaderName: team.teamLeaderName,
                              leaderPhone: team.teamLeaderPhoneNumber,
                              location: team.teamLocation,
                              teamResult: team.teamResult,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
