import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../consts/firebase_consts.dart';

class TokenUpdateController extends GetxController {

  updateTokenForUserTournamentTeam() async {
    try {
      QuerySnapshot querySnapshot = await fireStore.collection(teamsCollection).where('userId', isEqualTo: currentUser!.uid).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'token': userToken});
      }
    } catch (e) {
      print("Error updating token: $e");
    }
  }

  updateTokenForUserTournaments() async {
    try {
      QuerySnapshot querySnapshot = await fireStore.collection(tournamentsCollection).where('organizer_UserID', isEqualTo: currentUser!.uid).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'token': userToken});
      }
    } catch (e) {
      print("Error updating token: $e");
    }
  }

  updateTokenForUserAcceptedChallenges({required String docId}) async {
    try {
      QuerySnapshot querySnapshot = await fireStore.collection(challengesCollection).doc(docId).collection(challengesTeamCollection).where('accepterId', isEqualTo:currentUser!.uid).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'token': userToken});
      }
    } catch (e) {
      print("Error updating token: $e");
    }
  }

  updateUserChallengerToken() async {
    var data = await fireStore.collection(challengesCollection).where('challenger', isEqualTo: currentUser!.uid).get();
    for (var doc in data.docs) {
      await doc.reference.update({'token': userToken});
    }
  }

}