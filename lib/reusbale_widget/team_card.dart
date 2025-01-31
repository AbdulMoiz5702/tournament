import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'package:tournemnt/reusbale_widget/tournment-card.dart';

import '../consts/images_path.dart';

class TeamCard extends StatelessWidget {
  final String teamName;
  final String leaderName;
  final String leaderPhone;
  final String location;
  final String teamResult;
  final VoidCallback onTap;
  final String userId;
  final String teamId;
  final String imagePath;
  final String roundsQualify;
  final VoidCallback? onMessage;
  final bool vs;
  const TeamCard(
      {required this.teamName,
      required this.leaderName,
      required this.leaderPhone,
      required this.location,
      required this.teamResult,
      required this.onTap,
      required this.userId,
      required this.teamId,
      required this.imagePath,
      required this.roundsQualify,
      this.onMessage,
      required this.vs});
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.all(8),
      width: width * 1,
      decoration: BoxDecoration(
        color: bgTeamCard,
        borderRadius: BorderRadius.circular(30),
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
                    backgroundColor: infoBoxIconColor,
                    radius: 25,
                    backgroundImage: AssetImage(imagePath),
                  ),
                  Sized(
                    width: 0.04,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      mediumText(
                          title: toTitleCase(leaderName),
                          context: context,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: cardTextColor),
                      smallText(
                          title: leaderPhone,
                          context: context,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w500,
                          color: cardTextColor),
                      Sized(
                        height: 0,
                        width: 0.03,
                      ),
                    ],
                  ),
                ],
              ),
              userId == teamId
                  ? Container(
                      alignment: Alignment.center,
                      height: height * 0.043,
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        color: cardMyTournament,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        const  Icon(
                            Icons.circle,
                            size: 5,
                            color: greenColor,
                          ),
                          Sized(
                            width: 0.01,
                          ),
                          smallText(
                              title: 'My Team',
                              context: context,
                              color: cardTextColor,
                              fontSize: 10),
                        ],
                      ),
                    )
                  : Container(
                      height: 1,
                      width: 1,
                    ),
              InkWell(
                onTap: onMessage,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cardCallButtonColor,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(chatIcon),
                ),
              ),
            ],
          ),
          Sized(
            height: 0.01,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: largeText(
                  title: toTitleCase(teamName),
                  fontSize: 24,
                  fontWeight: FontWeight.w500)),
          Sized(
            height: 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              infoBox(
                  title: location,
                  icon: Icons.place_outlined,
                  context: context,
                  isSvg: true),
              Sized(width: 0.02,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.center,
                height: height * 0.043,
                decoration: BoxDecoration(
                  color: cardMyTournament,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.circle,size: 5,color:  teamResult == 'none'? whiteColor : teamResult == 'win'? greenColor : redColor,),
                    Sized(width: 0.02,),
                    teamResult == 'none' && roundsQualify=='none'
                        ? vs == true ? smallText(
                            title: 'Match Scheduled', context: context, color: whiteColor,fontSize: 10,fontWeight: FontWeight.w500) : smallText(
                        title: 'Enqueue', context: context, color: whiteColor,fontSize: 10,fontWeight: FontWeight.w500)
                        : teamResult == 'win' && roundsQualify !='none'
                            ? smallText(
                                title: roundsQualify,
                                color: whiteColor,fontSize: 10,fontWeight: FontWeight.w500)
                            : smallText(
                                title: roundsQualify,
                                 color: whiteColor,fontSize: 10,fontWeight: FontWeight.w500),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

