// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tournemnt/reusbale_widget/Custom_slider.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import '../reusbale_widget/accepter_card.dart';
import '../reusbale_widget/toast_class.dart';


class ViewMyChallenges extends StatefulWidget {
  final String challengeId;
  final String userId;
  final String isChallengeAccepted ;

  ViewMyChallenges(this.challengeId,this.userId,this.isChallengeAccepted);

  @override
  State<ViewMyChallenges> createState() => _ViewMyChallengesState();
}

class _ViewMyChallengesState extends State<ViewMyChallenges> {

  void _deleteTeam(BuildContext context, String teamId) async {
    try {
      await FirebaseFirestore.instance.collection('challenges').doc(widget.challengeId).collection('teams').doc(teamId).delete().then((value) async {
        await FirebaseFirestore.instance
            .collection('challenges')
            .doc(widget.challengeId)
            .update({
          'isChallengeAccepted':'false',
          'teamCount':1,
        });
        ToastClass.showToastClass(context: context, message: 'Team Deleted Successfully');
      });
    } catch (e) {
      ToastClass.showToastClass(context: context, message: 'Failed to delete team: $e');
    }
  }

  void _updateTeam(BuildContext context, String teamId, Map<String, dynamic> newData) async {
    try {
      await FirebaseFirestore.instance.collection('challenges').doc(widget.challengeId).collection('teams').doc(teamId).update(newData);
      ToastClass.showToastClass(context: context, message: 'Team Updated Successfully');
    } catch (e) {
      ToastClass.showToastClass(context: context, message: 'Failed to update team: $e');
    }
  }

  void _showEditDialog(BuildContext context, String teamId, String  teamName, String teamLeaderName ,String teamLeaderPhone, String location ) {
    TextEditingController teamNameController = TextEditingController(text: teamName);
    TextEditingController leaderNameController = TextEditingController(text: teamLeaderName);
    TextEditingController leaderPhoneController = TextEditingController(text: teamLeaderPhone);
    TextEditingController locationController = TextEditingController(text: location);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Team'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: teamNameController, decoration: InputDecoration(labelText: 'Team Name')),
                TextField(controller: leaderNameController, decoration: InputDecoration(labelText: 'Leader Name')),
                TextField(controller: leaderPhoneController, decoration: InputDecoration(labelText: 'Leader Phone')),
                TextField(controller: locationController, decoration: InputDecoration(labelText: 'Location')),
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
                Map<String, dynamic> newData = {
                  'teamName': teamNameController.text,
                  'teamLeaderName': leaderNameController.text,
                  'teamLeaderPhone': leaderPhoneController.text,
                  'location': locationController.text,
                };
                _updateTeam(context, teamId, newData);
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
        title: largeText(title: 'Challenge Details',context: context),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('challenges').doc(widget.challengeId).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var challengeData = snapshot.data?.data() as Map<String, dynamic>?;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(5),
                child: AccepterCard(
                  imagePath: '${challengeData?['imagePath'] ?? '---/--/-'}',
                  userId:widget.userId,
                  accpterId: '${challengeData?['challenger'] ?? '---/--/-'}',
                  accepterTeamName:'${challengeData?['challengerTeamName'] ?? '---/--/-'}',
                  location: '${challengeData?['location'] ?? '---/--/-'}',
                  teamLeaderName: '${challengeData?['teamLeaderName'] ?? '---/--/-'}',
                  accepterLeaderPhone: '${challengeData?['challengerLeaderPhone'] ?? '---/--/-'}',
                  onTap: () {},
                ),
              ),
              Sized(height: 0.02,),
              mediumText(title: 'VS',context: context),
              Sized(height: 0.02,),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('challenges').doc(widget.challengeId).collection('teams').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const  Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: snapshot.data!.docs.map((doc) {
                      return Container(
                        margin: EdgeInsets.all(5),
                        child: CustomSlider(
                          isTeamScreen: false,
                          deleteOnPressed: (context){
                            _deleteTeam(context, doc.id);
                          },
                          editOnPressed: (context){
                            _showEditDialog(context, doc.id,doc['teamName'],doc['teamLeaderName'],doc['teamLeaderPhone'],doc['location']);
                          },
                          child: AccepterCard(
                            imagePath: doc['imageLink'],
                            userId: widget.userId,
                            accpterId:doc['accepterId'],
                            accepterTeamName:doc['teamName'],
                            location: doc['location'],
                            teamLeaderName: doc['teamLeaderName'],
                            accepterLeaderPhone: doc['teamLeaderPhone'],
                            onTap: () {},
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}


