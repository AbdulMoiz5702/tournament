import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/tournment-card.dart';

import '../consts/colors.dart';
import '../consts/images_path.dart';
import 'custom_button.dart';
import 'custom_sizedBox.dart';


class ChallengeCard extends StatelessWidget {
  final String challengerTeamName;
  final String teamLeaderName;
  final String challengerLeaderPhone;
  final String location;
  final String matchOvers ;
  final int teamCount ;
  final String userId ;
  final String challengerId;
  final String isChallengeAccepted ;
  final VoidCallback onTap ;
  final String  imagePath ;
  final String startDate ;
  final String startTime ;
  final String age;
  final String area ;
  final VoidCallback ? onMessage ;
  final VoidCallback ? seeDetails;
  const ChallengeCard(
      {required this.challengerTeamName,
        required this.teamLeaderName,
        required this.challengerLeaderPhone,
        required this.location,
        required this.matchOvers,
        required this.teamCount,
        required this.userId,
        required this.challengerId,
        required this.isChallengeAccepted,
        required this.onTap ,
        required this.imagePath,
        required this.startDate,
        required this.onMessage,
        this.seeDetails,
        required this.startTime,
        required this.age,
        required this.area,
      });
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height ;
    double width = MediaQuery.sizeOf(context).width ;
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: const EdgeInsets.symmetric(horizontal:10,vertical:7),
      alignment: Alignment.center,
      width: width * 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: whiteColor,
                    radius: 25,
                    backgroundImage: AssetImage(imagePath),
                  ),
                  Sized(width: 0.04,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mediumText(title: teamLeaderName,context: context,fontSize: 12,fontWeight: FontWeight.w500,color: cardTextColor),
                      smallText(title: challengerLeaderPhone,context: context,fontSize: 10.0,fontWeight: FontWeight.w500,color: cardTextColor),
                      Sized(height: 0,width: 0.03,),
                    ],
                  ),
                ],
              ),
              userId == challengerId ? Container(
                alignment: Alignment.center,
                height: height * 0.043,
                width: width * 0.3,
                decoration: BoxDecoration(
                  color: cardMyTournament,
                  borderRadius: BorderRadius.circular(30),
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.circle,size: 5,color: greenColor,),
                    Sized(width: 0.01,),
                    smallText(title: 'My Challenge',context: context,color: cardTextColor,fontSize: 10),
                  ],
                ),
              ) :  Container(height: 1,width: 1,),
              InkWell(
                onTap: onMessage,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  decoration:const BoxDecoration(
                    color: cardCallButtonColor,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(chatIcon),),),
            ],
          ),
          Sized(height: 0.02,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              infoBox(title: startDate, icon: Icons.date_range_outlined,context: context),
              infoBox(title: formatTime(startTime), icon: Icons.schedule_outlined,context: context),
              infoBox(title: location, icon: Icons.date_range_outlined,iconColor: infoBoxIconColor,context: context),
            ],
          ),
          Sized(height: 0.01,),
          largeText(title:toTitleCase(challengerTeamName) ,fontSize: 24,fontWeight: FontWeight.w500),
          Sized(height: 0.01,),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            height: MediaQuery.sizeOf(context).height * 0.12,
            width: MediaQuery.sizeOf(context).width * 1,
            decoration: BoxDecoration(
              color: cardPartColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: registerTeamBox
                      ),
                      child: smallText(title:matchOvers,color: cardTextColor,fontSize: 10,fontWeight: FontWeight.w500),
                    ),
                    Sized(height: 0.015,),
                    smallText(title:'$age | $area',color: cardTextColor,fontSize: 12,fontWeight: FontWeight.w500),
                  ],
                ),
                SvgPicture.asset(challenge,height:MediaQuery.sizeOf(context).height *0.1,color: whiteColor.withOpacity(0.85),),
              ],
            ),
          ),
          Sized(height: 0.01,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: seeDetails,
                child: Container(
                  padding: EdgeInsets.all(8),
                  height: MediaQuery.sizeOf(context).height * 0.12,
                  width: MediaQuery.sizeOf(context).width * 0.33,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      smallText(title: 'See',color: cardTextColor,fontSize: 16,fontWeight: FontWeight.w500),
                      Sized(height: 0.005,),
                      smallText(title:'Details',color: cardTextColor,fontSize: 16,fontWeight: FontWeight.w500),
                      Sized(height: 0.005,),
                      Align(alignment: Alignment.centerRight,child: SvgPicture.asset(arrowIcon)),
                    ],
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.all(8),
                  height: MediaQuery.sizeOf(context).height * 0.12,
                  width: MediaQuery.sizeOf(context).width * 0.55,
                  decoration: BoxDecoration(
                    color: cardPartColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      smallText(title: 'Tap Here ',color: cardTextColor,fontSize: 16,fontWeight: FontWeight.w500),
                      Sized(height: 0.005,),
                      largeText(title:'For',color: cardTextColor,fontSize: 10,fontWeight: FontWeight.w500),
                      Sized(height: 0.005,),
                      smallText(title:isChallengeAccepted == 'false'? 'Team Registration' : 'View Challenge',color: cardTextColor,fontSize: 13,fontWeight: FontWeight.w500),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
