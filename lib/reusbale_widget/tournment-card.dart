import 'package:flutter/material.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/reusbale_widget/custom_button.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';

class TournamentCard extends StatelessWidget {
  final String tournamentName;
  final String organizerName;
  final String organizerPhoneNumber;
  final String tournamentFee;
  final String tournamentOvers;
  final String location;
  final String isCompleted ;
  final String startDate ;
  final String userId;
  final String organizerId ;
  final VoidCallback onTap ;
  final int totalTeams ;
  final int registerTeams ;
  final String imagePath ;
  const TournamentCard(
      {required this.tournamentName,
      required this.organizerName,
      required this.organizerPhoneNumber,
        required this.tournamentFee,
        required this.tournamentOvers,
        required this.location,
        required this.isCompleted,
        required this.onTap,
        required this.startDate,
        required this.userId,
        required this.organizerId,
        required this.totalTeams,
        required this.registerTeams,
        required this.imagePath
      });
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height ;
    double width = MediaQuery.sizeOf(context).width ;
    return Container(
      margin: const EdgeInsets.only(top: 7),
      alignment: Alignment.center,
      width: width * 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: width * 0.7,
            height: height * 0.06,
            decoration: const BoxDecoration(
              color: secondaryWhiteColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight:Radius.circular(15) )
            ),
            child: Center(child: mediumText(title: 'Tournament ${tournamentName.toUpperCase()}',color: blueColor,context: context)),
          ),
          Container(
            padding: EdgeInsets.all(8),
            width: width * 1,
            decoration:  BoxDecoration(
                color: secondaryWhiteColor,
                borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                         CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(imagePath),
                        ),
                        Sized(width: 0.04,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            mediumText(title: organizerName,context: context),
                            smallText(title: organizerPhoneNumber,context: context,fontSize: 13.0),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: height * 0.041,
                      width: width * 0.2,
                      decoration: BoxDecoration(
                        color: secondaryTextFieldColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: smallText(title: 'Overs $tournamentOvers',context: context,color: blueColor),
                    ),
                  ],
                ),
                Sized(height: 0.02,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on,color: secondaryTextColor,),
                        Sized(width: 0.02,),
                        smallText(title: location,context: context),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_month_rounded,color: secondaryTextColor,),
                        Sized(width: 0.02,),
                        smallText(title: startDate,context: context),
                      ],
                    ),
                  ],
                ),
                Sized(height: 0.02,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: height * 0.041,
                      width: width * 0.2,
                      decoration: BoxDecoration(
                        color: secondaryTextFieldColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: smallText(title: '$tournamentFee PKR',context: context,color: primaryTextColor),
                    ),
                    CustomButton(title: isCompleted == 'true' || registerTeams == totalTeams ? 'View Participants':'Register Team Now', onTap: onTap,width:0.6,height: 0.045,),
                  ],
                ),
                Sized(height: 0.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   userId == organizerId ? Container(
                      alignment: Alignment.center,
                      height: height * 0.041,
                      width: width * 0.2,
                      decoration: BoxDecoration(
                        color: secondaryTextFieldColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child:smallText(title: 'Your\'s',context: context,color: blueColor,fontWeight: FontWeight.bold),
                    ) :  Container(height: 1,width: 1,),
                    Sized(width: 0.02,),
                    Container(
                      alignment: Alignment.center,
                      height: height * 0.041,
                      width: width * 0.5,
                      decoration: BoxDecoration(
                        color: secondaryTextFieldColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child:isCompleted == 'true' || registerTeams == totalTeams ? smallText(title: 'Tournament in progress',context: context,color: primaryTextColor) : smallText(title: 'Registrations Open',context: context,color: blueColor),
                    ),
                  ],
                ),
                Sized(height: 0.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: height * 0.041,
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        color: secondaryTextFieldColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child:smallText(title: 'Total Teams ${totalTeams.toString()}',context: context,color: secondaryTextColor,fontWeight: FontWeight.bold),
                    ) ,
                    Sized(width: 0.02,),
                    Container(
                      alignment: Alignment.center,
                      height: height * 0.041,
                      width: width * 0.32,
                      decoration: BoxDecoration(
                        color: secondaryTextFieldColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child:smallText(title: 'Register Teams  ${registerTeams.toString()}',context: context,color: blueColor),
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
  CustomIcon({required this.icon, this.color = skinColor});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color,
    );
  }
}
