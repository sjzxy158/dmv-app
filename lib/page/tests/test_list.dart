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

import 'package:app/page/tab_navigator.dart';
import 'package:app/page/tests/test_detail.dart';

class TestListPage extends StatefulWidget {
  final int stateIndex;
  final String stateAbbr;
  final String stateValue;
  final String stateSlug;
  final int licenceIndex;
  final String licence;
  final String licenceLower;

  const TestListPage(
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
  _TestListPageState createState() => _TestListPageState();
}

List TEST_LIST = [];
int cur_type_index = -1;
String select_test_url = '';

int stateIndex = -1;
String stateAbbr = '';
String stateValue = '';
String stateSlug = '';
int licenceIndex = -1;
String licence = '';
String licenceLower = '';

class _TestListPageState extends State<TestListPage> {
  int testListLength = 0;
  int _getTestListStatus = -1;

  NativeAd? _ad;
  int _adError = 0;

  bool isInProduction = bool.fromEnvironment("dart.vm.product");
  String path = '';

  Future getTestList() async {
    setState(() {
      if (isInProduction) {
        path = productionApi.getTestsList;
      } else {
        path = silversiriApi.getTestsList;
      }
    });
    var res = await http.post(
      Uri.parse(path),
      body: {'type': licenceLower, 'state': stateSlug},
    );
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      // print(body['data']);
      setState(() {
        TEST_LIST = body['data'];
        testListLength = TEST_LIST.length;
        _getTestListStatus = res.statusCode;
      });
      // _setListStatus(TEST_LIST);
      return body;
    } else {
      return null;
    }
  }

  void initState() {
    stateIndex = widget.stateIndex;
    stateAbbr = widget.stateAbbr;
    stateValue = widget.stateValue;
    stateSlug = widget.stateSlug;
    licenceIndex = widget.licenceIndex;
    licence = widget.licence;
    licenceLower = widget.licenceLower;
    getTestList();

    NativeAd(
      adUnitId: AdHelper.nativeAdUnitId,
      factoryId: 'listTile',
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
    await FirebaseAnalytics.instance.setCurrentScreen(
      screenName: '${stateValue} ${licence} Tests List',
      screenClassOverride: '${stateValue} ${licence} Tests List',
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
            Container(
              margin:
                  EdgeInsets.only(top: statusBar + 106, left: 20, right: 20),
              // decoration: BoxDecoration(color: Colors.red),
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: _getTestListStatus == 200
                    ? TestDataList(
                        splitStateAbbr: stateAbbr,
                        urlStateSlug: stateSlug,
                      )
                    : _loadDownloadWidget(),
              ),
            ),
            Container(
                height: 96,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                margin:
                    EdgeInsets.only(top: statusBar + 48, left: 18, right: 18),
                padding: EdgeInsets.only(top: 20, bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        left: BorderSide(width: 2, color: Colors.white),
                        right: BorderSide(width: 2, color: Colors.white))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DMV Practice Tests',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xff333333),
                        fontFamily: 'Gilroy-Bold',
                      ),
                    ),
                    Text('$testListLength Sets Of Questions',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff999999),
                          fontFamily: 'GoogleSans-Regular',
                        )),
                  ],
                )),
            Container(
                height: 48,
                width: double.infinity,
                margin: EdgeInsets.only(top: statusBar),
                padding: EdgeInsets.only(left: 20, right: 20),
                // decoration: BoxDecoration(color: Colors.red),
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
                ))
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
            test_title: TEST_LIST[index]['name'],
            question_num: TEST_LIST[index]['question_num'],
            qualifying_num: TEST_LIST[index]['qualifying_num'],
            percent: TEST_LIST[index]['score_passing'] + '%',
            select_test_url: select_test_url,
            select_test_image_url:
                "images/pic/$licenceLower/$licenceLower-${index + 1}.png",
          );
        }));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: Container(
                // height: 120,
                // width: 210,
                child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image(
                  image: AssetImage(
                      "images/pic/$licenceLower/$licenceLower-${index + 1}.png")),
            )),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 3 / 4,
        ),
        scrollDirection: Axis.vertical,
        itemCount: TEST_LIST.length,
        itemBuilder: this._getTestList);
  }
}
