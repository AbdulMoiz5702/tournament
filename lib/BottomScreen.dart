import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/profile_screeb/user_profile_screen.dart';
import 'package:tournemnt/public_tournmnets/Public_tournments.dart';
import '1v1_challenges/all_challenges_screen.dart';
import 'controllers/set_status_controller.dart';
import 'controllers/token_update_controller.dart';
import 'my_all_matches.dart';



import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomScreen extends StatefulWidget {
  final String userId;
  const BottomScreen({required this.userId});

  @override
  State<BottomScreen> createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> with WidgetsBindingObserver {
  late int indexx;
  late List<Widget> screens;

  var controller = Get.put(TokenUpdateController());
  var statusController = Get.put(SetStatusController());

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print('User Token : $userToken');
    indexx = 0;
    screens = [
      TournamentListPage(userId: widget.userId),
      ChallengesListScreen(userId: widget.userId),
      UserAllMatchesScreen(userId: widget.userId),
      ProfileScreen(userId: widget.userId),
    ];
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      statusController.setStatus(isOnline: true);
      statusController.isOnline.value = true;
    } else {
      statusController.setStatus(isOnline: false);
      statusController.isOnline.value = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    print("Observer removed");
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Are you sure you want to exit?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              statusController.setStatus(isOnline: false);
              statusController.isOnline.value = false;
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: screens[indexx],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: whiteColor,
          currentIndex: indexx,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 10.0,
          unselectedFontSize: 8.0,
          selectedIconTheme: const IconThemeData(color: blueColor),
          unselectedIconTheme: const IconThemeData(color: secondaryTextColor),
          selectedItemColor: blueColor,
          unselectedItemColor: secondaryTextColor,
          onTap: (index) {
            indexx = index;
            setState(() {});
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.public_outlined), label: 'Tournaments'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Challenges'),
            BottomNavigationBarItem(icon: Icon(Icons.groups_2_outlined), label: 'My Matches'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

