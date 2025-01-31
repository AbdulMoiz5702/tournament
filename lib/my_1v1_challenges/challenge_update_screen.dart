import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/1v1_challenges/challenge-type_selection.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/customLeading.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import '../../consts/colors.dart';
import '../../consts/images_path.dart';
import '../../reusbale_widget/custom_button.dart';
import '../../reusbale_widget/custom_text_form_feild.dart';
import '../../reusbale_widget/custom_textfeild.dart';
import '../controllers/User_Challenges_controller.dart';


class UpdateChallengePage extends StatefulWidget {
  final dynamic challenge;
  UpdateChallengePage({required this.challenge});
  @override
  _UpdateChallengePageState createState() => _UpdateChallengePageState();
}

class _UpdateChallengePageState extends State<UpdateChallengePage> {
  var controller = Get.put(UserChallengesController());
// Function to format time
  String formatTime(dynamic startTime) {
    if (startTime is Timestamp) {
      var date = startTime.toDate();
      return DateFormat('h:mm a').format(date);
    } else if (startTime is String) {
      // Assume format "TimeOfDay(18:30)"
      RegExp regex = RegExp(r'TimeOfDay\((\d+):(\d+)\)');
      var match = regex.firstMatch(startTime);
      if (match != null) {
        int hour = int.parse(match.group(1)!);
        int minute = int.parse(match.group(2)!);
        TimeOfDay time = TimeOfDay(hour: hour, minute: minute);
        final now = DateTime.now();
        final dateTime = DateTime(
            now.year, now.month, now.day, time.hour, time.minute);
        return DateFormat('h:mm a').format(dateTime);
      }
    }
    return ''; // Default return if neither Timestamp nor valid String
  }

  @override
  void initState() {
    super.initState();
    DateTime date = DateTime.parse(widget.challenge['startDate']);
    String formattedDate = DateFormat('dd MMM yyyy').format(date);
    controller.startDateController.text = formattedDate; // For UI
    controller.selectedDate.value = date; // Original date for database
    controller.teamName.value = widget.challenge['challengerTeamName'];
    controller.captainName.value = widget.challenge['teamLeaderName'];
    controller.leaderPhone.value = widget.challenge['challengerLeaderPhone'];
    controller.over.value = widget.challenge['Over'];
    controller.age.value = widget.challenge['age'];
    controller.area.value =  widget.challenge['area'];
    controller.challengeType.text = '${widget.challenge['Over']} | ${widget.challenge['age']} | ${widget.challenge['area']}';
    controller.location.value = widget.challenge['location'];
    controller.startDateTimeController.text = formatTime(widget.challenge['startTime']);
  }


  @override
  Widget build(BuildContext context) {
    return BgWidget(
      child: Scaffold(
        backgroundColor: transparentColor,
        appBar: AppBar(
          leading: const CustomLeading(),
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
                        title: 'Edit Challenge Info',
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
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
          color: whiteColor,
          child: Form(
            key: controller.formKey,
            child: ListView(
              physics: const  BouncingScrollPhysics(),
              cacheExtent: 0,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Sized(height: 0.03,),
                CustomTextFormField(
                  initialValue: controller.teamName.value,
                  labelText: 'Name',
                  onSaved: (value) => controller.teamName.value = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                ),
                Sized(height: 0.03,),
                CustomTextFormField(
                  initialValue: controller.captainName.value,
                  labelText: 'Organizer Name',
                  onSaved: (value) => controller.captainName.value = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter the organizer name' : null,
                ),
                Sized(height: 0.03,),
                CustomTextFormField(
                  initialValue:  controller.leaderPhone.value,
                  labelText: 'Organizer Phone Number',
                  onSaved: (value) =>  controller.leaderPhone.value = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter the organizer phone number' : null,
                ),
                Sized(height: 0.03,),
                CustomTextField(
                  showLeading: false,
                  isDense: true,
                  onTap: (){
                    Get.to(()=> ChallengeTypeSelection(controller: controller,));
                  },
                  imagePath: personIcon,
                  validate: (value){
                    return value.isEmpty ? 'Enter  Challenge Type': null ;
                  },
                  controller: controller.challengeType,
                  hintText: 'Challenge Type ',
                  keyboardType: TextInputType.text,
                  title: 'Challenge Type ',
                ),
                Sized(height: 0.03,),
                CustomTextFormField(
                  initialValue: controller.location.value,
                  labelText: 'Location',
                  onSaved: (value) => controller.location.value = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter the location' : null,
                ),
                Sized(height: 0.03,),
                GestureDetector(
                  onTap: () {
                    controller.selectDate(context);
                  },
                  child: AbsorbPointer(
                    child: CustomTextField(
                      showLeading: false,
                      imagePath: dateIcon,
                      validate: (value){
                        return value.isEmpty ? 'Enter  Start date ': null ;
                      },
                      controller: controller.startDateController,
                      hintText: 'Start Date',
                      title: 'Start Date',
                    ),
                  ),
                ),
                Sized(height: 0.03,),
                GestureDetector(
                  onTap: () {
                    controller.selectTime(context);
                  },
                  child: AbsorbPointer(
                    child: CustomTextField(
                      showLeading: false,
                      imagePath: timeIcon,
                      validate: (value){
                        return value.isEmpty ? 'Enter  Match time ': null ;
                      },
                      controller: controller.startDateTimeController,
                      hintText: 'Match time ',
                      title: 'Match time ',
                    ),
                  ),
                ),
                Sized(height: 0.04,),
                Obx(() => controller.isLoading.value == true ? const Center(child:  CustomIndicator()) :CustomButton(title: 'Update', onTap: (){
                  controller.updateChallenge(challengeId: widget.challenge.id,context: context);
                }),),
                Sized(height: 0.04,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

