


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';

import '../reusbale_widget/toast_class.dart';

class UpdateTournamentController extends GetxController {

  var isLoading = false.obs;
  var name = ''.obs;
  var organizerName = ''.obs;
  var organizerPhoneNumber = ''.obs;
  var tournamentFee = ''.obs;
  var tournamentOvers = ''.obs;
  var location = ''.obs;
  var startDate = ''.obs;
  final formKey = GlobalKey<FormState>();

  updateTournament({required String tournamentId,required BuildContext context}) async {
    if (formKey.currentState!.validate()) {
      isLoading(true);
      formKey.currentState!.save();
      await fireStore
          .collection(tournamentsCollection)
          .doc(tournamentId)
          .update({
        'name': name.value,
        'organizerName': organizerName.value,
        'organizerPhoneNumber': organizerPhoneNumber.value,
        'tournamentFee': tournamentFee.value,
        'tournamentOvers': tournamentOvers.value,
        'location': location.value,
        'startDate': startDate.value,
        'token':userToken,
      }).then((value){
        isLoading(false);
        Navigator.pop(context);
      }).onError((error, stackTrace){
        isLoading(false);
        ToastClass.showToastClass(context: context, message: 'Something went wrong');
      });

    }
  }



}