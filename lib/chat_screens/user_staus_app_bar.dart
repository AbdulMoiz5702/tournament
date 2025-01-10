

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
    Key? key,
    required this.widget,
  }) : super(key: key);

  final MessageScreen widget;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                padding: const EdgeInsets.all(5),
                child: const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 8),
              smallText(title :widget.receiverName,fontWeight: FontWeight.bold),
            ],
          ),
          CallButton(name: widget.receiverName, id: widget.receiverId),
        ],
      ),
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(color: Colors.blue),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: StreamBuilder<DocumentSnapshot>(
          stream: fireStore.collection(usersCollection).doc(widget.receiverId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return const SizedBox.shrink();
            }
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding:  EdgeInsets.symmetric(vertical: 2,horizontal: MediaQuery.sizeOf(context).width  * 0.2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    userData['is_online'] == true ? 'Online' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      color: userData['is_online'] == true ? Colors.green : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    userData['is_online'] == true
                        ? Icons.radio_button_checked_outlined
                        : Icons.radio_button_unchecked,
                    color: userData['is_online'] == true ? Colors.green : Colors.grey,
                    size: 12,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class EditDeleteAppbar extends StatelessWidget {
  const EditDeleteAppbar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          controller.isMessageSelected.value = false;
          controller.resetIndex();
          controller.selectedCMessageDocId.value = '';
          controller.selectedChatDocId.value = '';
        },
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(color: Colors.blue),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
        ),
      ),
      actions: [
        if (controller.messageType.value == 'text')
          GestureDetector(
            onTap: () {
              controller.isEdit.value = true;
              controller.changeEditTextValue();
            },
            child: const Icon(Icons.edit, color: whiteColor),
          ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            controller.deleteMessage(
              chatDocId: controller.selectedChatDocId.value,
              docId: controller.selectedCMessageDocId.value,
            );
          },
          child: const Icon(Icons.delete, color: Colors.red),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}


