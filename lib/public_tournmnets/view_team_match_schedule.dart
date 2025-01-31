import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/tournment-card.dart';

import '../consts/colors.dart';
import '../consts/firebase_consts.dart';
import '../reusbale_widget/customLeading.dart';
import '../reusbale_widget/custom_indicator.dart';
import '../reusbale_widget/custom_sizedBox.dart';
import '../reusbale_widget/text_widgets.dart';


class ViewTeamMatchSchedule extends StatelessWidget {
  final String tournamentId;
  const ViewTeamMatchSchedule({super.key, required this.tournamentId});

  @override
  Widget build(BuildContext context) {
    String toTitleCase(String text) {
      if (text.isEmpty) return text;
      return text
          .split(' ')
          .map((word) => word.isEmpty
          ? word
          : word[0].toUpperCase() + word.substring(1).toLowerCase())
          .join(' ');
    }

    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    TimeOfDay parseTimeOfDay(String timeString) {
      final regex = RegExp(r'TimeOfDay\((\d+):(\d+)\)');
      final match = regex.firstMatch(timeString);
      if (match != null) {
        final hour = int.parse(match.group(1)!);
        final minute = int.parse(match.group(2)!);
        return TimeOfDay(hour: hour, minute: minute);
      } else {
        throw const FormatException("Invalid TimeOfDay format");
      }
    }

    String formatTimeOfDay(TimeOfDay time) {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final period = time.period == DayPeriod.am ? "AM" : "PM";
      final formattedMinute = time.minute.toString().padLeft(2, '0');
      return "$hour:$formattedMinute $period";
    }

    return BgWidget(
      child: Scaffold(
        backgroundColor: transparentColor,
        appBar: AppBar(
          leading: const CustomLeading(),
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 55),
            child: Padding(
              padding: EdgeInsets.only(left: width * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Sized(height: 0.005),
                      largeText(
                        title: 'View Match Schedule',
                        context: context,
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                      ),
                      Sized(height: 0.005),
                      smallText(
                        title: 'Next Match List in Show below ',
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
          child: StreamBuilder(
            stream: fireStore
                .collection(tournamentsCollection)
                .doc(tournamentId)
                .collection(vsTeamCollection)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CustomIndicator(
                    height: 0.1,
                    width: 0.2,
                  ),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No match schedule available'),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    DateTime date = DateTime.parse(data['date']);
                    String formattedDate = DateFormat('dd MMM yyyy').format(date);
                    TimeOfDay time = parseTimeOfDay(data['time']);
                    String formattedTime = formatTimeOfDay(time);
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: bgTeamCard,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              infoBox(
                                title: formattedDate,
                                icon: Icons.calendar_today_outlined,
                                context: context,
                              ),
                              Sized(width: 0.02,),
                              infoBox(
                                title: formattedTime,
                                icon: Icons.schedule_outlined,
                                context: context,
                              ),
                            ],
                          ),
                          Sized(height: 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: blackColor,
                                    backgroundImage: AssetImage(data['teamOneImage']),
                                  ),
                                  Sized(height: 0.01,),
                                  smallText(title: data['teamOne'],color: blackColor)
                                ],
                              ),
                              mediumText(title: 'Vs',fontSize: 18),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: blackColor,
                                    backgroundImage: AssetImage(data['teamTwoImage']),
                                  ),
                                  Sized(height: 0.01,),
                                  smallText(title: data['teamTwo'],color: blackColor)
                                  
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

