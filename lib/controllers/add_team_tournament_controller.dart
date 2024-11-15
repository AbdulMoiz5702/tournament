
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/consts/images_path.dart';
import '../consts/colors.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';
import '../reusbale_widget/toast_class.dart';
import 'call_controller.dart';

class AddTeamTournamentController extends GetxController {


  var controller = Get.find<ZegoCloudController>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    teamLeaderName = TextEditingController(text: controller.userName);
    teamLeaderPhoneNumber = TextEditingController(text: controller.phoneNumber);
    teamLocation = TextEditingController(text: controller.location);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    teamLocation.dispose();
    teamLeaderPhoneNumber.dispose();
    teamLocation.dispose();
    nameController.dispose();
  }

  var nameController = TextEditingController();
  late TextEditingController teamLeaderName ;
  late TextEditingController teamLeaderPhoneNumber ;
  late TextEditingController teamLocation ;
  var isLoading = false.obs ;
  var newRegisterTeam =0.obs;
  var selectedImage = Rxn<String>();

  incrementTeams({required String tournamentId,required BuildContext context }) async {
    try{
      isLoading(true) ;
      await fireStore.collection(tournamentsCollection).doc(tournamentId).update({'registerTeams':newRegisterTeam.value,
      }).timeout(const Duration(seconds: 5),onTimeout: (){
        isLoading(false);
        ToastClass.showToastClass(context: context, message: "request time out");
      }).then((value){
        isLoading(false);
      });
    }catch(e){
      isLoading(false);
      ToastClass.showToastClass(context: context, message: "something went wrong");
    }
  }

  selectImage(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor:primaryTextColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: primaryTextColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
          ),
          height: MediaQuery.sizeOf(context).height * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Sized(height: 0.03,),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: primaryTextColor,
                  ),
                  child: mediumText(title: 'Select Team Avatar',color: whiteColor,context: context)),
              Sized(height: 0.03,),
              Container(
                  color: primaryTextColor,
                  height: MediaQuery.sizeOf(context).height * 0.35,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: Row(
                      children: List.generate(imagesListOther.length, (index) {
                        return GestureDetector(
                          onTap: (){
                            selectedImage.value = imagesListOther[index];

                            Navigator.pop(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                height: MediaQuery.sizeOf(context).height * 0.15,
                                width: MediaQuery.sizeOf(context).width * 0.3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: secondaryTextColor,
                                    image: DecorationImage(image: AssetImage(imagesListOther[index]),fit: BoxFit.cover)
                                ),),
                              Sized(height: 0.02,),
                              Container(
                                  margin: EdgeInsets.only(left: 5),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
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

  addTeam({required String tournamentId,required String userId,required BuildContext context}) async {
    try {
      isLoading(true);
      final String name = nameController.text;
      await fireStore.collection(teamsCollection).add({
        'name': name,
        'teamLeader':teamLeaderName.text.toString(),
        'teamLeaderNumber':teamLeaderPhoneNumber.text.toString(),
        'teamResult':'none',
        'teamLocation':teamLocation.text.toString(),
        'tournamentId': tournamentId,
        'userId':userId,
        'imageLink':selectedImage.toString(),
        'roundsQualify':'none',
        'token':userToken,
      }).then((value){
        nameController.clear();
        teamLeaderName.clear();
        teamLocation.clear();
        teamLeaderPhoneNumber.clear();
        isLoading(false);
        incrementTeams(tournamentId: tournamentId, context: context);
        Navigator.pop(context);

      });
    } catch (error) {
      isLoading(false);
      ToastClass.showToastClass(context: context, message: 'Something went wrong Error :$error');
    }
  }






}