import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class testHomePage extends StatefulWidget {
  final String stateAbbr;
  final String stateSlug;
  final int licenceIndex;
  final String licenceLower;

  const testHomePage({
    Key? key,
    required this.stateAbbr,
    required this.stateSlug,
    required this.licenceIndex,
    required this.licenceLower,
  }) : super(key: key);

  @override
  _testHomePageState createState() => _testHomePageState();
}

List TEST_LIST = [];
List ROADSIGN_LIST = [];

int cur_type_index = -1;
String select_test_url = '';

class _testHomePageState extends State<testHomePage>
    with AutomaticKeepAliveClientMixin {
  String stateAbbr = '';
  String stateSlug = '';
  int licenceIndex = -1;
  String licenceLower = '';

  int _getTestListStatus = -1;
  int _getRognSignListStatus = -1;
  String homeTitle = 'Hello';

  NativeAd? _ad;
  int _adError = 0;
  bool _nativeAdIsLoaded = false;

  Future getTestList() async {
    String url = 'https://api-dmv.silversiri.com/getTestsList';
    var res = await http.post(
      Uri.parse(url),
      body: {'type': licenceLower, 'state': stateSlug},
    );
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      // print(body['data']);
      setState(() {
        TEST_LIST = body['data'];
        _getTestListStatus = res.statusCode;
      });
      // _setListStatus(TEST_LIST);
      return body;
    } else {
      return null;
    }
  }

  Future getRoadSignList() async {
    String url = 'https://api-dmv.silversiri.com/getRoadList';
    var res = await http.post(Uri.parse(url));
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      setState(() {
        ROADSIGN_LIST = body['data'];
        _getRognSignListStatus = res.statusCode;
      });
      return body;
    } else {
      return null;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    stateAbbr = widget.stateAbbr;
    stateSlug = widget.stateSlug;
    licenceIndex = widget.licenceIndex;
    licenceLower = widget.licenceLower;
    getTestList();
    getRoadSignList();
    DateTime now = DateTime.now();
    int hour = now.hour;
    print(hour);
    setState(() {
      if (hour > 6 && hour <= 11) {
        homeTitle = 'Good Morning';
      } else if (hour > 11 && hour <= 17) {
        homeTitle = 'Good Afternoon';
      } else {
        homeTitle = 'Good Evening';
      }
    });

    // if (loadedStatus) {
    //   _getListStatus();
    // } else {
    //   getTestList();
    //   getRoadSignList();
    // }

    cur_type_index = licenceIndex;
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
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    TextStyle barTextStyle = const TextStyle(
        color: Colors.white, fontSize: 16, fontFamily: 'GoogleSans-Regular');
    double statusBar = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: <Widget>[
            Container(
                child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: ListView(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          // decoration: BoxDecoration(color: Colors.blue),
                          padding:
                              EdgeInsets.only(top: 32, bottom: 8, left: 20),
                          child: Text(
                            homeTitle,
                            style: TextStyle(
                                fontSize: 32,
                                fontFamily: 'GoogleSans-Bold',
                                color: Colors.black),
                          ),
                        ),
                        _ad != null || _adError != 0
                            ? Container(
                                // decoration: BoxDecoration(color: Colors.red),
                                height: 240,
                                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                // margin: const EdgeInsets.only(top: 36)
                                alignment: Alignment.center,
                                child: AdWidget(ad: _ad!))
                            : Text(''),
                        Container(
                            margin: EdgeInsets.only(top: 20),
                            // decoration: BoxDecoration(color: Colors.red),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'DMV Practice Tests',
                                          style: TextStyle(
                                              fontFamily: 'Gilroy-Bold',
                                              fontSize: 22),
                                        ),
                                        SvgPicture.asset(
                                          'images/go.svg',
                                          width: 16,
                                          color: Color(0xffcccccc),
                                        )
                                      ]),
                                ),
                                Container(
                                  height: 210,
                                  margin: EdgeInsets.only(top: 24, left: 20),
                                  child: ScrollConfiguration(
                                    behavior: MyBehavior(),
                                    child: _getTestListStatus == 200
                                        ? TestDataList(
                                            splitStateAbbr: stateAbbr,
                                            urlStateSlug: stateSlug,
                                          )
                                        : _loadDownloadWidget(),
                                  ),
                                )
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.only(top: 32, bottom: 40),
                            // decoration: BoxDecoration(color: Colors.red),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Road Sign Test',
                                          style: TextStyle(
                                              fontFamily: 'Gilroy-Bold',
                                              fontSize: 22),
                                        ),
                                        SvgPicture.asset(
                                          'images/go.svg',
                                          width: 16,
                                          color: Color(0xffcccccc),
                                        )
                                      ]),
                                ),
                                Container(
                                  height: 210,
                                  margin: EdgeInsets.only(top: 24, left: 20),
                                  child: ScrollConfiguration(
                                    behavior: MyBehavior(),
                                    child: _getRognSignListStatus == 200
                                        ? RoadSignList()
                                        : _loadDownloadWidget(),
                                  ),
                                )
                              ],
                            ))
                      ],
                    )))
          ],
        ),
      ),
    );
  }

  Widget _loadDownloadWidget() {
    return const Center(
        child: CircularProgressIndicator(
            backgroundColor: Color.fromARGB(255, 37, 93, 217),
            valueColor:
                AlwaysStoppedAnimation(Color.fromARGB(255, 225, 225, 225))));
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

class TestDataList extends StatefulWidget {
  final String splitStateAbbr;
  final String urlStateSlug;

  const TestDataList(
      {Key? key, required this.splitStateAbbr, required this.urlStateSlug})
      : super(key: key);
  @override
  _TestDataListState createState() => _TestDataListState();
}

class _TestDataListState extends State<TestDataList> {
  String splitStateAbbr = '';
  String urlStateSlug = '';

  @override
  void initState() {
    splitStateAbbr = widget.splitStateAbbr;
    urlStateSlug = widget.urlStateSlug;
  }

  Widget _getTestList(context, index) {
    return InkWell(
        onTap: () {
          if (cur_type_index != 2) {
            select_test_url = 'https://www.dmv-test-pro.com/' +
                urlStateSlug +
                '/' +
                TEST_LIST[index]['slug'] +
                '/';
          } else {
            select_test_url = 'https://www.dmv-test-pro.com/' +
                urlStateSlug +
                '/' +
                splitStateAbbr.toLowerCase() +
                '-' +
                TEST_LIST[index]['slug'] +
                '/';
          }
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return MaterialApp(
              routes: {
                "/": (_) => WebviewScaffold(
                    url: select_test_url,
                    appBar: PreferredSize(
                        child: AppBar(
                          backgroundColor: Colors.white,
                        ),
                        preferredSize: Size.fromHeight(0.0))),
              },
              debugShowCheckedModeBanner: false,
            );
          }));
        },
        child: Stack(
          children: [
            Container(
                // height: 210,
                width: 160,
                margin: EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        'Practice Test 0${index + 1}',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'GoogleSans-Medium',
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2),
                      child: Text(
                        '${TEST_LIST[index]['question_num']} Questions',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff999999),
                          fontFamily: 'GoogleSans-Regular',
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: TEST_LIST.length,
        itemBuilder: this._getTestList);
  }
}

class RoadSignList extends StatefulWidget {
  @override
  _RoadSignListState createState() => _RoadSignListState();
}

class _RoadSignListState extends State<RoadSignList> {
  Widget _getRoadSignList(context, index) {
    return InkWell(
        onTap: () {
          String road_sign_url =
              'https://www.dmv-test-pro.com/road-sign-test/${ROADSIGN_LIST[index]['slug']}';
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return MaterialApp(
              routes: {
                "/": (_) => WebviewScaffold(
                    url: road_sign_url,
                    appBar: PreferredSize(
                        // child: AppBar(), preferredSize: const Size.fromHeight(0.0))),
                        child: AppBar(
                          backgroundColor: Colors.white,
                        ),
                        preferredSize: Size.fromHeight(0.0))),
              },
              debugShowCheckedModeBanner: false,
            );
          }));
        },
        child: Stack(
          children: [
            Container(
                // height: 210,
                width: 160,
                margin: EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        'Practice Test 0${index + 1}',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'GoogleSans-Medium',
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2),
                      child: Text(
                        '${ROADSIGN_LIST[index]['question_num']} Questions',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff999999),
                          fontFamily: 'GoogleSans-Regular',
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ROADSIGN_LIST.length,
        itemBuilder: this._getRoadSignList);
  }
}
