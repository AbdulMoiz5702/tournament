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


class TournamentDetailScreen extends StatelessWidget {
  const TournamentDetailScreen({super.key, required this.data});
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    // Parse the string to DateTime
    DateTime date = DateTime.parse(data.tournmentStartDate);
    String formattedDate = DateFormat('dd MMM yyyy').format(date);

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
                        title: 'Tournament Detail',
                        context: context,
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                      ),
                      Sized(height: 0.005),
                      smallText(
                        title: 'Full Tournament Details .',
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
                    title: 'Tournament  Name', info: data.name),
                DetailsScreenWidget(
                    title: 'Tournament  Fee',
                    info: '${data.tournamentFee} RS'),
                DetailsScreenWidget(
                    title: 'Tournament Type', info: data.tournamentOvers),
                DetailsScreenWidget(
                    title: 'Maximum Player ',
                    info: data.totalPlayers.toString()),
                DetailsScreenWidget(
                    title: 'Maximum Teams',
                    info: data.totalTeam.toString()),
                DetailsScreenWidget(
                  title: 'Tournament Start Date',
                  info: formattedDate,
                  imagePath: dateIcon,
                ),
                DetailsScreenWidget(
                  title: 'Tournament Match Time',
                  info: formatTime(data.startTime),
                  imagePath: timeIcon,
                ),
                DetailsScreenWidget(
                    title: 'Ground Location', info: data.location),
                DetailsScreenWidget(
                  title: 'Tournament Rules',
                  info: data.rules,
                  isRulesBox: true,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: CustomButton(
                      title: 'Back',
                      onTap: () {
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





