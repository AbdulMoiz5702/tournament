import 'package:flutter/material.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/profile_screeb/user_profile_screen.dart';
import 'package:tournemnt/public_tournmnets/Public_tournments.dart';
import '1v1_challenges/all_challenges_screen.dart';
import 'my_all_matches.dart';



class BottomScreen extends StatefulWidget {
  final String userId ;
  const BottomScreen({required this.userId});
  @override
  State<BottomScreen> createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  late int indexx;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    indexx = 0;
    screens = [
      TournamentListPage(userId: widget.userId),
      ChallengesListScreen(userId: widget.userId,),
      UserAllMatchesScreen(userId:widget.userId ,),
      ProfileScreen(userId: widget.userId,),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[indexx],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: whiteColor,
            currentIndex: indexx,
            type:BottomNavigationBarType.fixed,
            selectedFontSize: 10.0,
            unselectedFontSize: 8.0,
            selectedIconTheme: const IconThemeData(color:blueColor),
            unselectedIconTheme: const IconThemeData(color: secondaryTextColor),
            selectedItemColor: blueColor,
            unselectedItemColor:secondaryTextColor,
            onTap: (index){
              indexx=index;
              setState(() {
              });
            },
            items: const [
              BottomNavigationBarItem(icon:Icon(Icons.public_outlined),label:'Tournaments'),
              BottomNavigationBarItem(icon:Icon(Icons.person),label:'Challenges'),
              BottomNavigationBarItem(icon:Icon(Icons.groups_2_outlined),label:'My Matches'),
              BottomNavigationBarItem(icon:Icon(Icons.account_circle_outlined),label:'Profile'),
            ],
    )
    );
  }
}
