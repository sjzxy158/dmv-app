import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import './app_open_ad_manager.dart';
import './app_lifecycle_rector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'page/start.dart';

// List<String> testDeviceIds = ['2C3672609B2CB70494C68A2DD3D5C79F'];
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   MobileAds.instance.initialize();
//   runApp(const MyApp());
// }
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//   @override
//   MyAppState createState() => MyAppState();
// }
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

    _testSetCurrentScreen();
    _requestNotificationPermission();
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
    if (status.isGranted) {
      // 用户已授权推送权限
    } else {
      // 用户拒绝了推送权限
    }
  }

  // 获取用户 id
  Future<void> _getUsetSubscribeInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid') ?? '';

    // if (uid == '') {
    //   String result = await sendSubscribe(fcmToken, languageCode, countryCode,
    //       packageInfo.version, phoneInfo, timeZoneOffsetString);
    //   await prefs.setString('uid', result);
    // }
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
      // title: 'Welcome to DMV',
      // theme: ThemeData(primarySwatch: Colors.green, primaryColor: Colors.white),
      // routes: {
      //   "/": (_) => WebviewScaffold(
      //       // url: "https://www.menuwithnutrition.com/",
      //       // url: "https://dmv.silversiri.com",
      //       url: "https://www.dmv-test-pro.com",
      //       appBar: PreferredSize(
      //           // child: AppBar(), preferredSize: const Size.fromHeight(0.0))),
      //           child: AppBar(
      //             backgroundColor: Colors.white,
      //           ),
      //           preferredSize: Size.fromHeight(0.0))),
      // },
      // debugShowCheckedModeBanner: false,
    );
  }
}
