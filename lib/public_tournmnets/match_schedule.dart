import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_indicator.dart';
import 'package:tournemnt/services/notification_sevices.dart';
import '../consts/colors.dart';
import '../consts/images_path.dart';
import '../controllers/my_tournamnets_teams.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/custom_textfeild.dart';
import '../reusbale_widget/details_screen_widget.dart';
import '../reusbale_widget/text_widgets.dart';



class MatchSchedule extends StatelessWidget {
  final String tournamentId;
  final String teamOneName;
  final String teamTwoName;
  final String teamOneId;
  final String teamTwoId;
  final String teamOneToken;
  final String teamTwoToken;
  final String teamOneImage;
  final String teamTwoImage;
  const MatchSchedule({super.key,required this.tournamentId,required this.teamOneName,required this.teamTwoName,required this.teamOneId,required this.teamTwoId,required this.teamOneToken,required this.teamTwoToken,required this.teamOneImage,required this.teamTwoImage});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyTournamentsTeamsController());
    NotificationServices notificationServices = NotificationServices();
    return BgWidget(
      child: Scaffold(
          backgroundColor: transparentColor,
          appBar: AppBar(
            leading: GestureDetector(
              onTap: (){
                Navigator.pop(context);
                controller.selectedTeams.clear();
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:transparentColor,
                    border: Border.all(color: buttonColor)
                ),
                child: const Icon(Icons.arrow_back,color: whiteColor,size: 18,),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 55),
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
                          title: 'Match Schedule',
                          context: context,
                          fontWeight: FontWeight.w500,
                          color: whiteColor,
                        ),
                        Sized(height: 0.01),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        body: Container(
          color: whiteColor,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Sized(height: 0.03),
                DetailsScreenWidget(
                  title: 'Team', info: teamOneName,isRulesBox: false,),
                Sized(height: 0.05),
                mediumText(title: 'Vs',fontSize: 16,fontWeight: FontWeight.w700),
                DetailsScreenWidget(
                  title: 'Team', info:teamTwoName,isRulesBox: false,),
                Sized(height: 0.01),
                Sized(height: 0.035),
                GestureDetector(
                  onTap: () {
                    controller.selectDate(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        isDense: true,
                        imagePath: dateIcon,
                        validate: (value){
                          return value.isEmpty ? 'Enter  Start date ': null ;
                        },
                        controller: controller.startDateController,
                        hintText: 'Tournament Start Date',
                        title: 'Tournament Start Date',
                      ),
                    ),
                  ),
                ),
                Sized(height: 0.035),
                GestureDetector(
                  onTap: () {
                    controller.selectTime(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        isDense: true,
                        imagePath: timeIcon,
                        validate: (value){
                          return value.isEmpty ? 'Enter  Match time ': null ;
                        },
                        controller: controller.startDateTimeController,
                        hintText: 'Tournament Match time ',
                        title: 'Tournament Match time ',
                      ),
                    ),
                  ),
                ),
                Sized(height: 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Obx(() => controller.isLoading.value
                      ? CustomIndicator()
                      : CustomButton(
                    title: 'Confirm',
                    onTap: () {
                      try {
                        // Validate and parse the input date
                        if (controller.startDateController.text.isEmpty) {
                          throw FormatException("Start date is empty");
                        }

                        // Example input: "22/1/2025 at 3:30" or "22/1/2025"
                        String rawDate = controller.startDateController.text.trim();
                        List<String> dateParts = rawDate.contains(' at ') ? rawDate.split(' at ') : [rawDate];

                        // Parse the date
                        DateTime selectedDate = DateFormat('dd/MM/yyyy').parse(dateParts[0]);
                        String formattedDate = DateFormat('dd MMM yyyy').format(selectedDate);

                        // Parse the time if provided
                        String formattedTime = 'not specified'; // Default if no time is given
                        if (dateParts.length == 2) {
                          String rawTime = dateParts[1];
                          int hour = int.parse(rawTime.split(':')[0].trim());
                          int minute = rawTime.contains(':') ? int.parse(rawTime.split(':')[1].trim()) : 0;
                          TimeOfDay selectedTime = TimeOfDay(hour: hour, minute: minute);
                          formattedTime = selectedTime.format(context);
                        }

                        // Schedule the match
                        controller.makeSchedule(
                          tournamentId: tournamentId,
                          teamOne: teamOneName,
                          teamTwo: teamTwoName,
                          teamTwoId: teamTwoId,
                          teamOneId: teamOneId,
                          teamOneToken: teamOneToken,
                          teamTwoToken: teamTwoToken,
                          context: context,
                          teamOneImage:teamOneImage,
                          teamTwoImage: teamTwoImage,
                        );

                        // Send notifications
                        notificationServices.sendNotificationToSingleUser(
                          teamOneToken,
                          'Match Scheduled!',
                          'Hi ${teamOneName}!\n🎉 Your match against ${teamTwoName} is scheduled for $formattedDate at $formattedTime. Get ready! 🏏',
                            {
                              'type':'ViewTeamMatchSchedule',
                              'tournamentId':tournamentId,
                            }
                        );

                        notificationServices.sendNotificationToSingleUser(
                          teamTwoToken,
                          'Match Scheduled!',
                          'Hi ${teamTwoName}!\n🎉 Your match against ${teamOneName} is scheduled for $formattedDate at $formattedTime. Prepare for the game! 🏆',
                            {
                              'type':'ViewTeamMatchSchedule',
                              'tournamentId':tournamentId,
                            }
                        );
                      } catch (e) {
                        // Handle invalid input gracefully
                        print("Error: ${e.toString()}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Invalid date or time format. Please check your input.")),
                        );
                      }
                    },
                  )),
                ),
                Sized(height: 0.3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
