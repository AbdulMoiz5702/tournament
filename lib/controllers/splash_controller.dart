

import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';

import '../BottomScreen.dart';
import '../services/notification_sevices.dart';
import 'call_controller.dart';

class SplashController extends GetxController {

  final NotificationServices notificationServices = NotificationServices();

  Future<void> initialize(context) async {
    await notificationServices.requestNotificationPermission();
    await notificationServices.firebaseInit();
    try {
      String? token = await notificationServices.getDeviceToken();
      if (token != null) {
        print('Firebase Token : $token');
        userToken = token;
      } else {
        print('Error: Firebase token could not be retrieved.');
      }
    } catch (e) {
      print('Error retrieving token: $e');
    }

    Get.offAll(() => BottomScreen(userId: currentUser!.uid), transition: Transition.cupertino);
  }




}