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

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // 监听后台接受消息
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // 后端接口，记录接受消息人数
  // sendImpression(message);
}

//  后端接口，记录接受消息人数
Future<void> sendImpression(RemoteMessage message) async {
  String url = 'https://www.silverglad.com/app-show-impression4';
  var params = {
    'app': 'dmv',
    'push_id': message.data['id'],
    'msg_id': message.messageId
  };
  print('=============sentImpression');
  print(message);
  try {
    var res = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        // headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        // headers: {"Accept": "application/json"},
        body: json.encode(params),
        encoding: Encoding.getByName("utf-8"));
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      print(body);
    }
  } catch (error) {
    print(error);
  }
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
      // 后端接口，记录接受消息人数
      // sendImpression(message);
      // 展示推送
      // showNotification(message);
    });

    initializeNotifications();

    _testSetCurrentScreen();
    _requestNotificationPermission();
    // _getUsetSubscribeInfo();
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
    print('======================statusisGranted');
    print(status.isGranted);
    if (status.isGranted) {
      // 用户已授权推送权限
      _getUsetSubscribeInfo();
    } else {
      // 用户拒绝了推送权限
    }
  }

  // 获取用户 id
  Future<void> _getUsetSubscribeInfo() async {
    // token
    final fcmToken = await FirebaseMessaging.instance.getToken();
    // 本地信息
    Locale locale = WidgetsBinding.instance!.platformDispatcher.locale;
    final languageCode = locale.languageCode;
    final countryCode = locale.countryCode;
    // 项目版本
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    // 设备信息
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String phoneInfo =
        '${androidInfo.brand},${androidInfo.model},${androidInfo.manufacturer},${androidInfo.device},${androidInfo.version.release}';
    // 时差
    DateTime now = DateTime.now();
    Duration timeZoneOffset = now.timeZoneOffset;
    String timeZoneOffsetString = formatTimeZoneOffset(timeZoneOffset);
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
    // 订阅主题
    await FirebaseMessaging.instance.subscribeToTopic("all_user");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid') ?? '';
    if (uid == '') {
      print('=======================sendSubscribe');
      String resultUid = await sendSubscribe(fcmToken, languageCode,
          countryCode, packageInfo.version, phoneInfo, timeZoneOffsetString);
      await prefs.setString('uid', resultUid);
    }
  }

  Future<String> sendSubscribe(fcmToken, languageCode, countryCode, version,
      phoneInfo, timeZoneOffsetString) async {
    String url = 'https://push.silversiri.com/getAppSubscribe';

    var params = {
      'app': 'dmv',
      'token': fcmToken,
      'lang': languageCode,
      'country': countryCode,
      'version': version,
      'phone_info': phoneInfo,
      'time_zone': timeZoneOffsetString
    };
    var res = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        // headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        // headers: {"Accept": "application/json"},
        body: json.encode(params),
        encoding: Encoding.getByName("utf-8"));
    print('------------------');
    print(res.statusCode);
    print(res.body);
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      var uid = body['data']['uid'];
      return uid;
    } else {
      return '';
    }

    // var response =
    //     await Dio().post('https://push.silversiri.com/getAppSubscribe',
    //         // options: Options(headers: {
    //         //   'Content-Type': 'application/json; charset=UTF-8',
    //         // }),
    //         data: params);
  }

  // 展示推送
  Future<void> showNotification(RemoteMessage message) async {
    sendImpression(message);
    RemoteNotification? notification = message.notification;

    Map<String, dynamic> messageMap = {
      'messageId': message.messageId,
      'data': message.data,
    };

    const int notificationId = 0;
    const String channelName = 'channelName';
    const String channelDescription = 'channelDescription';
    String notificationTitle = notification!.title ?? '';
    String notificationContent = notification.body ?? '';

    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      channelName,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      // playSound: true,

      // sound: RawResourceAndroidNotificationSound('notification_sound'),
    );

    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationTitle,
      notificationContent,
      notificationDetails,
      payload: jsonEncode(messageMap),
    );
  }

  // 初始化推送
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  // 监听前台打开消息
  Future<void> onDidReceiveNotificationResponse(
      NotificationResponse response) async {
    String? payload = response.payload;
    RemoteMessage message = RemoteMessage.fromMap(jsonDecode(payload ?? ''));
    // 后端接口，记录打开人数
    // sendClick(message);
    // 跳转到指定页面
    // routePage(message);
  }

  Future<void> sendClick(RemoteMessage message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid') ?? '';
    var params = {
      'app': 'dmv',
      'u_id': uid,
      'push_id': message.data['id'],
      'msg_id': message.messageId
    };

    String url = 'https://www.silverglad.com/app_click_action4';
    print('=============sendClick');
    print(message);
    try {
      var res = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode(params),
          encoding: Encoding.getByName("utf-8"));
      if (res.statusCode == 200) {
        var body = json.decode(res.body);
        print(body);
      }
    } catch (error) {
      print(error);
    }
  }

  void routePage(RemoteMessage message) {}

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
    // return MaterialApp(
    //   home: Scaffold(
    //     body: Stack(
    //       children: [
    //         InkWell(
    //             onTap: () {
    //               _getUsetSubscribeInfo();
    //             },
    //             child: Center(
    //               child: Container(
    //                 width: 120,
    //                 height: 40,
    //                 decoration: BoxDecoration(color: Colors.orange),
    //                 margin: EdgeInsets.only(top: 120),
    //                 child: Text('推送测试按钮'),
    //               ),
    //             )),
    //         // StartPage(),
    //       ],
    //     ),
    //   ),
    // );
  }
}

String formatTimeZoneOffset(Duration offset) {
  String sign = offset.isNegative ? '-' : '+';
  int hours = offset.inHours.abs();
  int minutes = (offset.inMinutes.abs() % 60);
  return '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
}
