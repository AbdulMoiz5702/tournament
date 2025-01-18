import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../consts/firebase_consts.dart';
import '../reusbale_widget/toast_class.dart';

class UserprofileController extends GetxController {




  late TextEditingController nameController;
  late TextEditingController phoneNumberController;
  late TextEditingController locationController;
  var myRole = Rxn<String>();
  var image = Rxn<File>();
  var picker = ImagePicker().obs;
  var isLoading = false.obs;

  List<String> roles = [
    'Bowler',
    'Batsman',
    'Opener',
    'FastBowler',
    'Hitter',
  ];

  pickImage() async {
    final pickedFile = await picker.value.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
        image.value = File(pickedFile.path);
    }
  }

  uploadImage({required File image,required userId}) async {
    try {
      final storageRef = firebaseStorage.ref().child('profile_images').child('$userId.jpg');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  updateUserProfile({required String imageLink,required userId,required BuildContext context}) async {
    String? imageUrl = imageLink;
    if (image.value != null) {
      imageUrl = await uploadImage(image: image.value!,userId: userId);
    }
    final updatedData = {
      'name': nameController.text.trim(),
      'phoneNumber': phoneNumberController.text.trim(),
      'location': locationController.text.trim(),
      'imageLink': imageUrl,
      'token':userToken,
    };
    try {
      isLoading(true);
      await fireStore.collection(usersCollection).doc(userId).update(updatedData);
      isLoading(false);
      Navigator.pop(context);
    } catch (error) {
      isLoading(false);
      ToastClass.showToastClass(context: context, message: 'Failed to update profile: $error');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
    locationController.dispose();
  }

}