import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class testListPage extends StatefulWidget {
  final int stateIndex;
  final String stateAbbr;
  final String stateValue;
  final String stateSlug;
  final int licenceIndex;
  final String licence;
  final String licenceLower;

  const testListPage(
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
  _testListPageState createState() => _testListPageState();
}

List STATE_LIST = [];
List TYPE_LIST = [
  {
    "slug": 'car',
    "value": 'Car',
  },
  {
    "slug": 'motorcycle',
    "value": 'Motorcycle',
  },
  {
    "slug": 'cdl',
    "value": 'CDL',
  }
];
List TEST_LIST = [
  {"id": 'DMV Test 1', "name": 'DMV Practice Test 1'},
  {"id": 'DMV Test 2', "name": 'DMV Practice Test 2'},
  {"id": 'DMV Test 3', "name": 'DMV Practice Test 3'},
  {"id": 'DMV Test 4', "name": 'DMV Practice Test 4'},
  {"id": 'DMV Test 5', "name": 'DMV Practice Test 5'},
  {"id": 'DMV Test 6', "name": 'DMV Practice Test 6'},
  {"id": 'DMV Test 7', "name": 'DMV Practice Test 7'},
  {"id": 'DMV Test 8', "name": 'DMV Practice Test 8'},
  {"id": 'DMV Test 9', "name": 'DMV Practice Test 9'},
];

int cur_state_index = -1;
int select_state_index = -1;
String select_state_abbr = '';
String select_state = '';
String select_state_slug = '';

int cur_type_index = -1;
int select_type_index = -1;
String select_type_value = '';
String select_type = '';

int cur_test_index = -1;
int select_test_index = -1;
String select_test_abbr = '';
String select_test_value = '';
int select_test_ques = 0;
int select_test_pass = 0;
String select_test_url = '';

class _testListPageState extends State<testListPage> {
  int stateIndex = -1;
  String stateAbbr = '';
  String stateValue = '';
  String stateSlug = '';
  int licenceIndex = -1;
  String licence = '';
  String licenceLower = '';
  int testIndex = 0;
  String testAbbr = '';
  String testValue = '';

  int TestSumNum = 0;
  int TestQueNum = 0;
  int TestPassNum = 0;

  String TestUrl = '';

  int _getTestListStatus = -1;

  NativeAd? _ad;
  int _adError = 0;
  bool _nativeAdIsLoaded = false;

  Future getStateList() async {
    String url = 'https://api-dmv.silversiri.com/getStateList';
    var res = await http.post(Uri.parse(url));
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      setState(() {
        STATE_LIST = body['data'];
      });
      return body;
    } else {
      return null;
    }
  }

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
        TestSumNum = body['data'].length;
        _getTestListStatus = res.statusCode;
        cur_test_index = testIndex;
        if (licenceLower != 'cdl') {
          testAbbr = 'DMV Test ' + TEST_LIST[0]['orders'].toString();
          testValue = TEST_LIST[0]['name'].split(stateAbbr)[1].trimLeft() +
              ' ' +
              TEST_LIST[0]['orders'].toString();
          TestUrl = 'https://www.dmv-test-pro.com/' +
              stateSlug +
              '/' +
              TEST_LIST[0]['slug'] +
              '/';
        } else {
          testAbbr = TEST_LIST[0]['name'].split(' - ')[0];
          testValue =
              TEST_LIST[0]["name"] + ' ' + TEST_LIST[0]['orders'].toString();
          TestUrl = 'https://www.dmv-test-pro.com/' +
              stateSlug +
              '/' +
              stateAbbr.toLowerCase() +
              '-' +
              TEST_LIST[0]['slug'] +
              '/';
        }
        TestQueNum = TEST_LIST[0]['question_num'];
        TestPassNum = TEST_LIST[0]['qualifying_num'];
      });
      return body;
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getStateList();
    stateIndex = widget.stateIndex;
    stateAbbr = widget.stateAbbr;
    stateValue = widget.stateValue;
    stateSlug = widget.stateSlug;
    licenceIndex = widget.licenceIndex;
    licence = widget.licence;
    licenceLower = widget.licenceLower;
    getTestList();

    cur_state_index = stateIndex;
    cur_type_index = licenceIndex;
    cur_test_index = testIndex;

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
  Widget build(BuildContext context) {
    TextStyle barTextStyle = const TextStyle(
        color: Colors.white, fontSize: 16, fontFamily: 'GoogleSans-Regular');
    double statusBar = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Color(0xffdddddd)),
        child: Stack(
          children: [
            _getTestListStatus == 200
                ? Container(
                    margin: EdgeInsets.only(top: statusBar + 38),
                    child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: ListView(
                          children: <Widget>[
                            Container(
                                width: double.infinity,
                                height: 280,
                                margin: EdgeInsets.only(left: 16, right: 16),
                                padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "$stateValue Driver's Examination",
                                      style: TextStyle(
                                        fontFamily: 'GoogleSans-Medium',
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "(From the 2021 $stateValue driver handbook)",
                                      style: TextStyle(
                                        fontFamily: 'GoogleSans-Regular',
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 16, bottom: 16),
                                      child: Text(
                                        "$TestSumNum tests",
                                        style: TextStyle(
                                          fontFamily: 'GoofleSans-Regular',
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 2,
                                      color: Colors.grey,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 20),
                                      child: Text(
                                        testValue,
                                        style: TextStyle(
                                          fontFamily: 'GoogleSans-Bold',
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 152,
                                          // constraints:BoxConstraints(
                                          //   minWidth:
                                          // ),
                                          padding: EdgeInsets.fromLTRB(
                                              24, 12, 24, 8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: Color(0xffe8f0fe)),
                                          child: Column(children: [
                                            Text('Numbers of questions',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'GoogleSans-Medium',
                                                  fontSize: 12,
                                                ),
                                                textAlign: TextAlign.center),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: Text(
                                                '$TestQueNum',
                                                style: TextStyle(
                                                  fontFamily: 'GoogleSans-Bold',
                                                  fontSize: 22,
                                                  color: Color(0xff255dd9),
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ),
                                        Container(
                                          width: 152,
                                          padding: EdgeInsets.fromLTRB(
                                              48, 12, 48, 8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: Color(0xffe8f0fe)),
                                          child: Column(children: [
                                            Text('Passing score',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'GoogleSans-Medium',
                                                  fontSize: 12,
                                                ),
                                                textAlign: TextAlign.center),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: Text(
                                                '$TestPassNum',
                                                style: TextStyle(
                                                  fontFamily: 'GoogleSans-Bold',
                                                  fontSize: 22,
                                                  color: Color(0xff255dd9),
                                                ),
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                            _ad != null || _adError != 0
                                ? Container(
                                    // height: 420,
                                    height: 248,
                                    margin: EdgeInsets.fromLTRB(4, 16, 4, 0),
                                    // margin: const EdgeInsets.only(top: 36)
                                    alignment: Alignment.center,
                                    child: AdWidget(ad: _ad!))
                                : Text(''),
                            InkWell(
                              onTap: () {
                                // print(TestUrl);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  // return WebView(
                                  //   initialUrl: 'https://www.dmv-test-pro.com',
                                  // );
                                  return MaterialApp(
                                    routes: {
                                      "/": (_) => WebviewScaffold(
                                          url: TestUrl,
                                          appBar: PreferredSize(
                                              // child: AppBar(), preferredSize: const Size.fromHeight(0.0))),
                                              child: AppBar(
                                                backgroundColor: Colors.white,
                                              ),
                                              preferredSize:
                                                  Size.fromHeight(0.0))),
                                    },
                                    debugShowCheckedModeBanner: false,
                                  );
                                }));
                              },
                              child: Container(
                                  height: 48,
                                  width: 200,
                                  margin: EdgeInsets.only(
                                    top: 12,
                                    left: 100,
                                    right: 100,
                                    bottom: 24,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Color(0xff255dd9)),
                                  child: Center(
                                    child: Text(
                                      'Start',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'GoogleSans-Bold',
                                          fontSize: 18),
                                    ),
                                  )),
                            ),
                          ],
                        )))
                : _loadDownloadWidget(),
            Container(
                height: 56,
                margin: EdgeInsets.only(top: statusBar),
                padding: EdgeInsets.only(left: 16, right: 16),
                width: double.infinity,
                decoration: BoxDecoration(color: Color(0xff255dd9)),
                child: Stack(
                  children: [
                    Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 开启州列表弹框
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  isDismissible: true, //点击空白处返回功能，默认是true
                                  enableDrag: true, //是否允许拖动
                                  elevation: 10,
                                  barrierColor:
                                      Colors.black.withOpacity(0.2), //空白处的颜色
                                  backgroundColor: Colors.white, //背景颜色
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  )), //圆角
                                  context: context,
                                  builder: (context) {
                                    return Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          child: Center(
                                            child: Container(
                                              margin: EdgeInsets.only(top: 8),
                                              width: 60,
                                              height: 4,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Color(0xffdddddd),
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(top: 28),
                                            padding: EdgeInsets.only(
                                                bottom: 12,
                                                left: 16,
                                                right: 16),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 1,
                                                        color: Color(
                                                            0xffdddddd)))),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    // 取消
                                                    'Cancel',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'GoogleSans-Medium',
                                                        fontSize: 14,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                Text(
                                                  'Select the State',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'GoogleSans-Medium',
                                                      fontSize: 14,
                                                      color: Color(0xff000000)),
                                                ),
                                                // 确定
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      cur_state_index =
                                                          select_state_index;
                                                      stateValue = select_state;
                                                      stateAbbr =
                                                          select_state_abbr;
                                                      stateSlug =
                                                          select_state_slug;
                                                      _getTestListStatus = -1;
                                                    });
                                                    getTestList();
                                                    _setStateSelectStatus(
                                                        cur_state_index,
                                                        stateAbbr,
                                                        stateValue,
                                                        stateSlug);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'Done',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'GoogleSans-Medium',
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff255dd9)),
                                                  ),
                                                )
                                              ],
                                            )),
                                        Container(
                                          height: 200,
                                          margin: EdgeInsets.only(top: 59),
                                          child: ScrollConfiguration(
                                            behavior: MyBehavior(),
                                            child: StateDataList(),
                                          ),
                                        )
                                      ],
                                    );
                                  });
                            },
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 8),
                                  child: Text(
                                    stateAbbr,
                                    style: barTextStyle,
                                  ),
                                ),
                                SvgPicture.asset(
                                    'images/arrow-down-filling.svg',
                                    width: 12)
                              ],
                            ),
                          ),
                          // 开启题目选择弹框
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  isDismissible: true, //点击空白处返回功能，默认是true
                                  enableDrag: true, //是否允许拖动
                                  elevation: 10,
                                  barrierColor:
                                      Colors.black.withOpacity(0.2), //空白处的颜色
                                  backgroundColor: Colors.white, //背景颜色
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  )), //圆角
                                  context: context,
                                  builder: (context) {
                                    return Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          child: Center(
                                            child: Container(
                                              margin: EdgeInsets.only(top: 8),
                                              width: 60,
                                              height: 4,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Color(0xffdddddd),
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(top: 28),
                                            padding: EdgeInsets.only(
                                                bottom: 12,
                                                left: 16,
                                                right: 16),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 1,
                                                        color: Color(
                                                            0xffdddddd)))),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    // 取消
                                                    'Cancel',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'GoogleSans-Medium',
                                                        fontSize: 14,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                Text(
                                                  'Select Test',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'GoogleSans-Medium',
                                                      fontSize: 14,
                                                      color: Color(0xff000000)),
                                                ),
                                                // 确定
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      cur_test_index =
                                                          select_test_index;
                                                      testAbbr =
                                                          select_test_abbr;
                                                      testValue =
                                                          select_test_value;
                                                      TestQueNum =
                                                          select_test_ques;
                                                      TestPassNum =
                                                          select_test_pass;
                                                      TestUrl = select_test_url;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'Done',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'GoogleSans-Medium',
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff255dd9)),
                                                  ),
                                                )
                                              ],
                                            )),
                                        Container(
                                          height: 200,
                                          margin: EdgeInsets.only(top: 59),
                                          child: ScrollConfiguration(
                                            behavior: MyBehavior(),
                                            child: TestDataList(
                                              splitStateAbbr: stateAbbr,
                                              urlStateSlug: stateSlug,
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  });
                            },
                            child: Row(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(right: 8),
                                    child: Container(
                                      width: 100,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        testAbbr,
                                        overflow: TextOverflow.ellipsis,
                                        style: barTextStyle,
                                      ),
                                    )),
                                SvgPicture.asset(
                                    'images/arrow-down-filling.svg',
                                    width: 12)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 类型选择弹框
                    Positioned(
                        top: 14,
                        left: 0,
                        right: 0,
                        child: Container(
                          margin: EdgeInsets.only(left: 136, right: 136),
                          // decoration: BoxDecoration(color: Colors.red),
                          child: Center(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (licenceLower == 'car') {
                                        setState(() {
                                          licenceLower = 'cdl';
                                          cur_type_index = 2;
                                          _getTestListStatus = -1;
                                          _setTypeSelectStatus(
                                            cur_type_index,
                                            'CDL',
                                            licenceLower,
                                          );
                                        });
                                      } else if (licenceLower == 'motorcycle') {
                                        setState(() {
                                          licenceLower = 'car';
                                          cur_type_index = 0;
                                          _getTestListStatus = -1;
                                          _setTypeSelectStatus(
                                            cur_type_index,
                                            'Car',
                                            licenceLower,
                                          );
                                        });
                                      } else if (licenceLower == 'cdl') {
                                        setState(() {
                                          licenceLower = 'motorcycle';
                                          cur_type_index = 1;
                                          _getTestListStatus = -1;
                                          _setTypeSelectStatus(
                                            cur_type_index,
                                            'Motorcycle',
                                            licenceLower,
                                          );
                                        });
                                      }
                                      getTestList();
                                    },
                                    child: SvgPicture.asset(
                                        'images/arrow-left-filling.svg',
                                        width: 14),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          isDismissible:
                                              true, //点击空白处返回功能，默认是true
                                          enableDrag: true, //是否允许拖动
                                          elevation: 10,
                                          barrierColor: Colors.black
                                              .withOpacity(0.2), //空白处的颜色
                                          backgroundColor: Colors.white, //背景颜色
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12),
                                          )), //圆角
                                          context: context,
                                          builder: (context) {
                                            return Stack(
                                              children: [
                                                Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: Center(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: 8),
                                                      width: 60,
                                                      height: 4,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffdddddd),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: 28),
                                                    padding: EdgeInsets.only(
                                                        bottom: 12,
                                                        left: 16,
                                                        right: 16),
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                width: 1,
                                                                color: Color(
                                                                    0xffdddddd)))),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            // 取消
                                                            'Cancel',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'GoogleSans-Medium',
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        ),
                                                        Text(
                                                          'Select License',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'GoogleSans-Medium',
                                                              fontSize: 14,
                                                              color: Color(
                                                                  0xff000000)),
                                                        ),
                                                        // 确定
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              cur_type_index =
                                                                  select_type_index;
                                                              licence =
                                                                  select_type_value;
                                                              licenceLower =
                                                                  select_type;
                                                              _getTestListStatus =
                                                                  -1;
                                                            });
                                                            _setTypeSelectStatus(
                                                                cur_type_index,
                                                                licence,
                                                                licenceLower);
                                                            getTestList();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            'Done',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'GoogleSans-Medium',
                                                                fontSize: 14,
                                                                color: Color(
                                                                    0xff255dd9)),
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                                Container(
                                                  height: 200,
                                                  margin:
                                                      EdgeInsets.only(top: 59),
                                                  child: ScrollConfiguration(
                                                      behavior: MyBehavior(),
                                                      child: TypeDataList()),
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: SvgPicture.asset(
                                          'images/$licenceLower.svg',
                                          width: 32),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (licenceLower == 'car') {
                                        setState(() {
                                          licenceLower = 'motorcycle';
                                          cur_type_index = 1;
                                          _getTestListStatus = -1;
                                          _setTypeSelectStatus(
                                            cur_type_index,
                                            'Motorcycle',
                                            licenceLower,
                                          );
                                        });
                                      } else if (licenceLower == 'motorcycle') {
                                        setState(() {
                                          licenceLower = 'cdl';
                                          cur_type_index = 2;
                                          _getTestListStatus = -1;
                                          _setTypeSelectStatus(
                                            cur_type_index,
                                            'CDL',
                                            licenceLower,
                                          );
                                        });
                                      } else if (licenceLower == 'cdl') {
                                        setState(() {
                                          licenceLower = 'car';
                                          cur_type_index = 0;
                                          _getTestListStatus = -1;
                                          _setTypeSelectStatus(
                                            cur_type_index,
                                            'Car',
                                            licenceLower,
                                          );
                                        });
                                      }
                                      getTestList();
                                    },
                                    child: SvgPicture.asset(
                                        'images/arrow-right-filling.svg',
                                        width: 14),
                                  )
                                ]),
                          ),
                        ))
                  ],
                )),
          ],
        ),
      ),
    );
  }

  _setStateSelectStatus(stateIndex, stateAbbr, stateValue, stateSlug) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 州选择状态
    await prefs.setInt('stateSelectIndex', stateIndex);
    await prefs.setString('stateSelectAbbr', stateAbbr);
    await prefs.setString('stateSelectValue', stateValue);
    await prefs.setString('stateSelectSlug', stateSlug);
  }

  _setTypeSelectStatus(licenceIndex, licence, licenceLower) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 类型选择状态
    await prefs.setInt('typeSelectStatus', 1);
    await prefs.setInt('typeSelectLicenceIndex', licenceIndex);
    await prefs.setString('typeSelectLicence', licence);
    await prefs.setString('typeSelectLicenceLowerr', licenceLower);
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

class StateDataList extends StatefulWidget {
  @override
  _StateDataListState createState() => _StateDataListState();
}

class _StateDataListState extends State<StateDataList> {
  int _selectIndex = cur_state_index;

  Widget _getStateList(context, index) {
    return InkWell(
        onTap: () {
          setState(() {
            if (_selectIndex == index) {
              return;
            } else {
              _selectIndex = index;
              select_state_index = index;
              select_state_abbr = STATE_LIST[index]["sub_name"];
              select_state = STATE_LIST[index]["name"];
              select_state_slug = STATE_LIST[index]["slug"];
            }
          });
        },
        child: Stack(
          children: [
            Container(
                height: 48,
                decoration: BoxDecoration(
                    color: index == _selectIndex
                        ? Color(0xffe8f0fe)
                        : Colors.transparent,
                    border: Border(
                        bottom:
                            BorderSide(width: 1, color: Color(0xffaaaaaa)))),
                alignment: Alignment.centerLeft,
                // margin: EdgeInsets.only(left: 32, right: 32),
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      STATE_LIST[index]["name"],
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'GoogleSans-Regular',
                      ),
                    ),
                    Visibility(
                        visible: index == _selectIndex ? true : false,
                        child:
                            SvgPicture.asset('images/correct.svg', width: 20))
                  ],
                )),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: STATE_LIST.length, itemBuilder: this._getStateList);
  }
}

class TypeDataList extends StatefulWidget {
  @override
  _TypeDataListState createState() => _TypeDataListState();
}

class _TypeDataListState extends State<TypeDataList> {
  int _selectIndex = cur_type_index;

  Widget _getTypeList(context, index) {
    return InkWell(
        onTap: () {
          setState(() {
            if (_selectIndex == index) {
              return;
            } else {
              _selectIndex = index;
              select_type_index = index;
              select_type_value = TYPE_LIST[index]["value"];
              select_type = TYPE_LIST[index]["slug"];
            }
          });
        },
        child: Stack(
          children: [
            Container(
                height: 48,
                decoration: BoxDecoration(
                    color: index == _selectIndex
                        ? Color(0xffe8f0fe)
                        : Colors.transparent,
                    border: Border(
                        bottom:
                            BorderSide(width: 1, color: Color(0xffaaaaaa)))),
                alignment: Alignment.centerLeft,
                // margin: EdgeInsets.only(left: 32, right: 32),
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      TYPE_LIST[index]["value"],
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'GoogleSans-Regular',
                      ),
                    ),
                    Visibility(
                        visible: index == _selectIndex ? true : false,
                        child:
                            SvgPicture.asset('images/correct.svg', width: 20))
                  ],
                )),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: TYPE_LIST.length, itemBuilder: this._getTypeList);
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
  int _selectIndex = cur_test_index;
  String splitStateAbbr = '';
  String urlStateSlug = '';

  @override
  void initState() {
    splitStateAbbr = widget.splitStateAbbr;
    urlStateSlug = widget.urlStateSlug;
    print(splitStateAbbr);
  }

  Widget _getTestList(context, index) {
    return InkWell(
        onTap: () {
          setState(() {
            if (_selectIndex == index) {
              return;
            } else {
              _selectIndex = index;
              select_test_index = index;
              if (cur_type_index != 2) {
                select_test_abbr =
                    'DMV Test ' + TEST_LIST[index]['orders'].toString();
                if (index == 0) {
                  select_test_value = TEST_LIST[index]['name']
                          .split(splitStateAbbr)[1]
                          .trimLeft() +
                      ' ' +
                      TEST_LIST[index]['orders'].toString();
                } else {
                  select_test_value = TEST_LIST[index]['name']
                      .split(splitStateAbbr)[1]
                      .trimLeft();
                }
                select_test_url = 'https://www.dmv-test-pro.com/' +
                    urlStateSlug +
                    '/' +
                    TEST_LIST[index]['slug'] +
                    '/';
              } else {
                select_test_abbr = TEST_LIST[index]['name'].split(' - ')[0];
                if (index == 0) {
                  select_test_value = TEST_LIST[0]["name"] +
                      ' ' +
                      TEST_LIST[0]['orders'].toString();
                } else {
                  select_test_value = TEST_LIST[index]["name"];
                }
                select_test_url = 'https://www.dmv-test-pro.com/' +
                    urlStateSlug +
                    '/' +
                    splitStateAbbr.toLowerCase() +
                    '-' +
                    TEST_LIST[index]['slug'] +
                    '/';
              }
              select_test_ques = TEST_LIST[index]['question_num'];
              select_test_pass = TEST_LIST[index]['qualifying_num'];
            }
          });
        },
        child: Stack(
          children: [
            Container(
                height: 48,
                decoration: BoxDecoration(
                    color: index == _selectIndex
                        ? Color(0xffe8f0fe)
                        : Colors.transparent,
                    border: Border(
                        bottom:
                            BorderSide(width: 1, color: Color(0xffaaaaaa)))),
                alignment: Alignment.centerLeft,
                // margin: EdgeInsets.only(left: 32, right: 32),
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      TEST_LIST[index]["name"],
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'GoogleSans-Regular',
                      ),
                    ),
                    Visibility(
                        visible: index == _selectIndex ? true : false,
                        child:
                            SvgPicture.asset('images/correct.svg', width: 20))
                  ],
                )),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: TEST_LIST.length, itemBuilder: this._getTestList);
  }
}
