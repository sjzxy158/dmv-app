import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

List STATE_LIST = [
  {"id": '1', "slug": 'alabama0', "value": 'Alabama0'},
  {"id": '2', "slug": 'alabama1', "value": 'Alabama1'},
  {"id": '3', "slug": 'alabama2', "value": 'Alabama2'},
  {"id": '4', "slug": 'alabama3', "value": 'Alabama3'},
  {"id": '5', "slug": 'alabama', "value": 'Alabama'},
  {"id": '6', "slug": 'alabama4', "value": 'Alabama4'},
  {"id": '7', "slug": 'alabama4', "value": 'Alabama4'},
  {"id": '8', "slug": 'alabama4', "value": 'Alabama4'},
  {"id": '9', "slug": 'alabama4', "value": 'Alabama4'},
  {"id": '10', "slug": 'alabama4', "value": 'Alabama4'},
  {"id": '11', "slug": 'alabama4', "value": 'Alabama4'},
  {"id": '12', "slug": 'alabama4', "value": 'Alabama4'},
  {"id": '13', "slug": 'alabama8', "value": 'Alabama8'},
  {"id": '14', "slug": 'alabama8', "value": 'Alabama8'},
  {"id": '15', "slug": 'alabama8', "value": 'Alabama8'},
  {"id": '16', "slug": 'alabama6', "value": 'Alabama6'},
  {"id": '17', "slug": 'alabama6', "value": 'Alabama6'},
  {"id": '18', "slug": 'alabama6', "value": 'Alabama6'},
  {"id": '19', "slug": 'alabama6', "value": 'Alabama6'},
];
List TYPE_LIST = [
  {
    "slug": 'car',
    "value": 'Car',
  },
  {
    "slug": 'motocycle',
    "value": 'Motocycle',
  },
  {
    "slug": 'cdl',
    "value": 'CDL',
  }
];
List TEST_LIST = [
  {"abbr": 'DMV Test 1', "value": 'DMV Practice Test 1'},
  {"abbr": 'DMV Test 2', "value": 'DMV Practice Test 2'},
  {"abbr": 'DMV Test 3', "value": 'DMV Practice Test 3'},
  {"abbr": 'DMV Test 4', "value": 'DMV Practice Test 4'},
  {"abbr": 'DMV Test 5', "value": 'DMV Practice Test 5'},
  {"abbr": 'DMV Test 6', "value": 'DMV Practice Test 6'},
  {"abbr": 'DMV Test 7', "value": 'DMV Practice Test 7'},
  {"abbr": 'DMV Test 8', "value": 'DMV Practice Test 8'},
  {"abbr": 'DMV Test 9', "value": 'DMV Practice Test 9'},
];
int cur_state_index = -1;
int select_state_index = -1;
String select_state = '';
int cur_type_index = -1;
int select_type_index = -1;
String select_type = '';
int cur_test_index = -1;
int select_test_index = -1;
String select_test_abbr = '';
String select_test_value = '';

class _testListPageState extends State<testListPage> {
  int stateIndex = -1;
  String stateAbbr = '';
  String stateValue = '';
  String stateSlug = '';
  int licenceIndex = -1;
  String licence = '';
  String licenceLower = '';
  int testIndex = 0;
  String testAbbr = TEST_LIST[0]['abbr'];
  String testValue = TEST_LIST[0]['value'];
  @override
  void initState() {
    stateIndex = widget.stateIndex;
    stateAbbr = widget.stateAbbr;
    stateValue = widget.stateValue;
    stateSlug = widget.stateSlug;
    licenceIndex = widget.licenceIndex;
    licence = widget.licence;
    licenceLower = widget.licenceLower;

    cur_state_index = stateIndex;
    cur_type_index = licenceIndex;
    cur_test_index = testIndex;
    print(stateIndex);
    print(stateAbbr);
    print(stateValue);
    print(stateSlug);
    print(licence);
    print(licenceLower);
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
            Container(
                margin: EdgeInsets.only(top: statusBar + 88),
                child: Column(
                  children: [
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
                              padding: EdgeInsets.only(top: 16, bottom: 16),
                              child: Text(
                                "24 tests",
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
                              padding: EdgeInsets.only(top: 20, bottom: 20),
                              child: Text(
                                testValue,
                                style: TextStyle(
                                  fontFamily: 'GoogleSans-Bold',
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 152,
                                  // constraints:BoxConstraints(
                                  //   minWidth:
                                  // ),
                                  padding: EdgeInsets.fromLTRB(24, 12, 24, 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Color(0xffe8f0fe)),
                                  child: Column(children: [
                                    Text('Numbers of questions',
                                        style: TextStyle(
                                          fontFamily: 'GoogleSans-Medium',
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.center),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        '30',
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
                                  padding: EdgeInsets.fromLTRB(48, 12, 48, 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Color(0xffe8f0fe)),
                                  child: Column(children: [
                                    Text('Passing score',
                                        style: TextStyle(
                                          fontFamily: 'GoogleSans-Medium',
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.center),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        '24',
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
                    Container(
                        height: 48,
                        width: 200,
                        margin: EdgeInsets.only(top: 48),
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
                  ],
                )),
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
                              print('开启州列表弹框');
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
                                            child: TestDataList(),
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
                                    testAbbr,
                                    style: barTextStyle,
                                  ),
                                ),
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
                                        });
                                      } else if (licenceLower == 'motocycle') {
                                        setState(() {
                                          licenceLower = 'car';
                                          cur_type_index = 0;
                                        });
                                      } else if (licenceLower == 'cdl') {
                                        setState(() {
                                          licenceLower = 'motocycle';
                                          cur_type_index = 1;
                                        });
                                      }
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
                                                              licenceLower =
                                                                  select_type;
                                                            });
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
                                          licenceLower = 'motocycle';
                                          cur_type_index = 1;
                                        });
                                      } else if (licenceLower == 'motocycle') {
                                        setState(() {
                                          licenceLower = 'cdl';
                                          cur_type_index = 2;
                                        });
                                      } else if (licenceLower == 'cdl') {
                                        setState(() {
                                          licenceLower = 'car';
                                          cur_type_index = 0;
                                        });
                                      }
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
              select_state = STATE_LIST[index]["value"];
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
                      STATE_LIST[index]["value"],
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
  @override
  _TestDataListState createState() => _TestDataListState();
}

class _TestDataListState extends State<TestDataList> {
  int _selectIndex = cur_test_index;

  Widget _getTestList(context, index) {
    return InkWell(
        onTap: () {
          setState(() {
            if (_selectIndex == index) {
              return;
            } else {
              _selectIndex = index;
              select_test_index = index;
              select_test_abbr = TEST_LIST[index]["abbr"];
              select_test_value = TEST_LIST[index]["value"];
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
                      TEST_LIST[index]["value"],
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
