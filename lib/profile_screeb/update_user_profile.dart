import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tournemnt/reusbale_widget/customLeading.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';

import '../consts/colors.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String email;
  final String phone;
  final String location;
  final String myRole;
  final String imageLink;

  UpdateProfileScreen({
    required this.userId,
    required this.location,
    required this.email,
    required this.phone,
    required this.userName,
    required this.myRole,
    required this.imageLink,
  });

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _locationController;
  String? myRole;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  List<String> roles = [
    'Bowler',
    'Batsman',
    'Opener',
    'FastBowler',
    'Hitter',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _phoneNumberController = TextEditingController(text: widget.phone);
    _locationController = TextEditingController(text: widget.location);
    FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>;
        _nameController.text = userData['name'] ?? widget.userName;
        myRole = userData['myRole'] ?? widget.myRole;
        _phoneNumberController.text = userData['phoneNumber'] ?? widget.phone;
        _locationController.text = userData['location'] ?? widget.location;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('profile_images').child('${widget.userId}.jpg');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> updateUserProfile() async {
    String? imageUrl = widget.imageLink;
    if (_image != null) {
      imageUrl = await uploadImage(_image!);
    }
    final updatedData = {
      'name': _nameController.text.trim(),
      'myRole': myRole,
      'phoneNumber': _phoneNumberController.text.trim(),
      'location': _locationController.text.trim(),
      'imageLink': imageUrl,
    };

    try {
      isLoading = true ;
      setState(() {});
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .update(updatedData);
      ToastClass.showToastClass(
          context: context, message: 'Profile updated successfully');
      Navigator.pop(context);
    } catch (error) {
      isLoading = false ;
      setState(() {});
      ToastClass.showToastClass(
          context: context, message: 'Failed to update profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: true,
        title: largeText(title: 'Update Profile', context: context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Sized(height: 0.02),
            if (_image != null)
              Container(
                clipBehavior: Clip.antiAlias,
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: secondaryWhiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: secondaryTextFieldColor,
                      width: 3,
                    ),
                  ),
                  child: Image.file(_image!,isAntiAlias: true,fit: BoxFit.cover,),)
            else if (widget.imageLink == 'none')
              const Icon(Icons.person,color: secondaryTextFieldColor,size: 60,)
            else if (widget.imageLink.isNotEmpty)
                Container(
                  clipBehavior: Clip.antiAlias,
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: secondaryWhiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      strokeAlign: BorderSide.strokeAlignOutside,
                      color: secondaryTextFieldColor,
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(widget.imageLink),
                      fit: BoxFit.contain,
                      isAntiAlias: true,
                    ),
                  ),
                )
            else
                const Icon(Icons.person,color: secondaryTextFieldColor,size: 60,),
            Sized(height: 0.02),
            CustomButton(
              onTap: pickImage,
              title: 'Pick Image',
            ),
            Sized(height: 0.02),
            CustomTextField(
                validate: (value) {
                  if (value.isEmpty || value == '') {
                    return 'Username field is required';
                  }
                },
                controller: _nameController,
                hintText: 'Username',
              title: 'Username',
            ),
            Sized(height: 0.02),
            CustomTextField(
              validate: (value) {
                if (value.isEmpty || value == '') {
                  return 'Phone Number field is required';
                }
              },
              controller: _phoneNumberController,
              hintText: 'Phone',
              title: 'Phone',
              keyboardType: TextInputType.phone,
            ),
            Sized(height: 0.02),
            CustomTextField(
                validate: (value) {
                  if (value.isEmpty || value == '') {
                    return 'Address field is required';
                  }
                },
                controller: _locationController,
                hintText: 'Address',
              title: 'Address',
            ),
            Sized(height: 0.02),
            Align(
                alignment: Alignment.centerLeft,
                child: smallText(
                    title: 'My Role in Team:',
                    context: context,
                    fontSize: 10,
                    color: blueColor)),
            Sized(height: 0.01),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(roles.length, (index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setState(() {
                        myRole = roles[index];
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Chip(
                        autofocus: true,
                        backgroundColor: myRole == roles[index]
                            ? blueColor// Highlight selected role
                            : secondaryWhiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        label: smallText(
                            title: roles[index],
                            context: context,
                            fontSize: 10,
                            color:myRole == roles[index] ?  whiteColor : secondaryTextColor
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Sized(height: 0.03),
           isLoading == true ? Center(child: CircularProgressIndicator(color: blueColor,),): CustomButton(
              onTap: updateUserProfile,
              title: 'Update Profile',
            ),
          ],
        ),
      ),
    );
  }
}
