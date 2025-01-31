import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/consts/firebase_consts.dart';
import 'package:tournemnt/consts/images_path.dart';
import 'package:tournemnt/profile_screeb/user_profile_screen.dart';
import 'package:tournemnt/public_tournmnets/Public_tournments.dart';
import 'package:tournemnt/reusbale_widget/text_widgets.dart';
import '1v1_challenges/all_challenges_screen.dart';
import 'controllers/set_status_controller.dart';
import 'controllers/token_update_controller.dart';
import 'my_all_matches.dart';


class BottomScreen extends StatefulWidget {
  final String userId;
  const BottomScreen({super.key,required this.userId});

  @override
  State<BottomScreen> createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> with WidgetsBindingObserver {

  late List<Widget> screens;
  var controller = Get.put(TokenUpdateController());
  var statusController = Get.put(SetStatusController());
  int  indexCurrent = 0;




  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    controller.userProfileToken();
    WidgetsBinding.instance.addObserver(this);
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
        backgroundColor: whiteColor,
        title: mediumText(title: 'Exit App',color: blackColor),
        content: smallText(title: 'Are you sure you want to exit?',color: blackColor,fontWeight: FontWeight.w500),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: smallText(title: 'No',color: blackColor,fontWeight: FontWeight.w500),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              statusController.setStatus(isOnline: false);
              statusController.isOnline.value = false;
            },
            child: smallText(title: 'Yes',color: blackColor,fontWeight: FontWeight.w500),
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
        body: screens[indexCurrent],
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 25,vertical: 5),
          color: whiteColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(bottomIcon.length, (index){
              return GestureDetector(
                onTap: (){
                  indexCurrent = index;
                  setState(() {

                  });
                },
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(bottomIcon[index],color: indexCurrent == index ? selectedColor : unSelectedColor,),
                      smallText(title: bottomTitle[index],color: indexCurrent == index ? selectedColor : unSelectedColor,fontSize: 12,fontWeight: FontWeight.w500)
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}


