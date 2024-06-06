// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/reusbale_widget/customLeading.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/custom_textfeild.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/toast_class.dart';



class AddTeamPage extends StatefulWidget {
  final String tournamentId;
  final String userId;
  final int registerTeams ;

  AddTeamPage({required this.tournamentId,required this.userId,required this.registerTeams});

  @override
  State<AddTeamPage> createState() => _AddTeamPageState();
}

class _AddTeamPageState extends State<AddTeamPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController teamLeaderName = TextEditingController();
  final TextEditingController teamLeaderPhoneNumber = TextEditingController();
  final TextEditingController teamLocation = TextEditingController();
  bool isLoading = false ;
  int newRegisterTeam =0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newRegisterTeam = widget.registerTeams +1 ;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    teamLeaderName.dispose();
    teamLocation.dispose();
    teamLeaderPhoneNumber.dispose();
  }

  void startTournament() async {
    try{
      isLoading = true ;
      setState(() {});
      await FirebaseFirestore.instance
          .collection('Tournaments')
          .doc(widget.tournamentId)
          .update({
        'registerTeams':newRegisterTeam,
      }).timeout(const Duration(seconds: 5),onTimeout: (){
        isLoading = false ;
        ToastClass.showToastClass(context: context, message: "request time out");
        setState(() {});
      }).then((value){
        isLoading = false ;
        ToastClass.showToastClass(context: context, message: "Tournament started!");
        setState(() {});
      });
    }catch(e){
      isLoading = false ;
      ToastClass.showToastClass(context: context, message: "something went wrong");
      setState(() {});
    }
  }

  String? selectedImage;

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

  final key = GlobalKey<FormState>();

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
        centerTitle: false,
        automaticallyImplyLeading: true,
        title: largeText(title: 'Add Team',context: context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                Sized(height: 0.03,),
                CustomTextField(
                    validate: (value){
                      return value.isEmpty ? 'Enter  Team Name': null ;
                    },
                    controller: nameController, hintText: 'Team Name',
                  title: 'Team Name',
                ),
                Sized(height:0.03,),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter  Leader Name': null ;
                  },
                  controller: teamLeaderName, hintText: 'Team Leader Name',keyboardType: TextInputType.name,title: 'Team Leader Name',),
                Sized(height:0.03,),
                CustomTextField(
                  validate: (value){
                    return value.isEmpty ? 'Enter  Phone No': null ;
                  },
                  controller: teamLeaderPhoneNumber, hintText: 'Phone No',keyboardType: TextInputType.number,title: 'Phone No',),
                Sized(height:0.03,),
                CustomTextField(
                    validate: (value){
                      return value.isEmpty ? 'Enter  Location': null ;
                    },
                    controller: teamLocation, hintText: 'Team location',title: 'Team location',),
                Sized(height:0.03,),
                isLoading == true ? CircularProgressIndicator(color: blueColor,) :CustomButton(title: 'Register Team', onTap: (){
                  if(key.currentState!.validate()){
                    if(selectedImage != null && selectedImage!.isNotEmpty){
                      addTeam();
                    }else{
                      ToastClass.showToastClass(context: context, message: 'Please Select your Team Icon');
                    }
                  }else{
                    ToastClass.showToastClass(context: context, message: 'Please Fill all the Fields');
                  }
               }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addTeam() async {
    try {
      isLoading = true ;
      setState(() {});
      final String name = nameController.text;
      await FirebaseFirestore.instance.collection('Teams').add({
        'name': name,
        'teamLeader':teamLeaderName.text.toString(),
        'teamLeaderNumber':teamLeaderPhoneNumber.text.toString(),
        'teamResult':'none',
        'teamLocation':teamLocation.text.toString(),
        'tournamentId': widget.tournamentId,
        'userId':widget.userId,
        'imageLink':selectedImage.toString(),
        'roundsQualify':'none',
      }).then((value){
        isLoading = false ;
        setState(() {});
        startTournament();
        Navigator.pop(context);
        throw ToastClass.showToastClass(context: context, message: 'Team register in tournament successfully');
      });
    } catch (error) {
      isLoading = false ;
      setState(() {});
     throw ToastClass.showToastClass(context: context, message: 'Something went wrong Error :$error');
    }
  }
}