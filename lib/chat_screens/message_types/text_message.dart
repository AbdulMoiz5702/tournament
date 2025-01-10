



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/controllers/chat_controller.dart';

import '../../consts/colors.dart';
import '../../reusbale_widget/custom_sizedBox.dart';
import '../../reusbale_widget/text_widgets.dart';

class TextMessageWidget extends StatelessWidget {
  const TextMessageWidget({required this.controller,required this.isCurrentUser,required this.index,required this.messageData,required this.docId});
  final ChatController controller ;
  final bool isCurrentUser ;
  final int  index ;
  final dynamic messageData ;
  final String docId ;

  @override
  Widget build(BuildContext context) {
    return Obx(
        ()=>  GestureDetector(
        onLongPress: (){
          if(isCurrentUser){
            controller.changeIndex(index);
            controller.isMessageSelected.value = true;
            controller.selectedCMessageDocId.value = messageData.id;
            controller.selectedChatDocId.value = docId;
            controller.messageType.value = 'text';
            controller.editMessageText.value = messageData['message'];
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            boxShadow:  controller.currentIndex.value == index ? controller.isMessageSelected.value ==  true ? [
              BoxShadow(color: cardPartColor,blurRadius: 5,spreadRadius: 7),
            ]: [] :  [],
            color: isCurrentUser
                ? cardTextColor
                : cardMyTournament,
            borderRadius: BorderRadius.only(
              topRight: isCurrentUser
                  ? Radius.circular(0)
                  : Radius.circular(10),
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              topLeft: isCurrentUser
                  ? Radius.circular(10)
                  : Radius.circular(0),
            ),
          ),
          margin: EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              smallText(
                fontSize: 13,
                color: whiteColor,
                title: messageData['message'],
              ),
              Sized(height: 0.002),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  messageData['isEdit'] == true ? smallText(
                    color: secondaryTextFieldColor,
                    fontSize: 8,
                    title:'edited'
                  ): Sized(),
                  messageData['isEdit'] == true ?Sized(width: 0.02,) : Sized(),
                  smallText(
                    color: secondaryTextFieldColor,
                    fontSize: 8,
                    title:
                    _formatTimestamp(messageData['time']),
                  ),
                  Sized(width: 0.02,),
                isCurrentUser == true ?  buildMessageIndicator(messageData) : Sized(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    var date = timestamp.toDate();
    var formatter = DateFormat('h:mm a'); // 'h' for 12-hour format and 'a' for AM/PM
    return formatter.format(date);
  }
}

Widget buildMessageIndicator(dynamic messageData) {
  if (messageData['isSent'] == true && messageData['isDelivered'] == false) {
    return Icon(Icons.check, size: 12, color: greyColor);
  } else if ( messageData['isDelivered'] == true && messageData['status'] == true) {
    return Icon(Icons.done_all_outlined, size: 12, color: greenColor);
  } else if (messageData['isDelivered'] == true) {
    return Icon(Icons.done_all_outlined, size: 12, color:greyColor );
  }else {
    return Icon(Icons.access_time, size: 8, color: Colors.grey); // Message is pending
  }
}

