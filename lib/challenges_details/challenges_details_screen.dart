import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/consts/images_path.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/customLeading.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/details_screen_widget.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';


class ChallengesDetailsScreen extends StatelessWidget {
  const ChallengesDetailsScreen({super.key, required this.data});
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    // Parse the string to DateTime
    DateTime date = DateTime.parse(data['startDate']);
    String toTitleCase(String text) {
      if (text.isEmpty) return text;
      return text
          .split(' ')
          .map((word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1).toLowerCase())
          .join(' ');
    }

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

    String formattedDate = DateFormat('dd MMM yyyy').format(date);
    return BgWidget(
      child: Scaffold(
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
                        title: 'Challenges Details',
                        context: context,
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                      ),
                      Sized(height: 0.005),
                      smallText(
                        title: 'Full Challenge Details  .',
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
          color: whiteColor,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                DetailsScreenWidget(
                    title: 'Team Name', info: toTitleCase(data['challengerTeamName'])),
                DetailsScreenWidget(
                    title: 'Captain Name', info: data['teamLeaderName']),
                DetailsScreenWidget(
                    title: 'Phone Number', info: data['challengerLeaderPhone']),
                DetailsScreenWidget(
                    title: 'Tournament Type ', info: '${data['Over']} | ${data['age']} | ${data['area']}'),
                DetailsScreenWidget(
                  title: 'Challenge Start Date', info: formattedDate,imagePath: dateIcon,),
                DetailsScreenWidget(
                  title: 'Challenge Match Time', info: formatTime(data['startTime']),imagePath: timeIcon,),
                DetailsScreenWidget(
                    imagePath: addressIcon,
                    title: 'Ground Location', info: data['location']),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: CustomButton(title: 'Back', onTap: (){
                    Navigator.pop(context);
                  }),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}




