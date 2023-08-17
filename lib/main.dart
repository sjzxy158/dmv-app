import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import './app_open_ad_manager.dart';
import './app_lifecycle_rector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'page/start.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  sendImpression(message); // 后端接口，记录接受消息人数
}

//  后端接口，记录接受消息人数
Future sendImpression(message) async {
  print(message);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MyAppContent(
      analytics: analytics,
      observer: observer,
    );
  }
}

class MyAppContent extends StatefulWidget {
  const MyAppContent(
      {Key? key, required this.analytics, required this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  MyAppContentState createState() => MyAppContentState();
}

// class MyAppState extends State<MyApp> {
class MyAppContentState extends State<MyAppContent> {
  FirebaseAnalytics? analytics;
  FirebaseAnalyticsObserver? observer;

  @override
  void initState() {
    super.initState();

    analytics = widget.analytics;
    observer = widget.observer;
    // Load ads.
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    WidgetsBinding.instance!
        .addObserver(AppLifecycleReactor(appOpenAdManager: appOpenAdManager));

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      sendImpression(message); // 后端接口，记录接受消息人数
      showNotification(message);
    });

    _testSetCurrentScreen();
    // _requestNotificationPermission();
    _getUsetSubscribeInfo();
  }

  // 屏幕访问
  Future<void> _testSetCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'Home Page',
      screenClassOverride: 'HomePage',
    );
  }

  // 推送权限
  Future<void> _requestNotificationPermission() async {
    //  请求推送授权
    PermissionStatus status = await Permission.notification.request();
    // PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      // 用户已授权推送权限
      _getUsetSubscribeInfo();
    } else {
      // 用户拒绝了推送权限
    }
  }

  // 获取用户 id
  Future<void> _getUsetSubscribeInfo() async {
    // 本地信息
    Locale locale = WidgetsBinding.instance!.platformDispatcher.locale;

    final fcmToken = await FirebaseMessaging.instance.getToken();
    final languageCode = locale.languageCode;
    final countryCode = locale.countryCode;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    DateTime now = DateTime.now();
    Duration timeZoneOffset = now.timeZoneOffset;
    String timeZoneOffsetString = formatTimeZoneOffset(timeZoneOffset);

    print('------------------');
    // print(fcmToken);
    // print(languageCode);
    // print(countryCode);
    // print(packageInfo.version);
    // print(androidInfo);
    // print(androidInfo.brand);
    // print(androidInfo.model);
    // print(androidInfo.manufacturer);
    // print(androidInfo.device);
    // print(androidInfo.version.release);
    // print(androidInfo.isPhysicalDevice);
    // print(timeZoneOffsetString);
    String phoneInfo =
        '${androidInfo.brand},${androidInfo.model},${androidInfo.manufacturer},${androidInfo.device},${androidInfo.version.release}';

    String url = 'https://push.silversiri.com/getAppSubscribe';
    // var params = {
    //   'app': 'tb',
    //   'token': fcmToken,
    //   'lang': languageCode,
    //   'country': countryCode,
    //   'version': packageInfo.version,
    //   'phone_info': phoneInfo,
    //   'time_zone': timeZoneOffsetString
    // };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid') ?? '';
    if (uid == '') {
      // if (uid == '') {
      //   String result = await sendSubscribe(fcmToken, languageCode, countryCode,
      //       packageInfo.version, phoneInfo, timeZoneOffsetString);
      //   await prefs.setString('uid', result);
      // }
    }
  }

  // 展示推送
  Future<void> showNotification(message) async {
    initializeNotifications();
  }

  // 初始化推送
  Future<void> initializeNotifications() async {
    // finalandroidInitializationSettings =
    //     const AndroidInitializationSettings('mipmap/ic_launcher');
    // initializationSettings = InitializationSettings(
    //   android: androidInitializationSettings,
    // );
    // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  String formatTimeZoneOffset(Duration offset) {
    String sign = offset.isNegative ? '-' : '+';
    int hours = offset.inHours.abs();
    int minutes = (offset.inMinutes.abs() % 60);
    return '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OrientationBuilder(
        builder: (context, orientation) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp, // locks the app in portrait mode
            // add more orientations as needed
          ]);
          return const StartPage();
        },
      ),
    );
  }
}
