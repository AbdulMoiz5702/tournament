import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/reusbale_widget/Custom_slider.dart';
import 'package:tournemnt/reusbale_widget/customLeading.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import '../../../models_classes.dart';
import '../../../reusbale_widget/team_card.dart';
import '../../reusbale_widget/toast_class.dart';

class MyMatchesTeamScreen extends StatefulWidget {
  final String tournamentId;
  final String userId;
  final bool isHomeScreen;
  MyMatchesTeamScreen(
      {required this.tournamentId,
      required this.userId,
      required this.isHomeScreen});

  @override
  State<MyMatchesTeamScreen> createState() => _MyMatchesTeamScreenState();
}

class _MyMatchesTeamScreenState extends State<MyMatchesTeamScreen> {
  void _deleteTeam(BuildContext context, String teamId) async {
    await FirebaseFirestore.instance
        .collection('Teams')
        .doc(teamId)
        .delete()
        .then((value) {
      throw ToastClass.showToastClass(
          context: context, message: 'Team Deleted');
    }).timeout(const Duration(seconds: 5), onTimeout: () {
      throw ToastClass.showToastClass(
          context: context, message: 'Request Time Out');
    });
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

  void _updateTeam(
      BuildContext context,
      String teamId,
      String newName,
      String newLeaderName,
      String newLeaderPhoneNumber,
      String newLocation) async {
    try {
      await FirebaseFirestore.instance.collection('Teams').doc(teamId).update({
        'name': newName,
        'teamLeader': newLeaderName,
        'teamLeaderNumber': newLeaderPhoneNumber,
        'teamLocation': newLocation,
      });
      ToastClass.showToastClass(context: context, message: 'Team Updated Successfully');
    } catch (e) {
      ToastClass.showToastClass(context: context, message: 'Failed to update team: $e');
    }
  }

  void _showEditDialog(BuildContext context, Team team) {
    TextEditingController nameController =
        TextEditingController(text: team.name);
    TextEditingController leaderNameController =
        TextEditingController(text: team.teamLeaderName);
    TextEditingController leaderPhoneController =
        TextEditingController(text: team.teamLeaderPhoneNumber);
    TextEditingController locationController =
        TextEditingController(text: team.teamLocation);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backGroundColor,
          title: Text('Edit Team'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Sized(height: 0.01,),
                CustomTextField(
                  controller: nameController,
                  hintText: 'Team Name',
                  validate: (value) {
                    if (value.isEmpty) {
                      return value = 'Team Name needed';
                    }
                  },
                ),
                Sized(height: 0.01,),
                CustomTextField(
                  controller: leaderNameController,
                  hintText: 'Team Leader Name',
                  validate: (value) {
                    if (value.isEmpty) {
                      return value = 'Team Leader Name needed';
                    }
                  },
                ),
                Sized(height: 0.01,),
                CustomTextField(
                  controller: leaderPhoneController,
                  hintText: 'Leader Phone Number',
                  validate: (value) {
                    if (value.isEmpty) {
                      return value = 'Leader Phone Number needed';
                    }
                  },
                  keyboardType: TextInputType.number,
                ),
                Sized(height: 0.01,),
                CustomTextField(
                  controller: locationController,
                  hintText: 'Leader Phone Number',
                  validate: (value) {
                    if (value.isEmpty) {
                      return value = 'Leader Phone Number needed';
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateTeam(
                  context,
                  team.id,
                  nameController.text,
                  leaderNameController.text,
                  leaderPhoneController.text,
                  locationController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomLeading(),
        title: largeText(title: 'All Teams', context: context),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Teams')
            .where('tournamentId', isEqualTo: widget.tournamentId)
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
                isTeamScreen: false,
                isHomeScreen: widget.isHomeScreen,
                deleteOnPressed: (context) {
                  widget.userId == teams[index].teamId
                      ? _confirmDeleteTeam(context, teams[index].id)
                      : ToastClass.showToastClass(
                          context: context,
                          message: 'You are not allowed to modify other teams');
                },
                editOnPressed: (context) {
                  widget.userId == teams[index].teamId
                      ? _showEditDialog(context, teams[index])
                      : ToastClass.showToastClass(
                          context: context,
                          message: 'You are not allowed to modify other teams');
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: TeamCard(
                    roundsQualify: teams[index].roundsQualify,
                    imagePath:teams[index].imageLink,
                    userId: widget.userId,
                    teamId: teams[index].teamId,
                    onTap: () {},
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
    );
  }
}
