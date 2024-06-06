import 'package:flutter/material.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/tournment-card.dart';

class TeamCard extends StatelessWidget {
  final String teamName;
  final String leaderName;
  final String leaderPhone;
  final String location;
  final String teamResult ;
  final VoidCallback onTap ;
  final String userId;
  final String teamId ;
  final String imagePath;
  final String roundsQualify ;
  const TeamCard(
      {required this.teamName,
        required this.leaderName,
        required this.leaderPhone,
        required this.location,
        required this.teamResult,
        required this.onTap ,
        required this.userId,
        required this.teamId,
        required this.imagePath,
        required this.roundsQualify
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
            child: Center(child: mediumText(title: 'Team ${teamName.toUpperCase()}',color: blueColor,context: context)),
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
                            mediumText(title: leaderName,context: context),
                            smallText(title: leaderPhone,context: context,fontSize: 13.0),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: height * 0.041,
                      width: width * 0.2,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: teamResult == 'none' ? smallText(title: 'Enqueue',context: context,color: blueColor) :teamResult == 'win' ? smallText(title: 'Qualified ',context: context,color: blueColor):smallText(title: 'Disqualified ',context: context,color: redColor),
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
                    userId == teamId ? Container(
                      alignment: Alignment.center,
                      height: height * 0.041,
                      width: width * 0.25,
                      decoration: BoxDecoration(
                        color: secondaryTextFieldColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:smallText(title: 'Your\'s  Team',context: context,color: blueColor,fontWeight: FontWeight.bold),
                    ) :  Container(height: 1,width: 1,),
                  ],
                ),
                Sized(height: 0.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      alignment: Alignment.center,
                      height: height * 0.041,
                      decoration: BoxDecoration(
                        color: secondaryTextFieldColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:roundsQualify=='none'?smallText(title:'Waiting For its Match',context: context,color: primaryTextColor) :smallText(title:roundsQualify,context: context,color: blueColor),
                    ) ,
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

