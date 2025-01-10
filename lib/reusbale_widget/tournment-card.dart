import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/consts/images_path.dart';

import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';

class TournamentCard extends StatelessWidget {
  final String tournamentName;
  final String organizerName;
  final String organizerPhoneNumber;
  final String tournamentFee;
  final String location;
  final String isCompleted ;
  final String startDate ;
  final String userId;
  final String startTime;
  final String organizerId ;
  final VoidCallback onTap ;
  final int totalTeams ;
  final int registerTeams ;
  final String imagePath ;
  final VoidCallback ? onMessage ;
  final VoidCallback ? seeDetails ;
  final VoidCallback ? viewTeams ;
  const TournamentCard(
      {required this.tournamentName,
      required this.organizerName,
      required this.organizerPhoneNumber,
        required this.tournamentFee,
        required this.location,
        required this.isCompleted,
        required this.onTap,
        required this.startDate,
        required this.userId,
        required this.organizerId,
        required this.totalTeams,
        required this.registerTeams,
        required this.imagePath,
        this.onMessage,
        this.seeDetails,
        this.viewTeams,
        required this.startTime
      });
  @override
  Widget build(BuildContext context) {
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

    double height = MediaQuery.sizeOf(context).height ;
    double width = MediaQuery.sizeOf(context).width ;
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: const EdgeInsets.only(top: 7),
      alignment: Alignment.center,
      width: width * 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            width: width * 1,
            decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(15),
            ),
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
                            mediumText(title: toTitleCase(organizerName),context: context,fontSize: 12,fontWeight: FontWeight.w500,color: cardTextColor),
                            smallText(title: organizerPhoneNumber,context: context,fontSize: 10.0,fontWeight: FontWeight.w500,color: cardTextColor),
                            Sized(height: 0,width: 0.03,),
                          ],
                        ),
                      ],
                    ),
                    userId == organizerId ? Container(
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
                          smallText(title: 'My Tournament',context: context,color: whiteColor,fontSize: 10,fontWeight: FontWeight.w500),
                        ],
                      ),
                    ) :  Container(height: 1,width: 1,),
                    InkWell(
                      onTap: onMessage,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: cardCallButtonColor,
                          shape: BoxShape.circle,
                        ),
                          child: SvgPicture.asset(chatIcon),height:50,),),
                  ],
                ),
                Sized(height: 0.02,),
                largeText(title:toTitleCase(tournamentName) ,fontSize: 24,fontWeight: FontWeight.w700),
                Sized(height: 0.01,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    infoBox(title: startDate, icon: Icons.date_range_outlined,context: context),
                    infoBox(title: formatTime(startTime), icon: Icons.schedule_outlined,context: context),
                    infoBox(title: location, icon: Icons.place_outlined,iconColor: infoBoxIconColor,context: context,isSvg: true),
                  ],
                ),
                Sized(height: 0.01,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: viewTeams,
                      child: Container(
                        padding: EdgeInsets.only(left: 8,right: 8,top: 8),
                        height: MediaQuery.sizeOf(context).height * 0.12,
                        width: MediaQuery.sizeOf(context).width * 0.62,
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
                        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: registerTeamBox
                        ),
                        child: smallText(title: 'Register Teams : $registerTeams',color: cardTextColor,fontSize: 10,fontWeight: FontWeight.w500),
                      ),
                                Sized(height: 0.01,),
                                smallText(title:'Total Teams ${totalTeams.toString()}',color: cardTextColor,fontSize: 10,fontWeight: FontWeight.w500),
                                Sized(height: 0.01,),
                                isCompleted == 'true' ? smallText(title: 'LIVE',fontWeight: FontWeight.w500,color: greenColor):Container(height: 0,width: 0,)
                              ],
                            ),
                            SvgPicture.asset(challenge,height:MediaQuery.sizeOf(context).height *0.08,color: whiteColor.withOpacity(0.85),),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: seeDetails,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: MediaQuery.sizeOf(context).height * 0.12,
                        width: MediaQuery.sizeOf(context).width * 0.24,
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
                  ],
                ),
                Sized(height: 0.005,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      height: MediaQuery.sizeOf(context).height * 0.12,
                      width: MediaQuery.sizeOf(context).width * 0.54,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          smallText(title: 'Single Wicket | Open Tournament',color: cardTextColor,fontSize: 10,fontWeight: FontWeight.w500),
                          Sized(height: 0.005,),
                          largeText(title:'Entry FEE',color: cardTextColor,fontSize: 20,fontWeight: FontWeight.w500),
                          Sized(height: 0.005,),
                          smallText(title: 'PKR $tournamentFee',color: cardTextColor,fontSize: 14,fontWeight: FontWeight.w500),
                        ],
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: onTap,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        height: MediaQuery.sizeOf(context).height * 0.12,
                        width: MediaQuery.sizeOf(context).width * 0.32,
                        decoration: BoxDecoration(
                          color: cardPartColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Sized(height: 0.005,),
                            smallText(title:  isCompleted == 'true'? 'View' :'Team',color: whiteColor,fontSize: 13,fontWeight: FontWeight.w500),
                            Sized(height: 0.003,),
                            smallText(title:isCompleted == 'true'? 'Teams':'Registration',color: whiteColor,fontSize: 13,fontWeight: FontWeight.w500),
                            Sized(height: 0.012,),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: smallText(title: 'Tap Here ',color: cardTextColor,fontSize: 12,fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  CustomIcon({required this.icon, this.color = loginRegisterButtonBorderColor});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color,
    );
  }
}

Widget infoBox({required String title,required IconData icon,Color iconColor = blackColor,required BuildContext context,bool isSvg =false}){
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 2),
    padding: EdgeInsets.symmetric(horizontal: 6,vertical: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: whiteColor
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isSvg == true ? SvgPicture.asset(locationIcon,height: 23,) :Icon(icon,color: iconColor,),
        Sized(width: 0.01,),
        Text(title,style: TextWidgets.smallTextStyle(fontSize: 10,color:cardTextColor,fontWeight: FontWeight.w600),softWrap: true,overflow: TextOverflow.fade,),
      ],
    ),
  );
}

