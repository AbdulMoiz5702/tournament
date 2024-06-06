import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';

class AddChallengeScreen extends StatefulWidget {
  final String userId;
  AddChallengeScreen({required this.userId});

  @override
  State<AddChallengeScreen> createState() => _AddChallengeScreenState();
}

class _AddChallengeScreenState extends State<AddChallengeScreen> {
  final TextEditingController teamName = TextEditingController();

  final TextEditingController captainName = TextEditingController();

  final TextEditingController location = TextEditingController();

  final TextEditingController leaderPhone = TextEditingController();

  final TextEditingController matchOvers = TextEditingController();

  final TextEditingController startDateController = TextEditingController();
 // Add this controller for the start date
  DateTime? selectedDate;

  bool isLoading = false ;
  String? selectedImage;
  final key = GlobalKey<FormState>();

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

  void _addChallenge(BuildContext context) {
    String title = teamName.text;
    String description = captainName.text;
    if (title.isNotEmpty && description.isNotEmpty) {
      isLoading = true;
      setState(() {});
      FirebaseFirestore.instance.collection('challenges').add({
        'challengerTeamName': title,
        'teamLeaderName': description,
        'location':location.text.toString(),
        'challengerLeaderPhone':leaderPhone.text.toString(),
        'Overs':matchOvers.text.toString(),
        'isChallengeAccepted':'false',
        'teamCount': 1, // Initialize team count to 1
        'challenger': widget.userId,
        'startDate': selectedDate.toString(), // Initialize with placeholder name
        'imagePath':selectedImage.toString(),
      }).then((value) {
        isLoading = false;
        setState(() {});
        ToastClass.showToastClass(context: context, message: 'Challenge added successfully');
        Navigator.of(context).pop();
      }).catchError((error) {
        isLoading = false;
        setState(() {});
        ToastClass.showToastClass(context: context, message: 'Failed to add challenge: $error');
      });
    } else {
      isLoading = false;
      setState(() {});
     ToastClass.showToastClass(context: context, message: 'Please fill all fields');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        startDateController.text = "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
      });
    }
  }

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
              Sized(height: 0.03,),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: secondaryWhiteColor,
                  ),
                  child: mediumText(title: 'Challenge Preference Team',color: blueColor,context: context)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: largeText(title: 'Add Challenge',context: context),
      ),
      body: Padding(
        padding:const  EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Sized(height: 0.03,),
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
                Sized(height: 0.03,),
                CustomTextField(controller: teamName, hintText: 'Team Name',validate: (value){
                  return value.isEmpty ? 'Enter  Team Name': null ;
                },title: 'Team Name',),
                Sized(height: 0.03,),
                CustomTextField(validate: (value){
                  return value.isEmpty ? 'Enter  Challenger Name': null ;
                },controller: captainName, hintText: 'Challenger Name',title: 'Challenger Name',),
                Sized(height: 0.03,),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter Phone No': null ;
                  },
                  controller: leaderPhone, hintText: 'Phone No',keyboardType: TextInputType.number,title: 'Phone No',),
                Sized(height: 0.03,),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter Address': null ;
                  },
                  controller: location, hintText: 'Address',keyboardType: TextInputType.streetAddress,title: 'Address',),
                Sized(height: 0.03,),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter Overs': null ;

                  },
                  controller: matchOvers, hintText: 'Overs',keyboardType: TextInputType.number,title: 'Overs',),
                Sized(height: 0.03,),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: AbsorbPointer(
                    child: CustomTextField(
                      validate: (value){
                        return value.isEmpty ? 'Enter Start Date': null ;

                      },
                      controller: startDateController,
                      hintText: 'Date',
                      title: 'Date',
                    ),
                  ),
                ),
                Sized(height: 0.05,),
                isLoading == true ? const Center(child: CircularProgressIndicator(color: blueColor,)):CustomButton(
                  onTap: () {
                    if(key.currentState!.validate()){
                      if(selectedImage != null && selectedImage!.isNotEmpty){
                        _addChallenge(context);
                      }else{
                        ToastClass.showToastClass(context: context, message: 'Please Select your Challenger Icon');
                      }
                    }else{
                      ToastClass.showToastClass(context: context, message: 'Please Fill all the Fields');
                    }
                  } ,
                  title: 'Add Challenge',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

