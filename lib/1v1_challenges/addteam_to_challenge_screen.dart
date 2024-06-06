import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';

import '../consts/colors.dart';
import '../reusbale_widget/custom_sizedBox.dart';

class AddTeamToChallengeScreen extends StatefulWidget {
  final String challengeId;
  final String userId ;

  AddTeamToChallengeScreen(this.challengeId,this.userId);

  @override
  State<AddTeamToChallengeScreen> createState() => _AddTeamToChallengeScreenState();
}

class _AddTeamToChallengeScreenState extends State<AddTeamToChallengeScreen> {
  final TextEditingController teamNameController = TextEditingController();

  final TextEditingController location = TextEditingController();

  final TextEditingController teamLeaderPhone = TextEditingController();

  final TextEditingController teamLeaderName = TextEditingController();

  String? selectedImage;
  final key = GlobalKey<FormState>();

  bool isLoading = false ;

  List<String> imagesList = [
    'assets/images/location.png',
    'assets/images/leader.png',
    'assets/images/phone.png',
    'assets/images/team.png',
    'assets/images/shedule.png',
  ];

  List<String> teamsTypesNameList = [
    'Batting',
    'Bowling',
    'Fielding',
    'All Rounders',
    'Adaptability',
  ];

  Future<void> _selectImage(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor: whiteColor,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.sizeOf(context).height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: secondaryWhiteColor,
                  ),
                  child: mediumText(title: 'Tournament Preference Team',color: blueColor,context: context)),
              Sized(height: 0.03,),
              Container(
                  height: MediaQuery.sizeOf(context).height * 0.3,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: Row(
                      children: List.generate(imagesList.length, (index) {
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              selectedImage = imagesList[index];
                            });
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: [
                              Container(
                                height: MediaQuery.sizeOf(context).height * 0.05,
                                width: MediaQuery.sizeOf(context).width * 0.2,
                                decoration: BoxDecoration(
                                    image: DecorationImage(image: AssetImage(imagesList[index]))
                                ),),
                              Sized(height: 0.02,),
                              Container(
                                  margin: EdgeInsets.only(left: 5),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: secondaryTextFieldColor,
                                  ),
                                  child: smallText(title: teamsTypesNameList[index],context: context,color: blueColor,fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }),
                    ),
                  )
              ),
            ],
          ),
        );
      },
    );
  }

  void _addTeam(BuildContext context) {
    FirebaseFirestore.instance.collection('challenges').doc(widget.challengeId).get().then((challengeSnapshot) {
      var challengeData = challengeSnapshot.data();
      int teamCount = challengeData?['teamCount'] ?? 0;
      if (teamCount < 2) {
        String teamName = teamNameController.text;
        if (teamName.isNotEmpty) {
           isLoading = true ;
           setState(() {});
          FirebaseFirestore.instance.collection('challenges').doc(widget.challengeId).collection('teams').add({
            'teamName': teamName,
            'teamLeaderName':teamLeaderName.text.toString(),
            'teamLeaderPhone':teamLeaderPhone.text.toString(),
            'location':location.text.toString(),
            'accepterId':widget.userId,
            'imageLink':selectedImage.toString()
          }).then((value) {
            isLoading = false ;
            setState(() {});
            FirebaseFirestore.instance.collection('challenges').doc(widget.challengeId).update({
              'teamCount': teamCount + 1,
              'isChallengeAccepted':'true',
            });
            ToastClass.showToastClass(context: context, message: 'Team added successfully');
            Navigator.of(context).pop();
          }).catchError((error) {
            isLoading = false ;
            setState(() {});
            ToastClass.showToastClass(context: context, message: 'Failed to add team: $error');
          });
        } else {
          isLoading = false ;
          setState(() {});
          ToastClass.showToastClass(context: context, message: 'Please Enter All Fields');
        }
      } else {
        isLoading = false ;
        setState(() {});
        ToastClass.showToastClass(context: context, message: 'This challenge is already full');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: largeText(title: 'Add Team to Challenge',context: context),
      ),
      body: Padding(
        padding:const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: secondaryWhiteColor,
                    borderRadius: BorderRadius.circular(10),
                    image: selectedImage != null
                        ? DecorationImage(image: AssetImage(selectedImage!))
                        : null,
                  ),
                  child:  IconButton(onPressed: (){
                    _selectImage(context);
                  }, icon: Icon(Icons.camera_alt_outlined,color:blueColor,),),
                  height: MediaQuery.sizeOf(context).height * 0.16,
                  width: MediaQuery.sizeOf(context).width * 0.3,
                ),
                Sized(width: 0.03,),
                CustomTextField(
                    validate: (value){
                      return value.isEmpty ? 'Enter Team Name ': null ;
                    },
                    controller: teamNameController, hintText: 'Team Name',title: 'Team Name',),
                Sized(height: 0.03,),
                CustomTextField(
                    validate: (value){
                      return value.isEmpty ? 'Enter Leader Name ': null ;
                    },
                    controller: teamLeaderName, hintText: 'Leader Name',title: 'Leader Name',),
                Sized(height: 0.03,),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter Phone No ': null ;
                  },
                  controller: teamLeaderPhone, hintText: 'Phone No',keyboardType: TextInputType.number,title: 'Phone No',),
                Sized(height: 0.03,),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter Address': null ;
                  },
                  controller: location, hintText: 'Address',title: 'Address',),
                Sized(height: 0.05,),
                isLoading == true ?Center(child: CircularProgressIndicator(color: blueColor,)):CustomButton(
                  onTap: () {
                    if(key.currentState!.validate()){
                      if(selectedImage != null && selectedImage!.isNotEmpty){
                        _addTeam(context);
                      }else{
                        ToastClass.showToastClass(context: context, message: 'Please Select your Challenger Icon');
                      }
                    }else{
                      ToastClass.showToastClass(context: context, message: 'Please Fill all the Fields');
                    }
                  },
                  title: 'Add Team',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
