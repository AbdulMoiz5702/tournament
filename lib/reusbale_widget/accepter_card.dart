import 'package:flutter/material.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import '../consts/colors.dart';
import 'custom_sizedBox.dart';


class AccepterCard extends StatelessWidget {
  final String accepterTeamName;
  final String teamLeaderName;
  final String accepterLeaderPhone;
  final String location;
  final VoidCallback onTap ;
  final String userId ;
  final String accpterId;
  final String imagePath;
  const AccepterCard(
      {required this.accepterTeamName,
        required this.teamLeaderName,
        required this.accepterLeaderPhone,
        required this.location,
        required this.userId,
        required this.onTap ,
        required this.accpterId,
        required this.imagePath,
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
            child: Center(child: mediumText(title: 'Team ${accepterTeamName.toUpperCase()}',color: blueColor,context: context)),
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
                            smallText(title: accepterLeaderPhone,context: context,fontSize: 13.0),
                          ],
                        ),
                      ],
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
                    userId == accpterId ? Container(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
