import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/consts/images_path.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import '../consts/colors.dart';
import '../controllers/user_profile_controller.dart';
import '../reusbale_widget/customLeading.dart';
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
    return BgWidget(
      child: Scaffold(
        backgroundColor: transparentColor,
        appBar: AppBar(
          leading: CustomLeading(),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 55),
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
                        title: 'Edit Profile',
                        context: context,
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                      ),
                      Sized(height: 0.005),
                      smallText(
                        title: 'Enter Your Valid Information .',
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
          color: whiteColor,
          child: SingleChildScrollView(
            physics:const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Sized(height: 0.04),
                Obx((){
                 if (controller.image.value != null) {
                   return  Container(
                     clipBehavior: Clip.antiAlias,
                     height: MediaQuery.of(context).size.height * 0.15,
                     width: MediaQuery.of(context).size.width * 0.3,
                     decoration: BoxDecoration(
                       color: tCardColor,
                       shape: BoxShape.circle,
                       border: Border.all(
                         strokeAlign: BorderSide.strokeAlignOutside,
                         color: tCardColor,
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
                       color: tCardColor,
                       shape: BoxShape.circle,
                       border: Border.all(
                         strokeAlign: BorderSide.strokeAlignOutside,
                         color: tCardColor,
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
                   return Container(
                       clipBehavior: Clip.antiAlias,
                       height: MediaQuery.of(context).size.height * 0.15,
                       width: MediaQuery.of(context).size.width * 0.3,
                       decoration: BoxDecoration(
                         color: tCardColor,
                         shape: BoxShape.circle,
                         border: Border.all(
                           strokeAlign: BorderSide.strokeAlignOutside,
                           color: tCardColor,
                           width: 2,
                         ),
                         image: DecorationImage(
                           image: NetworkImage(widget.imageLink),
                           fit: BoxFit.contain,
                           isAntiAlias: true,
                         ),
                       ),
                       child: const Icon(Icons.person,color: secondaryTextFieldColor,size: 60,));
                 }
               }),
                Sized(height: 0.04),
                CustomButton(
                  onTap: (){
                    controller.pickImage();
                  },
                  title: 'Pick Image',
                ),
                Sized(height: 0.04),
                CustomTextField(
                  imagePath: personIcon,
                    validate: (value) {
                      return value.isEmpty ? 'Username field is required': null ;
                    },
                    controller: controller.nameController,
                    hintText: 'Username',
                  title: 'Username',
                ),
                Sized(height: 0.04),
                CustomTextField(
                  imagePath: phoneIcon,
                  validate: (value) {
                    return value.isEmpty ? 'Phone Number field is required': null ;
                  },
                  controller:  controller.phoneNumberController,
                  hintText: 'Phone',
                  title: 'Phone',
                  keyboardType: TextInputType.phone,
                ),
                Sized(height: 0.04),
                CustomTextField(
                  imagePath: addressIcon,
                    validate: (value) {
                      return value.isEmpty ? 'Address field is required': null ;
                    },
                    controller:  controller.locationController,
                    hintText: 'Address',
                  title: 'Address',
                ),
                Sized(height: 0.04),
                Obx(() => controller.isLoading.value == true ? const Center(child:CustomIndicator(width: 0.07)): CustomButton(
                  onTap: (){
                    controller.updateUserProfile(imageLink: widget.imageLink, userId: widget.userId, context: context);
                  },
                  title: 'Update Profile',
                ),),
                Sized(height: 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
