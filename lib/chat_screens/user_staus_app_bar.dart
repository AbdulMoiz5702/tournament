

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../consts/colors.dart';
import '../consts/firebase_consts.dart';
import '../controllers/chat_controller.dart';
import '../reusbale_widget/call_button.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';
import 'messages.dart';

class UserStatusAppBar extends StatelessWidget {
  const UserStatusAppBar({
    super.key,
    required this.widget,
  });

  final MessageScreen widget;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        CallButton(name: widget.receiverName, id: widget.receiverId),
        Sized(width: 0.05),
      ],
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryTextColor,
            ),
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.person,
              color: whiteColor,
            ),
          ),
          Sized(width: 0.05),
          Row(
            children: [
              mediumText(title: widget.receiverName),
              Sized(width: 0.02),
              StreamBuilder<DocumentSnapshot>(
                stream: fireStore
                    .collection(usersCollection)
                    .doc(widget.receiverId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: Sized());
                  } else {
                    final userData = snapshot.data!.data() as Map<String, dynamic>;
                    return userData['is_online'] == true
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        smallText(
                            title: 'online',
                            color: greenColor,
                            fontSize: 10),
                        Sized(width: 0.01),
                        Icon(Icons.radio_button_checked_outlined,
                            color: greenColor, size: 10)
                      ],
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        smallText(title: 'offline', fontSize: 10),
                        Sized(width: 0.01),
                        Icon(Icons.trip_origin_outlined,
                            color: secondaryTextColor, size: 10)
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class EditDeleteAppbar extends StatelessWidget {
  const EditDeleteAppbar({
    super.key,
    required this.controller,
  });

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
          onTap: (){
            controller.isMessageSelected.value = false;
            controller.resetIndex();
            controller.selectedCMessageDocId.value = '';
            controller.selectedChatDocId.value = '';
          },
          child: Icon(Icons.arrow_back)),
      actions: [
        controller.messageType.value == 'text' ? GestureDetector(
            onTap: (){
              print('isEdit : ${controller.isEdit.value}');
              print('EditMessageText : ${controller.editMessageText.value}');
              controller.isEdit.value = true;
              controller.changeEditTextValue();
            }, child: Icon(Icons.edit)) : Sized(height: 0,width: 0,),
        Sized(width: 0.05,),
        GestureDetector(
            onTap: (){
              controller.deleteMessage(chatDocId: controller.selectedChatDocId.value, docId: controller.selectedCMessageDocId.value);
            },
            child: Icon(Icons.delete)),
        Sized(width: 0.05,),
      ],
    );
  }
}