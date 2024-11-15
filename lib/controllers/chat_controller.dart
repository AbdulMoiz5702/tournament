import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:flutter/material.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';


class ChatController extends GetxController {

  var docId = ''.obs;
  FlutterSoundRecorder? _recorder;
  var isRecording = false.obs;
  DateTime? _recordingStartTime;
  var durationInSeconds = 0.obs;
  final ImagePicker picker = ImagePicker();
  var durationDuringRecording = 0.obs;
  Timer? _timer;
  var isLoading = false.obs;
  var selectedChatDocId = ''.obs;
  var selectedCMessageDocId = ''.obs;
  var isMessageSelected = false.obs;
  var messageType = 'text'.obs;
  var currentIndex = (-1).obs;
  var hasMessage = false.obs;

  changeIndex(index){
    currentIndex.value = index;
  }

  resetIndex(){
    currentIndex.value = -1;
  }


  var isEdit = false.obs;
  var editMessageText = ''.obs;
  late TextEditingController message;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    message.dispose();
  }





  @override
  void onInit() {
    super.onInit();
    _recorder = FlutterSoundRecorder();
    _requestMicrophonePermission();

    // Initialize the controller
    message = TextEditingController();

    // Listen to isEdit and update the text controller accordingly
    isEdit.listen((isEditing) {
      if (isEditing) {
        message.text = editMessageText.value;
      }
    });
  }

  void changeEditTextValue() {
    // Update the existing controller's text directly
    if (isEdit.value) {
      message.text = editMessageText.value;
    }
  }

  Future<void> _requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status.isDenied) {
      print("Microphone permission denied.");
    }
  }

  Future<void> startRecording() async {
    await _recorder!.openRecorder();
    isRecording(true);
    _recordingStartTime = DateTime.now(); // Note the start time
    // Use AAC codec for recording
    await _recorder!.startRecorder(
      toFile: 'audio_message.aac',
      enableVoiceProcessing: true,
      codec: Codec.defaultCodec,
    );
    // Start a periodic timer to update the duration every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final elapsed = DateTime.now().difference(_recordingStartTime!).inSeconds;
      durationDuringRecording.value = elapsed;
    });
  }



  Future<String?> stopRecording() async {
    if (!isRecording.value) return null;
    isRecording(false);
    _timer?.cancel();
    durationDuringRecording.value = 0;
    Duration recordingDuration = DateTime.now().difference(_recordingStartTime!);
    durationInSeconds.value  = recordingDuration.inSeconds;
    return await _recorder!.stopRecorder();
  }

  Future<String> uploadToFirebase(String filePath) async {
    File file = File(filePath);
    Reference ref = FirebaseStorage.instance.ref().child('voice_messages/${file.uri.pathSegments.last}');
    await ref.putFile(file);
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  sendFirstVoiceMessage({
    required String receiverId,
    required String senderId,
    required BuildContext context,
    required String filePath,
    required String receiverToken,
  }) async {
   try{
     isLoading(true);
     String downloadURL = await uploadToFirebase(filePath);
     var data = fireStore.collection(chatsCollection).doc();
     await data.set({
       'combine_id':'${senderId}_$receiverId',
       'last_message': 'Voice message',
       'receiver_id': receiverId,
       'sender_id': senderId,
       'receiver_token':receiverToken,
       'sender_token':userToken,
       'user': FieldValue.arrayUnion([receiverId, senderId]),
       'time': FieldValue.serverTimestamp(),
     }).then((value) async {
       docId.value = data.id;
       var messageData = fireStore.collection(chatsCollection).doc(data.id).collection(messagesCollection).doc();
       await messageData.set({
         'voice_message': downloadURL,
         'receiver_id': receiverId,
         'sender_id': senderId,
         'receiver_token':receiverToken,
         'sender_token':userToken,
         'time': FieldValue.serverTimestamp(),
         'message_type': 'voice',
         'duration':durationInSeconds.value,
         'status':false,
         'isEdit':false,
         'isSent':false,
         "isDelivered": false
       });
     });
     isLoading(false);
     durationInSeconds.value = 0;
   }on SocketException {
     isLoading(false);
     durationInSeconds.value = 0;
   }catch(e){
     isLoading(false);
   }
  }

  sendVoiceMessage({
    required String receiverId,
    required String senderId,
    required String docId,
    required BuildContext context,
    required String filePath,
    required String receiverToken,
  }) async {
    try{
      isLoading(true);
      String downloadURL = await uploadToFirebase(filePath);
      var messageData = fireStore.collection(chatsCollection).doc(docId).collection(messagesCollection).doc();
      await messageData.set({
        'voice_message': downloadURL,
        'receiver_id': receiverId,
        'sender_id': senderId,
        'receiver_token':receiverToken,
        'sender_token':userToken,
        'time': FieldValue.serverTimestamp(),
        'message_type': 'voice',
        'duration':durationInSeconds.value,
        'status':false,
        'isEdit':false,
        'isSent':false,
        "isDelivered": false
      }).then((value) async {
        var data = fireStore.collection(chatsCollection).doc(docId);
        await data.update({
          'sender_token':userToken,
          'last_message': 'Voice message',
          'time': FieldValue.serverTimestamp(),
        });
      });
      isLoading(false);
    } on SocketException {
      isLoading(false);
    }catch(e){
      isLoading(false);
    }
  }


  sendMessage({
    required String receiverId,
    required String senderId,
    required String docId,
    required BuildContext context,
    required String receiverToken,
  }) async {
    try {
      if (message.text.isEmpty) {
        ToastClass.showToastClass(context: context, message: 'Message must not be empty');
      } else {
        var messageData = fireStore.collection(chatsCollection).doc(docId).collection(messagesCollection).doc();
        await messageData.set({
          'message': message.text,
          'receiver_id': receiverId,
          'sender_id': senderId,
          'receiver_token':receiverToken,
          'sender_token':userToken,
          'time': FieldValue.serverTimestamp(),
          'message_type': 'text',
          'duration':durationInSeconds.value,
          'status':false,
          'isEdit':false,
          'isSent':false,
          "isDelivered": false
        }).then((value) async {
          message.clear();
          var data = fireStore.collection(chatsCollection).doc(docId);
          await data.update({
            'sender_token':userToken,
            'last_message': message.text,
            'time': FieldValue.serverTimestamp(),
          });
        }).then((value) async{
          await messageData.set({
            'isSent': true,
          }, SetOptions(merge: true));
        });
      }
    } catch (e) {
      print(e);
    }
  }



  Future<void> playVoiceMessage(String filePath) async {
    FlutterSoundPlayer player = FlutterSoundPlayer();
    await player.openPlayer();
    await player.startPlayer(fromURI: filePath);
  }

  sendFirstMessage({required String receiverId,required String senderId,required BuildContext context,required String receiverToken}) async {
   try{
     if(message.text.isEmpty){
       ToastClass.showToastClass(context: context, message: 'Message must not be empty');
     }else{
       var data = fireStore.collection(chatsCollection).doc();
       await data.set({
         'combine_id':'${senderId}_$receiverId',
         'last_message':message.text,
         'receiver_id':receiverId,
         'sender_id':senderId,
         'receiver_token':receiverToken,
         'sender_token':userToken,
         'user':FieldValue.arrayUnion([receiverId, senderId,]),
         'time':FieldValue.serverTimestamp(),
       }).then((value) async {
         docId.value = data.id;
         var messageData = fireStore.collection(chatsCollection).doc(data.id).collection(messagesCollection).doc();
         await messageData.set({
           'message':message.text,
           'receiver_id':receiverId,
           'sender_id':senderId,
           'receiver_token':receiverToken,
           'sender_token':userToken,
           'time':FieldValue.serverTimestamp(),
           'message_type': 'text',
           'duration':durationInSeconds.value,
           'status':false,
           'isEdit':false,
           'isSent':false,
           "isDelivered": false
         });
         message.clear();
       });
     }
   }catch(e){
     print(e);
   }
  }

  Future<void> sendPicture({
    required String receiverId,
    required String senderId,
    required String docId,
    required BuildContext context,
    required ImageSource ? source,
    required String receiverToken
  }) async {
    // Step 1: Pick Image from Gallery or Camera
    String? imageUrl = await pickAndUploadImage(context,source);
    if (imageUrl == null) {
      // Handle the case where the image picking/uploading fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image upload failed. Please try again.')),
      );
      return;
    }

    // Step 2: Save Image Data in Firestore
    var messageData = fireStore.collection(chatsCollection).doc(docId).collection(messagesCollection).doc();
    await messageData.set({
      'imageUrl': imageUrl,
      'receiver_id': receiverId,
      'sender_id': senderId,
      'receiver_token':receiverToken,
      'sender_token':userToken,
      'time': FieldValue.serverTimestamp(),
      'message_type': 'image',
      'duration':durationInSeconds.value,
      'status':false,
      'isEdit':false,
      'isSent':false,
      "isDelivered": false
    }).then((value) async {
      // Update the last message in the chat document
      var chatData = fireStore.collection(chatsCollection).doc(docId);
      await chatData.update({
        'last_message': 'Photo',
        'sender_token':userToken,
        'time': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<String?> pickAndUploadImage(BuildContext context,ImageSource ? source) async {
    if (source != null) {
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        try {
          String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
          Reference storageRef = firebaseStorage.ref().child(fileName);

          // Upload the file to Firebase Storage
          await storageRef.putFile(imageFile);

          // Get the download URL
          String imageUrl = await storageRef.getDownloadURL();
          return imageUrl;
        } catch (e) {
          print("Failed to upload image: $e");
          return null;
        }
      }
    }
    return null;
  }

  deleteMessage({required String chatDocId,required String docId}) async{
    await fireStore.collection(chatsCollection).doc(chatDocId).collection(messagesCollection).doc(docId).delete();
    isMessageSelected.value = false;
    resetIndex();
    selectedCMessageDocId.value = '';
    selectedChatDocId.value = '';
  }

  editMessage({required String chatDocId,required String docId}) async{
    var data = fireStore.collection(chatsCollection).doc(chatDocId).collection(messagesCollection).doc(docId);
    await data.update({
      'message':message.text,
      'isEdit':true,
    });
    isMessageSelected.value = false;
    resetIndex();
    selectedCMessageDocId.value = '';
    selectedChatDocId.value = '';
    isEdit.value = false;
    editMessageText.value = '';
  }

  void markMessageAsRead(String docId, String messageId) async {
    try {
      await fireStore.collection(chatsCollection).doc(docId).collection(messagesCollection).doc(messageId).update({'status': true});
    } catch (e) {
      print("Error updating message status: $e");
    }
  }

  void markMessageAsDelivered(String docId,userId) async {
    var messages = await fireStore.collection(chatsCollection)
        .doc(docId)
        .collection(messagesCollection)
        .where('isDelivered', isEqualTo: false)
        .where('receiver_id', isEqualTo: userId) // Ensure only messages for the receiver are marked
        .get();
    for (var message in messages.docs) {
      await fireStore.collection(chatsCollection)
          .doc(docId)
          .collection(messagesCollection)
          .doc(message.id)
          .update({'isDelivered': true});
    }
  }
}