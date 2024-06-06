import 'package:flutter/material.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/tournment-card.dart';

import '../consts/colors.dart';
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
        required this.startDate
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
            child: Center(child: mediumText(title: 'Team ${challengerTeamName.toUpperCase()}',color: blueColor,context: context)),
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
                            mediumText(title: teamLeaderName,context: context),
                            smallText(title: challengerLeaderPhone,context: context,fontSize: 13.0),
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
                      child: smallText(title: 'Overs $matchOvers',context: context,color: blueColor),
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
                    userId == challengerId ? Container(
                      alignment: Alignment.center,
                      height: height * 0.041,
                      width: width * 0.2,
                      decoration: BoxDecoration(
                        color: secondaryTextFieldColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child:smallText(title: 'Your\'s',context: context,color: blueColor,fontWeight: FontWeight.bold),
                    ) :  Container(height: 1,width: 1,),
                    CustomButton(title: isChallengeAccepted == 'false' ? 'View Challenge' :'Challenge in progress', onTap: onTap,width:0.6,height: 0.045,),
                  ],
                ),
                Sized(height: 0.03,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    smallText(title: isChallengeAccepted == 'false' ? 'Available for Challenge' :'Already in Challenge for 1 v 1',context: context,fontWeight: FontWeight.w400,color: secondaryTextColor,fontSize:18 ),
                    
                  ],
                ),
                Sized(height: 0.01,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
