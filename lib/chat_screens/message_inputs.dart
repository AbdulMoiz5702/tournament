import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';
import '../consts/colors.dart';
import '../consts/images_path.dart';
import '../controllers/chat_controller.dart';
import '../controllers/set_status_controller.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';
import '../services/notification_sevices.dart';

Widget buildMessageInput(
    {required SetStatusController statusController,
    required ChatController controller,
    required BuildContext context,
    required String docId,
    required String receiverId,
    required String userId,
    required String receiverToken,
    required String userName}) {
  NotificationServices notificationServices = NotificationServices();
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: backGroundColor)),
    margin: EdgeInsets.only(bottom: 10, left: 15, right: 15, top: 5),
    child: Row(
      children: [
        Obx(
          () => controller.isRecording.value == true
              ? Sized()
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: TextFormField(
                      cursorColor: primaryTextColor,
                      controller: controller.message,
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Type a message...',
                      ),
                    ),
                  ),
                ),
        ),
        Obx(
          () => controller.isRecording.value == true
              ? Sized()
              : InkWell(
                  onTap: () async {
                    controller.isEdit.value == true
                        ? controller.editMessage(
                            chatDocId: controller.selectedChatDocId.value,
                            docId: controller.selectedCMessageDocId.value)
                        : controller.sendMessage(
                            receiverId: receiverId,
                            senderId: userId,
                            context: context,
                            receiverToken: receiverToken,
                            docId: docId.toString());
                    statusController.isOnline.value == false
                        ? notificationServices.sendNotificationToSingleUser(
                            receiverToken,
                            'New Message! 💬',
                            'You have a new message from $userName')
                        : null;
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(send), fit: BoxFit.cover)),
                  ),
                ),
        ),
        Obx(
          () => controller.isRecording.value == true
              ? Sized()
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(image), fit: BoxFit.cover)),
                      ),
                    ),
                    // Hidden PopupMenuButton
                    PopupMenuButton<ImageSource>(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 20,
                      offset: Offset(5, 100),
                      color: primaryTextColor,
                      onSelected: (ImageSource source) async {
                        await controller.sendPicture(
                          receiverId: receiverId,
                          senderId: userId,
                          docId: docId.toString(),
                          context: context,
                          receiverToken: receiverToken,
                          source: source,
                        );
                        statusController.isOnline.value == false
                            ? notificationServices.sendNotificationToSingleUser(
                                receiverToken,
                                'New Message! 💬',
                                'You have a new message from $userName')
                            : null;
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: ImageSource.camera,
                          child: Row(
                            children: [
                              Icon(
                                Icons.camera,
                                color: whiteColor,
                              ),
                              SizedBox(width: 8),
                              smallText(
                                title: 'Camera',
                                color: whiteColor,
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: ImageSource.gallery,
                          child: Row(
                            children: [
                              Icon(Icons.photo_library, color: whiteColor),
                              SizedBox(width: 8),
                              smallText(
                                title: 'Gallery',
                                color: whiteColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                      icon: Container(), // Hide the icon of PopupMenuButton
                    ),
                  ],
                ),
        ),
        GestureDetector(
          onTapDown: (details) async {
            // Start recording when the button is pressed
            if (docId == null) {
              await controller.startRecording();
            } else {
              await controller.startRecording();
            }
          },
          onTapUp: (details) async {
            String? filePath = await controller.stopRecording();
            if (filePath != null) {
              controller.sendVoiceMessage(
                receiverId: receiverId,
                senderId: userId,
                docId: docId.toString(),
                context: context,
                receiverToken: receiverToken,
                filePath: filePath,
              );
              statusController.isOnline.value == false
                  ? notificationServices.sendNotificationToSingleUser(
                      receiverToken,
                      'New Message! 💬',
                      'You have a new message from $userName')
                  : null;
            }
          },
          onTapCancel: () async {
            await controller.stopRecording();
          },
          child: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Sized(
                  width: controller.isRecording.value == true ? 0.05 : 0,
                ),
                controller.isRecording.value == true
                    ? Container(
                        height: 45,
                        width: 45,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage(recordingGif),
                          fit: BoxFit.cover,
                        )),
                        child: smallText(
                            title:
                                controller.durationDuringRecording.toString(),
                            color: primaryTextColor,
                            fontWeight: FontWeight.w700),
                      )
                    : Container(
                        height: 0,
                        width: 0,
                      ),
                controller.isRecording.value == true
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 30,
                        width: MediaQuery.sizeOf(context).width * 0.6,
                        child: Image.asset(
                          soundWave,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Sized(),
                Container(
                  height: controller.isRecording.value == true ? 40 : 30,
                  width: controller.isRecording.value == true ? 40 : 30,
                  alignment: Alignment.center,
                  child: controller.isLoading.value == true
                      ? Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: secondaryTextColor,
                          ))
                      : Image.asset(
                          voice,
                          fit: BoxFit.cover,
                        ),
                ),
                Sized(width: 0.02),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


Widget buildFirstMessageMessageInput(
    {required SetStatusController statusController,
      required ChatController controller,
      required BuildContext context,
      required String receiverId,
      required String userId,
      required String receiverToken,
      required String userName}) {
  NotificationServices notificationServices = NotificationServices();
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: greenColor)),
    margin: EdgeInsets.only(bottom: 10, left: 15, right: 15, top: 5),
    child: Row(
      children: [
        Obx(
              ()=>  controller.isRecording.value == true ? Sized(): Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: TextFormField(
                cursorColor: primaryTextColor,
                controller: controller.message,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Type a message...',
                ),
              ),
            ),
          ),
        ),
        Obx(
              ()=> controller.isRecording.value == true ? Sized(): InkWell(
            onTap: () async {
              controller.sendFirstMessage(
                  receiverId: receiverId,
                  senderId: userId,
                  context: context,
                  receiverToken: receiverToken);
              notificationServices.sendNotificationToSingleUser(
                  receiverToken,
                  'New Message! 💬',
                  'You have a new message from $userName. Start the conversation!'
              );
            },
            child: Container(
              height: 30,
              width: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(send), fit: BoxFit.cover)),
            ),
          ),
        ),
        GestureDetector(
          onTapDown: (details) async {
            await controller.startRecording();
          },
          onTapUp: (details) async {
            String? filePath = await controller.stopRecording();
            if (filePath != null) {
              controller.sendFirstVoiceMessage(
                receiverId: receiverId,
                senderId: userId,
                context: context,
                filePath: filePath,
                receiverToken: receiverToken,
              );
              notificationServices.sendNotificationToSingleUser(
                  receiverToken,
                  'New Message! 💬',
                  'You have a new message from $userName'
              );
            }
          },
          onTapCancel: () async {
            await controller.stopRecording();
          },
          child: Obx(
                () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Sized(
                  width: controller.isRecording.value == true ? 0.05 : 0,
                ),
                controller.isRecording.value == true
                    ? Container(
                  height: 45 ,
                  width:45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(recordingGif),
                        fit: BoxFit.cover,
                      )),
                  child: smallText(title: controller.durationDuringRecording.toString(), color: primaryTextColor,fontWeight: FontWeight.w700),
                )
                    : Container(
                  height: 0,
                  width: 0,
                ),
                controller.isRecording.value == true ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 30,
                  width: MediaQuery.sizeOf(context).width * 0.6,
                  child: Image.asset(soundWave,fit: BoxFit.cover,),
                ) : Sized(),
                Container(
                  height: controller.isRecording.value == true ? 40 : 30,
                  width: controller.isRecording.value == true ? 40 : 30,
                  alignment: Alignment.center,
                  child:controller.isLoading.value == true ? Container(
                      height: 20,
                      width:20,
                      child: CircularProgressIndicator(color: secondaryTextColor,)): Image.asset(voice,fit: BoxFit.cover,),
                ),
                Sized(width:  0.02),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}