import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/tournment-card.dart';
import '../consts/colors.dart';
import '../consts/images_path.dart';
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
  final VoidCallback ? onMessage ;
  const AccepterCard(
      {required this.accepterTeamName,
        required this.teamLeaderName,
        required this.accepterLeaderPhone,
        required this.location,
        required this.userId,
        required this.onTap ,
        required this.accpterId,
        required this.imagePath,
        this.onMessage
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(8),
      width: width * 1,
      decoration:  BoxDecoration(
        color: bgTeamCard,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                      mediumText(title: toTitleCase(teamLeaderName),context: context,fontSize: 12,fontWeight: FontWeight.w500,color: cardTextColor),
                      smallText(title: accepterLeaderPhone,context: context,fontSize: 10.0,fontWeight: FontWeight.w500,color: cardTextColor),
                      Sized(height: 0,width: 0.03,),
                    ],
                  ),
                ],
              ),
              userId == accpterId ? Container(
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
                    smallText(title: 'My Team',context: context,color: cardTextColor,fontSize: 10),
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
                  child: SvgPicture.asset(chatIcon),),),
            ],
          ),
          Sized(height: 0.02,),
          Align(
              alignment: Alignment.centerLeft,
              child: largeText(title: toTitleCase(accepterTeamName),fontSize: 24,fontWeight: FontWeight.w500)),
          Sized(height: 0.02,),
          infoBox(title: location, icon: Icons.place_outlined,context: context),
          Sized(height: 0.02,),
        ],
      ),
    );
  }
}
