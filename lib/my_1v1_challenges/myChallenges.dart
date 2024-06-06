import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tournemnt/my_1v1_challenges/view_my_challenges.dart';
import 'package:tournemnt/reusbale_widget/Custom_slider.dart';
import 'package:tournemnt/reusbale_widget/challenge_card.dart';
import '../1v1_challenges/view_challnege_screen.dart';
import '../reusbale_widget/toast_class.dart';

class UserChallengesScreen extends StatefulWidget {
  final String userId;

  UserChallengesScreen({required this.userId});

  @override
  State<UserChallengesScreen> createState() => _UserChallengesScreenState();
}

class _UserChallengesScreenState extends State<UserChallengesScreen> {


  void _deleteChallenge(BuildContext context, String challengeId) async {
    try {
      await FirebaseFirestore.instance
          .collection('challenges')
          .doc(challengeId)
          .delete();
      ToastClass.showToastClass(
          context: context, message: 'Challenge deleted successfully');
    } catch (e) {
      ToastClass.showToastClass(
          context: context, message: 'Failed to delete challenge: $e');
    }
  }

  void _updateChallenge(
    BuildContext context,
    String challengeId,
    String newTeamName,
    String newLeaderName,
    String newLeaderPhoneNumber,
    String newLocation,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('challenges')
          .doc(challengeId)
          .update({
        'challengerTeamName': newTeamName,
        'teamLeaderName': newLeaderName,
        'challengerLeaderPhone': newLeaderPhoneNumber,
        'location': newLocation,
      });
      ToastClass.showToastClass(
          context: context, message: 'Challenge Updated Successfully');
    } catch (e) {
      ToastClass.showToastClass(
          context: context, message: 'Failed to update challenge: $e');
    }
  }

  void _showEditDialog(BuildContext context, String challengeId,
      String teamName, String leaderName, String leaderPhone, String location) {
    TextEditingController teamNameController =
        TextEditingController(text: teamName);
    TextEditingController leaderNameController =
        TextEditingController(text: leaderName);
    TextEditingController leaderPhoneController =
        TextEditingController(text: leaderPhone);
    TextEditingController locationController =
        TextEditingController(text: location);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Challenge'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: teamNameController,
                    decoration: InputDecoration(labelText: 'Team Name')),
                TextField(
                    controller: leaderNameController,
                    decoration: InputDecoration(labelText: 'Leader Name')),
                TextField(
                    controller: leaderPhoneController,
                    decoration: InputDecoration(labelText: 'Leader Phone')),
                TextField(
                    controller: locationController,
                    decoration: InputDecoration(labelText: 'Location')),
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
                _updateChallenge(
                  context,
                  challengeId,
                  teamNameController.text,
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('challenges')
            .where('challenger', isEqualTo: widget.userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return Container(
                margin: EdgeInsets.all(5),
                child: CustomSlider(
                  isTeamScreen: false,
                  deleteOnPressed: (context){
                    _deleteChallenge(context,doc.id);
                  },
                  editOnPressed: (context){
                    _showEditDialog(context, doc.id, doc['challengerTeamName'], doc['teamLeaderName'], doc['challengerLeaderPhone'], doc['location'],);
                  },
                  child: ChallengeCard(
                    startDate: doc['startDate'],
                    imagePath: doc['imagePath'],
                      challengerTeamName: doc['challengerTeamName'],
                      teamLeaderName: doc['teamLeaderName'],
                      challengerLeaderPhone: doc['challengerLeaderPhone'],
                      location: doc['location'],
                      matchOvers: doc['Overs'],
                      teamCount: doc['teamCount'],
                      userId: widget.userId,
                      challengerId: doc['challenger'],
                      isChallengeAccepted: doc['isChallengeAccepted'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewMyChallenges(doc.id,
                                  widget.userId, doc['isChallengeAccepted'])),
                        );
                      }),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
