import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice_message_player/voice_message_player.dart';
import '../../consts/colors.dart';
import '../../controllers/chat_controller.dart';

class VoiceMessgaeWidget extends StatelessWidget {
  const VoiceMessgaeWidget({
    super.key,
    required this.isCurrentUser,
    required this.controller,
    required this.messageData,
    required this.docId,
    required this.index

  });

  final bool isCurrentUser;
  final ChatController controller;
  final QueryDocumentSnapshot<Object?> messageData;
  final String docId;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Obx(
          ()=> GestureDetector(
        onLongPress: (){
          if(isCurrentUser){
            controller.changeIndex(index);
            controller.isMessageSelected.value = true;
            controller.selectedCMessageDocId.value = messageData.id;
            controller.selectedChatDocId.value = docId;
            controller.messageType.value = '';
          }
        },
        child: Container(
          padding: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            boxShadow: controller.currentIndex.value == index ? controller.isMessageSelected.value ==  true ? [
              BoxShadow(color: cardPartColor,blurRadius: 5,spreadRadius: 7),
            ]: [] :  [],
            color: isCurrentUser
                ? cardTextColor
                : cardMyTournament,
            borderRadius: BorderRadius.only(
              topRight: isCurrentUser
                  ? Radius.circular(0)
                  : Radius.circular(20),
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              topLeft: isCurrentUser
                  ? Radius.circular(20)
                  : Radius.circular(0),
            ),
          ),
          margin: EdgeInsets.only(top: 10),
          child: VoiceMessagePlayer(
            activeSliderColor: whiteColor,
            backgroundColor: isCurrentUser
                ? cardTextColor
                : cardMyTournament,
            controller: VoiceController(
              noiseCount: 40,
              audioSrc: messageData['voice_message'],
              maxDuration:
              Duration(seconds: messageData['duration']),
              isFile: false,
              onComplete: () {},
              onPause: () {},
              onPlaying: () {},
              onError: (err) {},
            ),
            cornerRadius: 15,
            innerPadding: 0,
            playPauseButtonDecoration:
            BoxDecoration(color: Colors.transparent),
            size: 25,
          ),
        ),
      ),
    );
  }
}