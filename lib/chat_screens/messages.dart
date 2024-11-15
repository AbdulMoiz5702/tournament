// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/chat_screens/message_inputs.dart';
import 'package:tournemnt/chat_screens/message_types/text_message.dart';
import 'package:tournemnt/chat_screens/user_staus_app_bar.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import '../controllers/call_controller.dart';
import '../controllers/chat_controller.dart';
import '../controllers/set_status_controller.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import 'message_types/imgae_message.dart';
import 'message_types/voive_message.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen(
      {required this.receiverId,
      required this.receiverName,
      required this.receiverToken,
        required this.userId
      });
  final String receiverId;
  final String receiverName;
  final String receiverToken;
  final String userId ;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with WidgetsBindingObserver {

  var controller = Get.put(ChatController());
  var callController = Get.find<ZegoCloudController>();
  var statusController = Get.put(SetStatusController());

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      statusController.setStatus(isOnline: true);
      statusController.isOnline.value = true;
    } else {
      statusController.setStatus(isOnline: false);
      statusController.isOnline.value = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    print("Observer removed");
    super.dispose();
  }

  bool isture = false;

  @override
  Widget build(BuildContext context) {
    String combinedId1 = '${widget.userId}_${widget.receiverId}';
    String combinedId2 = '${widget.receiverId}_${widget.userId}';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(
              () => controller.isMessageSelected.value == true
              ? EditDeleteAppbar(controller: controller)
              : UserStatusAppBar(widget: widget),
        ),
      ),
        body: StreamBuilder<QuerySnapshot>(
        stream: fireStore.collection(chatsCollection)
            .where('combine_id', whereIn: [combinedId1, combinedId2])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CustomIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            return _buildInitialMessageInput(statusController: statusController, controller: controller, context: context, receiverId: widget.receiverId, userId: widget.userId, receiverToken: widget.receiverToken, userName: callController.userName);
          } else {
            var doc = snapshot.data!.docs.first;
            var docId = doc.id;
            return StreamBuilder<QuerySnapshot>(
              stream: fireStore
                  .collection(chatsCollection)
                  .doc(docId)
                  .collection(messagesCollection)
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, messageSnapshot) {
                if (messageSnapshot.hasData) {
                  var messages = messageSnapshot.data!.docs;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          cacheExtent: 0,
                          addRepaintBoundaries: true,
                          reverse: true,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            var messageData = messages[index];
                            bool isCurrentUser = messageData['sender_id'] == widget.userId;
                            // Call function to mark messages as delivered when the user views them
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              controller.markMessageAsDelivered(docId, widget.userId);
                            });
                            // Check if the message is from another user and the status is not yet marked as read
                            if (!isCurrentUser && messageData['status'] == false) {
                              controller.markMessageAsRead(docId, messageData.id);
                            }
                            return Align(
                                  alignment: isCurrentUser
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: messageData['message_type'] == 'voice'
                                      ? VoiceMessgaeWidget(isCurrentUser: isCurrentUser, controller: controller, messageData: messageData, docId: docId,index: index,)
                                      : messageData['message_type'] == 'text'
                                      ? TextMessageWidget(controller: controller, isCurrentUser: isCurrentUser, index: index, messageData: messageData, docId: docId)
                                      : ImgaeMessageWidget(controller: controller, isCurrentUser: isCurrentUser, index: index, messageData: messageData, docId: docId));
                          },
                        ),
                      ),
                      buildMessageInput(statusController: statusController, controller: controller, context: context, docId: docId, receiverId: widget.receiverId, userId:widget.userId, receiverToken: widget.receiverToken, userName: callController.userName),
                    ],
                  );
                } else {
                  return Center(child: largeText(title: ''));
                }
              },
            );
          }
        },
      )
    );
  }

  Widget _buildInitialMessageInput({required SetStatusController statusController,
    required ChatController controller,
    required BuildContext context,
    required String receiverId,
    required String userId,
    required String receiverToken,
    required String userName}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Center(child: largeText(title: 'Start a conversation')),
        Sized(
          height: 0.4,
        ),
        buildFirstMessageMessageInput(statusController: statusController, controller: controller, context: context,receiverId: receiverId, userId: userId, receiverToken: receiverToken, userName: userName)
      ],
    );
  }

}








