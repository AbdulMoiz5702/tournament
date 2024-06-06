// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';
import '../reusbale_widget/custom_sizedBox.dart';

class AddTournamentPage extends StatefulWidget {
  final String userId;
  AddTournamentPage({required this.userId});
  @override
  State<AddTournamentPage> createState() => _AddTournamentPageState();
}

class _AddTournamentPageState extends State<AddTournamentPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController organizerName = TextEditingController();
  final TextEditingController tournamentOvers = TextEditingController();
  final TextEditingController organizerPhoneNumber = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController tournamentFee = TextEditingController();
  final TextEditingController startDateController = TextEditingController(); // Add this controller for the start date
  final TextEditingController totalTeamController = TextEditingController();
  DateTime? selectedDate; // Variable to hold the selected date
  bool isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       automaticallyImplyLeading: true,
        centerTitle: false,
        title: largeText(title: 'Add Tournament', context: context,color: secondaryTextColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.16,
                      width: MediaQuery.sizeOf(context).width * 0.6,
                      child: Column(
                        children: [
                          CustomTextField(
                            validate: (value){
                              return value.isEmpty ? 'Enter  Organizer Name ': null ;
                            },
                            controller: organizerName,
                            hintText: 'Organizer Name',
                            title: 'Organizer Name',
                          ),
                          Sized(height: 0.02),
                          CustomTextField(
                            validate: (value){
                              return value.isEmpty ? 'Enter  Phone number': null ;
                            },
                            controller: organizerPhoneNumber,
                            hintText: 'Phone number',
                            keyboardType: TextInputType.number,
                            title: 'Phone number',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Sized(height: 0.02),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter  Tournament Name ': null ;
                  },
                  controller: nameController,
                  hintText: 'Tournament name',
                  title: 'Tournament name',
                ),
                Sized(height: 0.02),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter  Fee': null ;
                  },
                  controller: tournamentFee,
                  hintText: 'Tournament Fee',
                  keyboardType: TextInputType.number,
                  title: 'Tournament Fee',
                ),
                Sized(height: 0.02),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter  Overs': null ;
                  },
                  controller: tournamentOvers,
                  hintText: 'Tournament Overs',
                  keyboardType: TextInputType.number,
                  title: 'Overs',
                ),
                Sized(height: 0.02),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter  Total Teams': null ;
                  },
                  controller: totalTeamController,
                  hintText: 'Maximum Teams',
                  keyboardType: TextInputType.number,
                  title: 'Maximum Teams',
                ),
                Sized(height: 0.02),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter  Location': null ;
                  },
                  controller: location,
                  hintText: 'Tournament Location',
                  title: 'Tournament Location',
                ),
                Sized(height: 0.02),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: AbsorbPointer(
                    child: CustomTextField(
                      validate: (value){
                        return value.isEmpty ? 'Enter  Start date ': null ;
                      },
                      controller: startDateController,
                      hintText: 'Date',
                      title: 'Date',
                    ),
                  ),
                ),
                Sized(height: 0.02),
                isLoading == true ? const Center(child: CircularProgressIndicator(color: blueColor,),):CustomButton(
                  title: 'Register tournament',
                  onTap: () {
                    if(key.currentState!.validate()){
                      if(selectedImage != null && selectedImage!.isNotEmpty){
                        addTournament();
                      }else{
                        ToastClass.showToastClass(context: context, message: 'Please Select your Tournament Icon');
                      }
                    }else{
                      ToastClass.showToastClass(context: context, message: 'Please Fill all the Fields');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  void addTournament() async {
    try {
      isLoading = true;
      setState(() {});
      final String name = nameController.text;
      await FirebaseFirestore.instance.collection('Tournaments').add({
        'name': name,
        'organizerName': organizerName.text.toString(),
        'tournamentOvers': tournamentOvers.text.toString(),
        'tournamentFee': tournamentFee.text.toString(),
        'organizerPhoneNumber': organizerPhoneNumber.text.toString(),
        'location': location.text.toString(),
        'startDate': selectedDate.toString(), // Add selected date to Firestore
        'organizer_UserID': widget.userId,
        'isCompleted': 'false',
        'totalTeams':int.parse(totalTeamController.text.toString()),
        'registerTeams':0,
        'imagePath':selectedImage.toString(),
      }).then((value) => {
      isLoading = false,
      setState(() {}),
        ToastClass.showToastClass(context: context, message: 'Tournament Added successfully'),
        Navigator.pop(context),
      });
    } catch (error) {
    isLoading = false;
    setState(() {});
      ToastClass.showToastClass(context: context, message: 'Tournament Added Failed $error');
    }
  }
}
