import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../consts/firebase_consts.dart';

class ZegoCloudController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    getUserName();
    getUserLocation();
    getUserPhoneNumber();
  }

  var userName = '';
  var location = '';
  var phoneNumber = '';
  getUserName() async {
    var name = await fireStore.collection(usersCollection).where('userId',isEqualTo: currentUser!.uid).get().then((value){
      if(value.docs.isNotEmpty){
        return value.docs.single['name'];
      }
    });
    userName = name ;
    print('User name : $userName');
  }
  getUserLocation() async {
    var name = await fireStore.collection(usersCollection).where('userId',isEqualTo: currentUser!.uid).get().then((value){
      if(value.docs.isNotEmpty){
        return value.docs.single['location'];
      }
    });
    location = name ;
    print('User location : $userName');
  }
  getUserPhoneNumber() async {
    var name = await fireStore.collection(usersCollection).where('userId',isEqualTo: currentUser!.uid).get().then((value){
      if(value.docs.isNotEmpty){
        return value.docs.single['phoneNumber'];
      }
    });
    phoneNumber = name ;
    print('User Phone : $userName');
  }



  void startCall({required String userId ,required String userName,required BuildContext context}) async {
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 719365644, /*input your AppID*/
      appSign: 'cde26876b30b23d0d8185a3fda5fda32e3adb0afac22ebeda11e77f4f68bbaea' /*input your AppSign*/,
      userID:userId,
      userName:userName,
      plugins: [ZegoUIKitSignalingPlugin()],
      notificationConfig: ZegoCallInvitationNotificationConfig(
        androidNotificationConfig: ZegoCallAndroidNotificationConfig(
          showFullScreen: true,
          fullScreenBackground: 'assets/image/call.png',
          channelID: "ZegoUIKit",
          channelName: "Call Notifications",
          sound: "call",
          icon: "call",
        ),
        iOSNotificationConfig: ZegoCallIOSNotificationConfig(
          systemCallingIconName: 'CallKitIcon',
        ),
      ),
      requireConfig:(ZegoCallInvitationData data) {
        final config = ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
        config.topMenuBar.isVisible = true;
        config.topMenuBar.buttons.insert(0, ZegoCallMenuBarButtonName.minimizingButton);
        return config;
      },
    );
    print('---------------------------------------------init--------------------------------');
  }

  void onUserLogout() {
    ZegoUIKitPrebuiltCallInvitationService().uninit();
  }


}