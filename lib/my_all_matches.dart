import 'package:flutter/material.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/reusbale_widget/bg_widgets.dart';
import 'package:tournemnt/reusbale_widget/customLeading.dart';
import 'package:tournemnt/reusbale_widget/custom_sizedBox.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import 'my_1v1_challenges/myChallenges.dart';
import 'my_1v1_challenges/user_challnegs.dart';
import 'my_tournments/my_tournaments_screen/myTournamnets.dart';
import 'my_tournments/my_tournaments_teams/mymatches.dart';



class UserAllMatchesScreen extends StatefulWidget {
  final String userId ;
  const UserAllMatchesScreen({required this.userId});
  @override
  State<UserAllMatchesScreen> createState() => _UserAllMatchesScreenState();
}

class _UserAllMatchesScreenState extends State<UserAllMatchesScreen> {
  late int indexx;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    indexx = 0;
    screens = [
      MyTournamentsScreen(userId:widget.userId ,),
      MyTournamentsTeams(userId: widget.userId),
      UserChallengesScreen(userId: widget.userId,),
      UserAcceptedChallengesScreen(userId: widget.userId,),
    ];
  }

  // Helper method to build icon based on index
  Widget _buildNavItem(int index) {
    String label;
    switch (index) {
      case 0:
        label = 'My Tournaments';
        break;
      case 1:
        label = 'MY Teams';
        break;
      case 2:
        label = 'MY Challenges';
        break;
      case 3:
        label = 'My Accepted Challenges';
        break;
      default:
        label = 'Error';
    }

    final isSelected = indexx == index;
    final color = isSelected ? whiteColor : tCardColor; // Adjust colors as needed

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        setState(() {
          indexx = index;
        });
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom:5),
        padding:const EdgeInsets.symmetric(vertical:8,horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ?  cardMyTournament: myMatchesUnSelected,
          borderRadius: BorderRadius.circular(20),
        ),
        child: smallText(title : label,color: color,fontSize: 12,fontWeight: FontWeight.w500)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BgWidget(
      child: Scaffold(
        backgroundColor: transparentColor,
        appBar: AppBar(
          backgroundColor: transparentColor,
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
                        title: 'Add Tournament',
                        context: context,
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                      ),
                      Sized(height: 0.005),
                      smallText(
                        title: 'Enter Your Valid Information .',
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PreferredSize(
                preferredSize: Size(MediaQuery.sizeOf(context).width * 1, MediaQuery.sizeOf(context).height * 0.05),
                child: Container(
                  color: whiteColor,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics:const BouncingScrollPhysics(),
                    child: Container(
                      color: whiteColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          screens.length,
                              (index) => IconButton(
                            icon: _buildNavItem(index),
                            onPressed: () {
                              setState(() {
                                indexx = index;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(child: Container(
                color: whiteColor,
                  child: screens[indexx])),
            ],
          ),
      ),
    );
  }
}

