import 'dart:io';
import 'dart:math' as math;

import '../../ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/page/tab_navigator.dart';

class TestDetailPage extends StatefulWidget {
  final int stateIndex;
  final String stateAbbr;
  final String stateValue;
  final String stateSlug;
  final int licenceIndex;
  final String licence;
  final String licenceLower;

  final int test_index;
  final String test_title;
  final int question_num;
  final int qualifying_num;
  final String percent;
  final String select_test_url;
  final String select_test_image_url;
  const TestDetailPage({
    Key? key,
    required this.stateIndex,
    required this.stateAbbr,
    required this.stateValue,
    required this.stateSlug,
    required this.licenceIndex,
    required this.licence,
    required this.licenceLower,
    required this.test_index,
    required this.test_title,
    required this.question_num,
    required this.qualifying_num,
    required this.percent,
    required this.select_test_url,
    required this.select_test_image_url,
  }) : super(key: key);

  @override
  _TestDetailPageState createState() => _TestDetailPageState();
}

class _TestDetailPageState extends State<TestDetailPage> {
  NativeAd? _ad;
  int _adError = 0;

  int stateIndex = -1;
  String stateAbbr = '';
  String stateValue = '';
  String stateSlug = '';
  int licenceIndex = -1;
  String licence = '';
  String licenceLower = '';
  int test_index = -1;
  String test_title = '';
  int question_num = -1;
  int qualifying_num = -1;
  String percent = '';
  String select_test_url = '';
  String select_test_image_url = '';

  @override
  void initState() {
    stateIndex = widget.stateIndex;
    stateAbbr = widget.stateAbbr;
    stateValue = widget.stateValue;
    stateSlug = widget.stateSlug;
    licenceIndex = widget.licenceIndex;
    licence = widget.licence;
    licenceLower = widget.licenceLower;
    test_index = widget.test_index;
    test_title = widget.test_title;
    question_num = widget.question_num;
    qualifying_num = widget.qualifying_num;
    percent = widget.percent;
    select_test_url = widget.select_test_url;
    select_test_image_url = widget.select_test_image_url;

    if (Platform.isAndroid) WebView.platform = AndroidWebView();

    NativeAd(
      adUnitId: AdHelper.nativeAdUnitId,
      factoryId: 'fullTile',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad = ad as NativeAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          setState(() {
            _adError = error.code;
          });
          debugPrint(
              'Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    ).load();
    _testSetCurrentScreen();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  Future<void> _testSetCurrentScreen() async {
    String current_title = '';
    if (licenceIndex == 2) {
      current_title = '$stateValue $licence $test_index';
    } else {
      current_title = '$stateValue $licence Test $test_index';
    }
    await FirebaseAnalytics.instance.setCurrentScreen(
      screenName: '$current_title',
      screenClassOverride: '$current_title',
    );
  }

  @override
  Widget build(BuildContext context) {
    double statusBar = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: <Widget>[
            Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return Scaffold(
                        body: Container(
                          margin: EdgeInsets.only(top: statusBar),
                          child: WebView(
                            initialUrl: select_test_url,
                            javascriptMode: JavascriptMode.unrestricted,
                          ),
                        ),
                      );
                    }));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        color: Color(0Xff255dd9),
                        borderRadius: BorderRadius.circular(28)),
                    child: Text(
                      'Start Practicing',
                      style: TextStyle(
                          fontFamily: 'GoogleSans-Medium',
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                )),
            Container(
              margin: EdgeInsets.only(
                  top: statusBar + 7, left: 20, right: 20, bottom: 104),
              // decoration: BoxDecoration(color: Colors.red),
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 24),
                        // decoration: BoxDecoration(color: Colors.blue),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              test_title,
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: 'Gilroy-Bold',
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 240,
                              margin: EdgeInsets.only(top: 16, bottom: 24),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage(select_test_image_url),
                                ),
                              ),
                              // child: ClipRRect(
                              //   borderRadius: BorderRadius.circular(8),
                              //   child: Image(
                              //       image: AssetImage(select_test_image_url)),
                              // )
                            ),
                            _infoItem(
                                'questions',
                                'Number of Questions',
                                question_num.toString(),
                                0xff7a859e,
                                16.0,
                                16.0),
                            _infoItem(
                                'qualifying',
                                'Qualifying marks',
                                qualifying_num.toString(),
                                0xff38c296,
                                12.0,
                                12.0),
                            _infoItem('passing', 'Passing Score', percent,
                                0xff38c296, 16.0, 16.0),
                            _ad != null || _adError != 0
                                ? Container(
                                    // decoration: BoxDecoration(color: Colors.red),
                                    height: 240,
                                    margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                    // margin: const EdgeInsets.only(top: 36)
                                    alignment: Alignment.center,
                                    child: AdWidget(ad: _ad!))
                                : Text(''),
                          ],
                        ))
                  ],
                ),
              ),
            ),
            Container(
                height: 72,
                width: double.infinity,
                margin: EdgeInsets.only(top: statusBar),
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 24),
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Transform.rotate(
                          angle: math.pi,
                          child: SvgPicture.asset(
                            'images/go.svg',
                            width: 20,
                            height: 20,
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TabNavigator(
                            stateIndex: stateIndex,
                            stateAbbr: stateAbbr,
                            stateValue: stateValue,
                            stateSlug: stateSlug,
                            licenceIndex: licenceIndex,
                            licence: licence,
                            licenceLower: licenceLower,
                          );
                        }));
                      },
                      child: SvgPicture.asset(
                        'images/tests.svg',
                        width: 20,
                        height: 20,
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  _infoItem(icon, title, String number, color, width, height) {
    return Container(
      height: 48,
      padding: EdgeInsets.only(left: 20, right: 20),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: Color(0xfff7f9fb), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                'images/$icon.svg',
                width: width,
                height: height,
                color: Color(color),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  title,
                  style: TextStyle(
                      fontFamily: 'GoogleSans-Medium',
                      fontSize: 16,
                      color: Colors.black),
                ),
              )
            ],
          ),
          Text(
            number,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) {
      return child;
    } else {
      return super.buildViewportChrome(context, child, axisDirection);
    }
  }
}
