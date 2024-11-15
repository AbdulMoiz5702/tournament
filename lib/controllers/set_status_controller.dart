import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';

class SetStatusController extends GetxController {

  var isOnline = false.obs;

  setStatus({required bool isOnline}) async {
    try {
      var data = fireStore.collection(usersCollection).doc(currentUser!.uid);
      await data.update({
        'is_online': isOnline,
      });
      update();
    } catch (e) {
      print("Error updating status: $e");
    }
  }

}