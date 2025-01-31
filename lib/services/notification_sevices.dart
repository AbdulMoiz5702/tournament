import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:tournemnt/BottomScreen.dart';
import 'package:tournemnt/my_tournments/my_tournaments_teams/ma_matcehs_team_screen.dart';
import 'dart:convert';
import '../chat_screens/messages.dart';
import '../consts/firebase_consts.dart';
import '../my_tournments/my_tournaments_screen/view_my_tournaments.dart';
import '../public_tournmnets/view_team_match_schedule.dart';


class NotificationServices {
  final String fireBaseEndPoint =
      'https://www.googleapis.com/auth/firebase.messaging';
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
    } else {}
  }

  Future<void> firebaseInit() async {
    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((message) {
      initLocalNotification(message);
      showNotification(message);
      _handleNotificationNavigation(message);
    });

    // Handle background and terminated state notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Opened from background/terminated state: ${message.data}");
      _handleNotificationNavigation(message);
    });

    // Handle notification when the app is launched from terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print("Opened from terminated state: ${message.data}");
        _handleNotificationNavigation(message);
      }
    });
  }

  Future<void> initLocalNotification(RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      if (payload.payload != null) {
        _handleNotificationNavigation(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      enableVibration: true,
      enableLights: true,
      playSound: true,
      ledColor: Colors.cyan,
      Random.secure().nextInt(10000).toString(),
      'High Importance Notification',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      icon: '@mipmap/ic_launcher', // Replace with your app's launcher icon,
      channelDescription: 'Your Channel Description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      enableLights: true,
      enableVibration: true,
      playSound: true,
      visibility: NotificationVisibility.public,
      fullScreenIntent: true,
      color: Colors.red,
      category: AndroidNotificationCategory.reminder,
      colorized: true,
      channelShowBadge: true,
    );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.active,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
    );
  }

  Future<String?> getDeviceToken() async {
    return await messaging.getToken();
  }

  Future<void> saveTokenToFirestore(String token) async {
    await fireStore
        .collection(usersCollection)
        .doc(token)
        .set({'token': token});
  }

  Future<void> sendNotificationToAllUsers(
      String title, String body, collection, Map<String, dynamic> data) async {
    List<String> tokens = await _getAllUserTokens(collection);
    String accessToken = await getAccessToken();
    for (String token in tokens) {
      await _sendNotification(token, title, body, accessToken, data);
    }
  }

  Future<void> sendNotificationToSingleUser(String token, String title,
      String body, Map<String, dynamic> data) async {
    String accessToken = await getAccessToken();
    await _sendNotification(token, title, body, accessToken, data);
  }

  Future<List<String>> _getAllUserTokens(collection) async {
    List<String> tokens = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection(collection).get();
      for (var doc in querySnapshot.docs) {
        String? token = doc.get('token');
        if (token != null) {
          tokens.add(token);
        }
      }
    } catch (e) {
      print('Error retrieving tokens: $e');
    }
    return tokens;
  }

  Future<String> getAccessToken() async {
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "tournament-45ad2",
        "private_key_id": "cdeabf416f189db91de3887839644e7954d9e7b0",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC1fuDuflcguCu+\nBsHR3n9VIfc9U7Tqw8+ab4TEYafp7UUxUjcvS3HN52s0GXEhmIM1gZgOSIXmODHa\nXl62aq6YThoWim/IkYp/njB23R+eqHWlbyERvBYfVilt+WStxzDxm0iqs3fJPJMO\nszbg/xqQJesDdURHA7UwybltVrwlZh+08yqWBQuJrr1aR7RjHLICWe6rXDke/JgL\nF1b0a48IeiLLKOpcPUbdxTwGhnSUeGnRMVb5eP3p7Uhc9/EJ81oMGz0OK/65rHgf\nZ8H+M+3EBgjr24TUoM/sAEzEe+eHhyFOiDDkNEvD2EDvROM6MboCu64iYVIIMOra\n7ZCw7rcXAgMBAAECggEACLJ6S+NxAGfi7Lm9KvXrCyTUCLPMrR1SAvgKGDEHz11n\n3euvKkyGuRO4XuhDNBVvYC6EH1cZV4Vk2i6AgmRNVo4TkPX0UlurE998Og3xmHRB\nIvrWzldBhiHmXVdAnFU5wrIqwsdT26hT8bXj0NdYqgSvJNzHN1H1qk9YW+V2oaIU\n94ncJF6PL2eWjaHo7veRpxsAYX7fPKv9LzfBRJI4HWwFW3p87FVdP4IfZlEn6+eR\nUMy9OKGwhht8iI3aWS+F7SZ9s0Qb6j3KXgDdmRbapDMm8oLyUtBW10sNCuxk4inD\nD19M9mlc70lmcep5HAqcMqQ5MpowbXraW3uHka8yRQKBgQDnp784kTifqrL4K3lc\nNfA3yCX4GMOflNFZK9nfxD2aSZsDoMbfoTZRA6crxVOtFuqPmEi4XLr+MpzFVCWp\nlmjg4UkvQ8JAvG09UPtPQF2k79P5OqiDyDoFl+URfpmVpWa999XfBrSEMrUsUNIQ\njswlvfqAGkBbn5E1LFLeOW9OGwKBgQDIka4U+GRH2BK4aFvuistXfMnpkjVqvwNv\n2Jn8ry6XzmOkuqM4wr9sd70RPN+dI1ue7jHw9CJfbpoHC7l3LPV0GWIF0mrJfsI3\ncLPOkpjNiDLyK5Abw60gMcwNbCksN+jwbm3RvvxZGdovx1XXjyypZsDJDEuXwVSw\nEiTnG8VatQKBgCakQK166+sWWkwzVEchaDSl2k+MMfWIqXMqcWl2HqCB7q2oQARF\nq/3Pki8m91JEJFRXnqnCLh8A6k2wP6gOQuhgLAkKUHjj9YTo4ULTBcvhhYZpVnrF\nB4ivUbKdX5kqwfymPrK5N5tlqfr+cEv6xer1ybdcqaee8mXgQuJ2yi5JAoGBAJ9o\nIVprXJA5LA/CaaZ6S0iaVoO7/5Z6gAnJtgE9XiOrFkjbSVSYe7mCpRLpNbRXYL89\nAxZFgngkmGiXKe2NHvwKHH0SEmtYwpV7jnzUyHs6D3unod5fM97NlSbp2wNY4FsO\n+VtllnxebqngnNo44b81em2PxxiywFM76HaB/OWtAoGBAKkSri7319H0CDls6yQ7\n4eNeWy65LERH5EGKFLlWbO2DqbXRtfKtYojsTX0LFROu7bDbyehK4MZf3e8oPzhq\nqBryphiqZSHfqgH4WbQ+wu8qyhv4KEshG2NICFHytTRsfW0HUuIg00DuN18zL4iW\n2FVawMwtNp2rXfQzmIugpA+C\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-fz1bj@tournament-45ad2.iam.gserviceaccount.com",
        "client_id": "104229259016679015028",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fz1bj%40tournament-45ad2.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      }),
      [fireBaseEndPoint],
    );
    final accessToken = client.credentials.accessToken.data;
    print('Access Token : $accessToken');
    return accessToken;
  }

  Future<void> _sendNotification(String token, String title, String body,
      String accessToken, Map<String, dynamic> data) async {
    try {
      print('Payload: ${jsonEncode(data)}');
      final response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/tournament-45ad2/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'message': {
            'token': token,
            'notification': {
              'title': title,
              'body': body,
            },
            'data': data
          },
        }),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully to $token');
      } else {
        print(
            'Failed to send notification to $token. Status code: ${response.statusCode}, ${response.body} ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  void _handleNotificationNavigation(RemoteMessage message) {
    final data = message.data;
    final type = data['type'];
    print('typeMyMessage : ${message.data}');
    // Check notification type and navigate to corresponding screen
    switch (type) {
      case 'message':
        Get.to(
            () => MessageScreen(
                  receiverId: data['receiverId'],
                  receiverName: data['receiverName'],
                  receiverToken: data['receiverToken'],
                  userId: currentUser!.uid,
                ),
            transition: Transition.circularReveal);
        break;
      case 'MyMatchesTeamScreen':
        final bool isHomeScreen = bool.parse(data['isHomeScreen']);
        Get.to(
            () => MyMatchesTeamScreen(
                tournamentId: data['tournamentId'],
                userId: currentUser!.uid,
                isHomeScreen: isHomeScreen
            ),
            transition: Transition.circularReveal);
        break;
      case 'ViewTeamMatchSchedule':
        Get.to(() => ViewTeamMatchSchedule(
              tournamentId: data['tournamentId'],
            ));
        break;
      case 'ViewMyTournamentsTeams':
        final bool isHomeScreen = bool.parse(data['isHomeScreen']);
        Get.to(() => ViewMyTournamentsTeams(
            tournamentId: data['tournamentId'],
            userId: currentUser!.uid,
            isHomeScreen: isHomeScreen,
            isCompleted: data['isCompleted'].toString(),
            registerTeams: int.parse(data['registerTeams']),
            token: data['token']));
        break;
      default:
        Get.to(() => BottomScreen(userId: currentUser!.uid));
        break;
    }
  }
}
