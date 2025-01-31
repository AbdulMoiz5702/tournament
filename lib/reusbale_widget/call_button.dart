
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';

import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../consts/colors.dart';
import '../consts/images_path.dart';
import '../controllers/call_controller.dart';

class CallButton extends StatefulWidget {
  const CallButton({
    required this.name,
    required this.id,
    this.color = loginEnabledButtonColor,
    required this.userId,
  });

  final String id ;
  final String name ;
  final Color color ;
  final String userId;

  @override
  State<CallButton> createState() => _CallButtonState();
}

class _CallButtonState extends State<CallButton> {

  var controller = Get.put(ZegoCloudController());

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    controller.startCall(userId: widget.userId, userName:controller.userName,context: context);
    print('=-----------------------------------------chatButton_init-----------------------------------------------------');
  }

  @override
  Widget build(BuildContext context) {
    return ZegoSendCallInvitationButton(
      iconSize: const Size(35, 35),
      buttonSize:const  Size(40, 40),
      isVideoCall: false,
      resourceID: "tournament_app",
      invitees: [
        ZegoUIKitUser(
          id: widget.id,
          name: widget.name,
        ),
      ],
    );
  }
}
