import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import '../consts/colors.dart';
import '../controllers/user_profile_controller.dart';
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

  var controller = Get.put(UserprofileController());


  @override
  void initState() {
    super.initState();
    controller.nameController = TextEditingController(text: widget.userName);
    controller.phoneNumberController = TextEditingController(text: widget.phone);
    controller.locationController = TextEditingController(text: widget.location);
    FirebaseFirestore.instance.collection(usersCollection).doc(widget.userId).get().then((snapshot) {
      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>;
        controller.nameController.text = userData['name'] ?? widget.userName;
        controller.myRole = userData['myRole'] ?? widget.myRole;
        controller.phoneNumberController.text = userData['phoneNumber'] ?? widget.phone;
        controller.locationController.text = userData['location'] ?? widget.location;
      }
    });
  }

  @override
  void dispose() {
    controller.nameController.dispose();
    controller.phoneNumberController.dispose();
    controller.locationController.dispose();
    super.dispose();
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
           Obx((){
             if (controller.image.value != null) {
               return  Container(
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
                 child: Image.file(controller.image.value!,isAntiAlias: true,fit: BoxFit.contain,),);
             } else if (widget.imageLink == 'none'){
               return   const Icon(Icons.person,color: secondaryTextFieldColor,size: 60,);
             } else if (widget.imageLink.isNotEmpty){
               return Container(
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
               );
             } else{
               return const Icon(Icons.person,color: secondaryTextFieldColor,size: 60,);
             }
           }),
            Sized(height: 0.02),
            CustomButton(
              onTap: (){
                controller.pickImage();
              },
              title: 'Pick Image',
            ),
            Sized(height: 0.02),
            CustomTextField(
                validate: (value) {
                  return value.isEmpty ? 'Username field is required': null ;
                },
                controller: controller.nameController,
                hintText: 'Username',
              title: 'Username',
            ),
            Sized(height: 0.02),
            CustomTextField(
              validate: (value) {
                return value.isEmpty ? 'Phone Number field is required': null ;
              },
              controller:  controller.phoneNumberController,
              hintText: 'Phone',
              title: 'Phone',
              keyboardType: TextInputType.phone,
            ),
            Sized(height: 0.02),
            CustomTextField(
                validate: (value) {
                  return value.isEmpty ? 'Address field is required': null ;
                },
                controller:  controller.locationController,
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
                children: List.generate( controller.roles.length, (index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setState(() {
                        controller.myRole.value =  controller.roles[index];
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: Chip(
                        autofocus: true,
                        backgroundColor:  controller.myRole.value ==  controller.roles[index]
                            ? blueColor// Highlight selected role
                            : secondaryWhiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        label: smallText(
                            title:  controller.roles[index],
                            context: context,
                            fontSize: 10,
                            color: controller.myRole.value ==  controller.roles[index] ?  whiteColor : secondaryTextColor
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Sized(height: 0.03),
            Obx(() => controller.isLoading.value == true ? Center(child: const CustomIndicator(width: 0.07)): CustomButton(
              onTap: (){
                controller.updateUserProfile(imageLink: widget.imageLink, userId: widget.userId, context: context);
              },
              title: 'Update Profile',
            ),),
          ],
        ),
      ),
    );
  }
}
