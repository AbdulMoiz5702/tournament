import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tournemnt/consts/colors.dart';
import 'package:tournemnt/services/notification_sevices.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'Splash_screen.dart';

// Initialize global navigator key
var navigatorKey = GlobalKey<NavigatorState>();
NotificationServices notificationServices = NotificationServices();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessageBackgroundHandler);
  notificationServices.firebaseInit();
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI([ZegoUIKitSignalingPlugin()]);
    runApp(MyApp(navigatorKey: navigatorKey));
  });
}

@pragma('vm:entry-point')
Future<void> _firebaseMessageBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // You can process background message here if needed
}

// The MyApp widget
class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    notificationServices.firebaseInit();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: widget.navigatorKey, // Pass navigator key here
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: transparentColor,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          color: transparentColor,
        ),
      ),
      home: SplashScreen(), // Home screen (Splash Screen)
    );
  }
}