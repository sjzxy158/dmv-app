import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_analytics/firebase_analytics.dart';

import '../../ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:app/page/tab_navigator.dart';
import 'package:app/page/tests/roadsign_detail.dart';

class RoadSignListPage extends StatefulWidget {
  final int stateIndex;
  final String stateAbbr;
  final String stateValue;
  final String stateSlug;
  final int licenceIndex;
  final String licence;
  final String licenceLower;
  const RoadSignListPage(
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
  _RoadSignListPageState createState() => _RoadSignListPageState();
}

List ROADSIGN_LIST = [];
String select_test_url = '';

int stateIndex2 = -1;
String stateAbbr2 = '';
String stateValue2 = '';
String stateSlug2 = '';
int licenceIndex2 = -1;
String licence2 = '';
String licenceLower2 = '';

class _RoadSignListPageState extends State<RoadSignListPage> {
  int testListLength = 0;
  int _getRognSignListStatus = -1;

  bool isInProduction = bool.fromEnvironment("dart.vm.product");
  String Path = '';

  Future getRoadSignList() async {
    setState(() {
      if (isInProduction) {
        Path = 'https://api.dmv-test-pro.com/';
      } else {
        Path = 'https://api-dmv.silversiri.com/';
      }
    });
    String url = '${Path}getRoadList';
    var res = await http.post(
      Uri.parse(url),
    );
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      // print(body['data']);
      setState(() {
        ROADSIGN_LIST = body['data'];
        testListLength = ROADSIGN_LIST.length;
        _getRognSignListStatus = res.statusCode;
      });
      return body;
    } else {
      return null;
    }
  }

  void initState() {
    stateIndex2 = widget.stateIndex;
    stateAbbr2 = widget.stateAbbr;
    stateValue2 = widget.stateValue;
    stateSlug2 = widget.stateSlug;
    licenceIndex2 = widget.licenceIndex;
    licence2 = widget.licence;
    licenceLower2 = widget.licenceLower;
    getRoadSignList();
    _testSetCurrentScreen();
  }

  Future<void> _testSetCurrentScreen() async {
    await FirebaseAnalytics.instance.setCurrentScreen(
      screenName: 'Road Sign Tests List',
      screenClassOverride: 'Road Sign Tests List',
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
                child: _getRognSignListStatus == 200
                    ? RoadSignList()
                    : _loadDownloadWidget(),
              ),
            ),
            Container(
                height: 94,
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
                      'Road Sign Tests',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xff333333),
                        fontFamily: 'Gilroy-Bold',
                      ),
                    ),
                    Text('6 Sets Of Questions',
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
                            stateIndex: stateIndex2,
                            stateAbbr: stateAbbr2,
                            stateValue: stateValue2,
                            stateSlug: stateSlug2,
                            licenceIndex: licenceIndex2,
                            licence: licence2,
                            licenceLower: licenceLower2,
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

class RoadSignList extends StatefulWidget {
  @override
  _RoadSignListState createState() => _RoadSignListState();
}

class _RoadSignListState extends State<RoadSignList> {
  Widget _getTestList(context, index) {
    return InkWell(
      onTap: () {
        String road_sign_url =
            'https://www.dmv-test-pro.com/road-sign-test/${ROADSIGN_LIST[index]['slug']}';
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RoadSignDetailPage(
            stateIndex: stateIndex2,
            stateAbbr: stateAbbr2,
            stateValue: stateValue2,
            stateSlug: stateSlug2,
            licenceIndex: licenceIndex2,
            licence: licence2,
            licenceLower: licenceLower2,
            test_title: ROADSIGN_LIST[index]['name'],
            question_num: ROADSIGN_LIST[index]['question_num'],
            qualifying_num: ROADSIGN_LIST[index]['qualifying_num'],
            percent: '60%',
            select_test_url: road_sign_url,
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
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
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
        itemCount: ROADSIGN_LIST.length,
        itemBuilder: this._getTestList);
  }
}
