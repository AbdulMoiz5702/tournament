


import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../consts/colors.dart';
import '../../controllers/chat_controller.dart';
import '../../reusbale_widget/custom_indicator.dart';
import '../../reusbale_widget/text_widgets.dart';

class ImgaeMessageWidget extends StatelessWidget {
  const ImgaeMessageWidget({required this.controller,required this.isCurrentUser,required this.index,required this.messageData,required this.docId});
  final ChatController controller ;
  final bool isCurrentUser ;
  final int  index ;
  final dynamic messageData ;
  final String docId ;

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
          clipBehavior: Clip.antiAlias,
          alignment: isCurrentUser
              ? Alignment.bottomRight
              : Alignment.bottomRight,
          margin: EdgeInsets.only(top: 10),
          height:
          MediaQuery.sizeOf(context).height * 0.45,
          width: MediaQuery.sizeOf(context).width * 0.6,
          decoration: BoxDecoration(

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
            boxShadow:  controller.currentIndex.value == index ? controller.isMessageSelected.value ==  true ? [
              BoxShadow(color: primaryTextColor,blurRadius: 5,spreadRadius: 7),
            ]: [] :  [],
            border: Border.all(
              color: isCurrentUser
                  ? primaryTextColor
                  : roleBoxColor,
              width: 4,
            ),
          ),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: messageData['imageUrl'],
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(child: CustomIndicator()),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error),
                width: double.infinity,
                height: double.infinity,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  color: backGroundColor.withOpacity(0.5),
                  padding: EdgeInsets.all(5),
                  child: smallText(
                    fontWeight: FontWeight.bold,
                    color: whiteColor,
                    title: _formatTimestamp(messageData['time']),
                  ),
                ),
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
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
