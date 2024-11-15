import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../auth_screen/login_Screen.dart';
import '../consts/firebase_consts.dart';


class NotificationServices {
  final String fireBaseEndPoint = 'https://www.googleapis.com/auth/firebase.messaging';
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User denied permission');
    }
  }

  Future<void> firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      initLocalNotification(context, message);
      showNotification(message);
    });
  }

  Future<void> initLocalNotification(BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
          handleMessage(context, message);
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

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
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

    DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel:InterruptionLevel.active,
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
    await fireStore.collection(usersCollection).doc(token).set({'token': token});
  }

  Future<void> sendNotificationToAllUsers(String title, String body, collection) async {
    List<String> tokens = await _getAllUserTokens(collection);
    String accessToken = await getAccessToken();

    for (String token in tokens) {
      await _sendNotification(token, title, body, accessToken);
    }
  }

  Future<void> sendNotificationToSingleUser(String token,String title, String body) async {
    String accessToken = await getAccessToken();
    await _sendNotification(token, title, body, accessToken);
  }



  Future<List<String>> _getAllUserTokens(collection) async {
    List<String> tokens = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(collection).get();
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
        "private_key_id": "d8611b604cccd979757398d4e1f9049e78f548ff",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC4gwp1AQFq215L\nEbkHQ915Ts4wVMviBanx3hFsIloYDtF35tQtTnwrKoschcdNQxYbsn3x7UzbACa/\ndeQLcLXJzs1LCKX8ZdvO5/RmA8+t0t+X74bAQe5KtGiArh8sglVKcIacu5+f7UXF\n+kDPjcu9g3qf42iJMlppdt/0Lmri9JZslJ/UmDolfGQdb6mXboeKeQvgkG30Sr5t\ne3bSJbDgbXjXTs93/OdslLT9Jac/iW2pw9PbeJSwk0JUo+cTHSWSBaAaKtyfLpJK\n6/mzb/S2QsRQkecyZ+l1hN104B7yGhgfOMeJL7zHX+I7oCxU5l5e/Rd2Ja31+sfy\n3SiYhI95AgMBAAECggEAFqna5JcGZ2uRVBd10pmAiFRYkXly7xzqvFeebHm2NwcH\n7eo7lOKTcCJqQqtAeSIkwqtsmqUfF/XXbJREme6i16pYD0+9Qqi4xHv7ijXM4kEY\n/4K3eqFGjaTGAstQbzFFnG6ArFsD7vsQI1KbOBtGw60VCHNgfVyi3BoyxT2X2a9D\nhr7ugk9M+G1Wwr7QTclDt6lW3PnoCAcdONaAdxQ2xXiQmFqT2XsbBZQSxoPzxj9/\nv4HJgBe3HAqOf1qEfFNw8Cuw1NEjnV3R+RBz3G8zek4Tj5+ODdJirfCyn6m4NJ8D\nB/HGBmw9T9ytlhWlk6M3+ljMK0tIQKQ549x4MZqgUQKBgQDJEzwhbzyEFQWXWM1V\nswNgICYSm/l52vA8biFcIQ1XJpvr1D2niunGMBPvkSq9Gsq0CTQ2yRBePj14SJOO\nxsJ+VjRCSYtmCrd8a/RNHVByK4SlsPOd7EFPwyt1hLQ4nzI3ByD21mKTWVWNbzEa\ntKZDN5Oz1DRmWwMhpXV9QBjxyQKBgQDq6ZJlhvmJzAhk6K3SjSoTWMidkMcuPBWY\n8KHwUDqyeH23Is6/WibyOj78aYEYyEjiRw7P9FwIvUdQcrYf4QaMlItoFCWZ4zx1\nxtklmX7+U3gyIq52tOwQtVKYLIUv8CFwhnql5iQQhZoOjlt/aZTwADoms5cMevq/\n0QZewrAIMQKBgQCEU+5MqqIO4q7NTZnEfo0II+Aqew+RzC4x9uBpey8GXdhbOVBi\nBJ+Y2GcmUEjqLsmb9jqwm130R824bTr+yXuSHTVDMpdUzlS2w20BmvsoR8+CI5QQ\nKD1LOsxNCMp6QPqREFX3XFt/UVlmPPj59E0/C0JfJJZfjiHfcL6DcT15UQKBgGO0\nT1aYO0GpP8bUmzJKiBk+DagS0vdkuSX4vELrSn6FdZZNR8Mf2HfnEOTBQvHp0EV6\nM2dAJ+/tpl8W0QYm1EjGo4TBSFRQhlDW3UOAKs53TwS4g6QOlkNhMnU0MDNwkEDa\nUyQm0hfRHNogweUKQxS6g/P5NZsud08CwNlneJ+BAoGBALZMy6tLwMUSV+7QUQaU\nQ1Bz1JhYfVXYQDsRddB+BMQMTzqBM3Lodu8yVAbwuPzmkiUqLtKPuckZSLaQPEd9\nVSeNzv6YQODL4Md5U/WG2e/wmzBeBVK+FwFQm3wpbY1yN0ZON8r1hWDX9UR8hqMD\nTfkqOD9FAb9KO9ddLgTDzSbb\n-----END PRIVATE KEY-----\n",
        "client_email": "firebase-adminsdk-fz1bj@tournament-45ad2.iam.gserviceaccount.com",
        "client_id": "104229259016679015028",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fz1bj%40tournament-45ad2.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      }), [fireBaseEndPoint],
    );
    final accessToken = client.credentials.accessToken.data;
    print('Access Token : $accessToken');
    return accessToken;
  }

  Future<void> _sendNotification(String token, String title, String body, String accessToken) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/v1/projects/tournament-45ad2/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'message': {
            'token': token,
            'notification': {'title': title, 'body': body},
          },
        }),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully to $token');
      } else {
        print('Failed to send notification to $token. Status code: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'message') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }
}
