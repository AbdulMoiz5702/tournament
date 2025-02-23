import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/customLeading.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import '../../consts/colors.dart';
import '../../consts/images_path.dart';
import '../../controllers/Update_Tournament_controller.dart';
import '../../models_classes.dart';
import '../../public_tournmnets/tournament_type_selection.dart';
import '../../reusbale_widget/custom_button.dart';
import '../../reusbale_widget/custom_text_form_feild.dart';
import '../../reusbale_widget/custom_textfeild.dart';
import '../../reusbale_widget/date_text_feild.dart'; // Import the new widget

class UpdateTournamentPage extends StatefulWidget {
  final Tournament tournament;
  UpdateTournamentPage({required this.tournament});
  @override
  _UpdateTournamentPageState createState() => _UpdateTournamentPageState();
}

class _UpdateTournamentPageState extends State<UpdateTournamentPage> {
  var controller = Get.put(UpdateTournamentController());
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
    DateTime date = DateTime.parse(widget.tournament.tournmentStartDate);
    String formattedDate = DateFormat('dd MMM yyyy').format(date);
    controller.startDateController.text = formattedDate; // For UI
    controller.selectedDate.value = date; // Original date for database
    controller.name.value = widget.tournament.name;
    controller.organizerName.value = widget.tournament.organizerName;
    controller.organizerPhoneNumber.value = widget.tournament.organizerPhoneNumber;
    controller.tournamentFee.value = widget.tournament.tournamentFee;
    controller.tournamentType.text = widget.tournament.tournamentOvers;
    controller.location.value = widget.tournament.location;
    controller.startDateController.text = formattedDate;
    controller.startDateTimeController.text = formatTime(widget.tournament.startTime);
    controller.totalPlayerController.text = widget.tournament.totalPlayers.toString();
    controller.totalTeamController.text = widget.tournament.totalTeam.toString();
    controller.tournamentsRules.text = widget.tournament.rules;
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
                        title: 'Edit Tournament Info',
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
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
          color: whiteColor,
          child: Form(
            key: controller.formKey,
            child: ListView(
              physics: BouncingScrollPhysics(),
              cacheExtent: 0,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Sized(height: 0.03,),
                CustomTextFormField(
                  initialValue: controller.name.value,
                  labelText: 'Name',
                  onSaved: (value) => controller.name.value = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                ),
                Sized(height: 0.03,),
                CustomTextFormField(
                  initialValue: controller.organizerName.value,
                  labelText: 'Organizer Name',
                  onSaved: (value) => controller.organizerName.value = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter the organizer name' : null,
                ),
                Sized(height: 0.03,),
                CustomTextFormField(
                  initialValue:  controller.organizerPhoneNumber.value,
                  labelText: 'Organizer Phone Number',
                  onSaved: (value) =>  controller.organizerPhoneNumber.value = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter the organizer phone number' : null,
                ),
                Sized(height: 0.03,),
                CustomTextFormField(
                  initialValue: controller.tournamentFee.value,
                  labelText: 'Tournament Fee',
                  onSaved: (value) => controller.tournamentFee.value = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter the tournament fee' : null,
                ),
                Sized(height: 0.03,),
                CustomTextField(
                  showLeading: false,
                  isDense: true,
                  onTap: (){
                    Get.to(()=> TournamentTypeSelection(controller: controller,));
                  },
                  imagePath: personIcon,
                  validate: (value){
                    return value.isEmpty ? 'Enter  Tournament Type': null ;
                  },
                  controller: controller.tournamentType,
                  hintText: 'Tournament Type ',
                  keyboardType: TextInputType.text,
                  title: 'Tournament Type ',
                ),
                Sized(height: 0.03,),
                CustomTextField(
                  showLeading: false,
                  isDense: true,
                  imagePath: personIcon,
                  validate: (value){
                    return value.isEmpty ? 'Enter Maximum Teams': null ;
                  },
                  controller: controller.totalTeamController,
                  hintText: 'Maximum Teams',
                  keyboardType: TextInputType.number,
                  title: 'Maximum Teams',
                ),
                Sized(height: 0.03),
                CustomTextField(
                  showLeading: false,
                  isDense: true,
                  imagePath: personIcon,
                  validate: (value){
                    return value.isEmpty ? 'Enter  Maximum Players': null ;
                  },
                  controller: controller.totalPlayerController,
                  hintText: 'Maximum Players',
                  keyboardType: TextInputType.number,
                  title: 'Maximum Players',
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
                Sized(height: 0.03,),
                CustomTextField(
                  showLeading: false,
                  isMaxLines: true,
                  imagePath: addressIcon,
                  validate: (value){
                    return value.isEmpty ? 'Write Tournament Rules': null ;
                  },
                  controller: controller.tournamentsRules,
                  hintText: 'Write Tournament Rules',
                  title: '',
                ),
                Sized(height: 0.04,),
            Obx(() => controller.isLoading.value == true ? const Center(child:  CustomIndicator()) :CustomButton(title: 'Update', onTap: (){
              controller.updateTournament(tournamentId: widget.tournament.id, context: context);
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

