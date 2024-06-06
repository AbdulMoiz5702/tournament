import 'package:flutter/material.dart';
import 'package:tournemnt/consts/colors.dart';
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
    final color = isSelected ? whiteColor : iconColor; // Adjust colors as needed

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        setState(() {
          indexx = index;
        });
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom:5),
        padding:const EdgeInsets.symmetric(vertical:8,horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? blueColor : secondaryWhiteColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: mediumText(title : label,color: color,context: context)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.sizeOf(context).width * 1, MediaQuery.sizeOf(context).height * 0.05),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics:const BouncingScrollPhysics(),
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
        body: screens[indexx],
    );
  }
}

