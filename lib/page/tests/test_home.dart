import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_analytics/firebase_analytics.dart';

import '../../ad_helper.dart';
import '../../http/api.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app/page/tests/test_list.dart';
import 'package:app/page/tests/roadsign_list.dart';
import 'package:app/page/tests/test_detail.dart';
import 'package:app/page/tests/roadsign_detail.dart';

class TestHomePage extends StatefulWidget {
  final int stateIndex;
  final String stateAbbr;
  final String stateValue;
  final String stateSlug;
  final int licenceIndex;
  final String licence;
  final String licenceLower;

  const TestHomePage(
      {Key? key,
      required this.stateIndex,
      required this.stateAbbr,
      required this.stateValue,
      required this.stateSlug,
      required this.licenceIndex,
      required this.licence,
      required this.licenceLower})
      : super(key: key);

  @override
  _TestHomePageState createState() => _TestHomePageState();
}

List TEST_LIST = [];
List ROADSIGN_LIST = [];

int cur_type_index = -1;
String select_test_url = '';
int stateIndex = -1;
String stateAbbr = '';
String stateValue = '';
String stateSlug = '';
int licenceIndex = -1;
String licence = '';
String licenceLower = '';

String testDetailTitle = '';

class _TestHomePageState extends State<TestHomePage>
    with AutomaticKeepAliveClientMixin {
  int testListLength = 0;

  int _getTestListStatus = -1;
  int _getRognSignListStatus = -1;
  String homeTitle = 'Hello';
  String testTitle = 'DMV Practice Tests';

  NativeAd? _ad;
  int _adError = 0;

  bool isInProduction = bool.fromEnvironment("dart.vm.product");
  String testPath = '';
  String roadPath = '';

  Future getTestList() async {
    setState(() {
      if (isInProduction) {
        testPath = productionApi.getTestsList;
      } else {
        testPath = silversiriApi.getTestsList;
      }
    });
    var res = await http.post(
      Uri.parse(testPath),
      body: {'type': licenceLower, 'state': stateSlug},
    );
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      setState(() {
        TEST_LIST = body['data'];
        testListLength = TEST_LIST.length;
        _getTestListStatus = res.statusCode;
      });
      return body;
    } else {
      return null;
    }
  }

  Future getRoadSignList() async {
    setState(() {
      if (isInProduction) {
        roadPath = productionApi.getRoadList;
      } else {
        roadPath = silversiriApi.getRoadList;
      }
    });
    var res = await http.post(Uri.parse(roadPath));
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
    stateIndex = widget.stateIndex;
    stateAbbr = widget.stateAbbr;
    stateValue = widget.stateValue;
    stateSlug = widget.stateSlug;
    licenceIndex = widget.licenceIndex;
    licence = widget.licence;
    licenceLower = widget.licenceLower;
    getTestList();
    getRoadSignList();
    DateTime now = DateTime.now();
    int hour = now.hour;
    setState(() {
      if (hour > 6 && hour <= 11) {
        homeTitle = 'Good Morning';
      } else if (hour > 11 && hour <= 17) {
        homeTitle = 'Good Afternoon';
      } else {
        homeTitle = 'Good Evening';
      }
      if (licenceIndex == 0) {
        testTitle = 'DMV Practice Tests';
        testDetailTitle = '${stateAbbr} DMV Practice Test';
      } else if (licenceIndex == 1) {
        testTitle = 'Motorcycle Practice Tests';
        testDetailTitle = '${stateAbbr} Motorcycle Practice Test';
      } else if (licenceIndex == 2) {
        testTitle = 'CDL Practice Tests';
      }
    });
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
    await FirebaseAnalytics.instance.setCurrentScreen(
      screenName: '${stateValue} ${licence} Tests',
      screenClassOverride: '${stateValue} ${licence} Tests',
    );
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
                            stateValue,
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
                                  margin: EdgeInsets.only(left: 20),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          testTitle,
                                          style: TextStyle(
                                              fontFamily: 'Gilroy-Bold',
                                              fontSize: 22),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return TestListPage(
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
                                          child: Container(
                                            width: 68,
                                            height: 24,
                                            alignment: Alignment.centerRight,
                                            padding: EdgeInsets.only(
                                                left: 32, right: 20),
                                            // decoration: BoxDecoration(
                                            //     color: Colors.red),
                                            child: SvgPicture.asset(
                                              'images/go.svg',
                                              width: 16,
                                              color: Color(0xffcccccc),
                                            ),
                                          ),
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
                                  margin: EdgeInsets.only(left: 20),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Road Sign Tests',
                                          style: TextStyle(
                                              fontFamily: 'Gilroy-Bold',
                                              fontSize: 22),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return RoadSignListPage(
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
                                          child: Container(
                                            width: 68,
                                            height: 24,
                                            alignment: Alignment.centerRight,
                                            padding: EdgeInsets.only(
                                                left: 32, right: 20),
                                            child: SvgPicture.asset(
                                              'images/go.svg',
                                              width: 16,
                                              color: Color(0xffcccccc),
                                            ),
                                          ),
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
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return TestDetailPage(
              stateIndex: stateIndex,
              stateAbbr: stateAbbr,
              stateValue: stateValue,
              stateSlug: stateSlug,
              licenceIndex: licenceIndex,
              licence: licence,
              licenceLower: licenceLower,
              test_index: index + 1,
              test_title: licenceIndex == 2
                  ? '${TEST_LIST[index]['name']}'
                  : '$testDetailTitle ${index + 1}',
              question_num: TEST_LIST[index]['question_num'],
              qualifying_num: TEST_LIST[index]['qualifying_num'],
              percent: TEST_LIST[index]['score_passing'] + '%',
              select_test_url: select_test_url,
              select_test_image_url:
                  "images/pic/$licenceLower/$licenceLower-${index + 1}.png",
            );
          }));
        },
        child: Stack(
          children: [
            licenceIndex == 2
                ? Container(
                    // height: 210,
                    width: 160,
                    margin: EdgeInsets.only(right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            height: 160,
                            width: 160,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image(
                                  image: AssetImage(
                                      "images/pic/$licenceLower/$licenceLower-${index + 1}.png")),
                            )),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Text(
                            TEST_LIST[index]['name'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'GoogleSans-Medium',
                            ),
                          ),
                        ),
                        Container(
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
                    ))
                : Container(
                    // height: 210,
                    width: 160,
                    margin: EdgeInsets.only(right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            height: 160,
                            width: 160,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image(
                                  image: AssetImage(
                                      "images/pic/$licenceLower/$licenceLower-${index + 1}.png")),
                            )),
                        Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Text(
                            'Practice Test ${index + 1}',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'GoogleSans-Medium',
                            ),
                          ),
                        ),
                        Container(
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
                    ))
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
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return RoadSignDetailPage(
              stateIndex: stateIndex,
              stateAbbr: stateAbbr,
              stateValue: stateValue,
              stateSlug: stateSlug,
              licenceIndex: licenceIndex,
              licence: licence,
              licenceLower: licenceLower,
              test_index: index + 1,
              test_title: ROADSIGN_LIST[index]['name'],
              question_num: ROADSIGN_LIST[index]['question_num'],
              qualifying_num: ROADSIGN_LIST[index]['qualifying_num'],
              percent: '60%',
              select_test_url: road_sign_url,
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image(
                              image: AssetImage(
                                  "images/signs/sign-${index + 1}.png")),
                        )),
                    index == 5
                        ? Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              'True-False Test',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'GoogleSans-Medium',
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              'Practice Test ${index + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'GoogleSans-Medium',
                              ),
                            ),
                          ),
                    Container(
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
