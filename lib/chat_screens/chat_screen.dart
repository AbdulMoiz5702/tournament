import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/chat_screens/messages.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';

import '../consts/colors.dart';
import '../consts/firebase_consts.dart';
import '../reusbale_widget/customLeading.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';



class ChatScreen extends StatelessWidget {
  final String userId;
  const ChatScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    String toTitleCase(String text) {
      if (text.isEmpty) return text;
      return text
          .split(' ')
          .map((word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1).toLowerCase())
          .join(' ');
    }
    return BgWidget(
      child: Scaffold(
        backgroundColor: transparentColor,
        appBar: AppBar(
          leading: const CustomLeading(),
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 55),
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.sizeOf(context).width * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Sized(height: 0.005),
                      largeText(
                        title: 'Chats',
                        context: context,
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                      ),
                      Sized(height: 0.005),
                      smallText(
                        title: 'My all chats.',
                        color: secondaryTextColor.withOpacity(0.85),
                        fontWeight: FontWeight.w500,
                      ),
                      Sized(height: 0.005),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          color: pictureColor,
          child: StreamBuilder<QuerySnapshot>(
            stream: fireStore
                .collection(chatsCollection)
                .where('user', arrayContains: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CustomIndicator();
              } else if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: mediumText(title: 'No Chats yet'),
                );
              } else if (snapshot.hasData) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    String otherUserId = (data['sender_id'] == userId)
                        ? data['receiver_id']
                        : data['sender_id'];
                    return FutureBuilder<DocumentSnapshot>(
                      future: fireStore.collection(usersCollection).doc(otherUserId).get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return const ListTile(
                            leading: Icon(Icons.person),
                          );
                        } else if (userSnapshot.hasData) {
                          var userData = userSnapshot.data!;
                          String receiverName = userData['name']; // Assuming 'name' exists
                          String receiverId = userData['userId']; // Assuming 'name' exists
                          String receiverToken = userData['token']; // Assuming 'name' exists
                          return Container(
                            margin: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: sliderEditColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              trailing: Icon(Icons.arrow_forward_ios,color: whiteColor.withOpacity(0.5),size: 15,),
                              leading: const  Icon(Icons.person,color: whiteColor,),
                              title: mediumText(title: toTitleCase(receiverName),color: whiteColor),
                              onTap: () {
                               Get.to(()=> MessageScreen(receiverId: receiverId, receiverName: receiverName, receiverToken: receiverToken, userId: userId));
                              },
                            ),
                          );
                        } else {
                          return const ListTile(
                            title: Text('Error loading user'),
                          );
                        }
                      },
                    );
                  },
                );
              } else {
                return Center(
                  child: mediumText(title: 'Please check internet'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

