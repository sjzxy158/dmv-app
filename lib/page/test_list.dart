import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class testListPage extends StatefulWidget {
  // final String stateAbbr;
  // final String stateValue;
  // final String stateSlug;
  // final String type;
  // final String typeLower;

  const testListPage({
    Key? key,
    // required this.stateAbbr,
    // required this.stateValue,
    // required this.stateSlug,
    // required this.type,
    // required this.typeLower
  }) : super(key: key);

  @override
  _testListPageState createState() => _testListPageState();
}

class _testListPageState extends State<testListPage> {
  // String stateAbbr = '';
  // String stateValue = '';
  // String stateSlug = '';
  // String type = '';
  // String typeLower = '';
  // @override
  // void initState() {
  //   stateAbbr = widget.stateAbbr;
  //   stateValue = widget.stateValue;
  //   stateSlug = widget.stateSlug;
  //   type = widget.type;
  //   typeLower = widget.typeLower;
  //   // print(stateValue);
  //   // print(type);
  // }

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
                              "Alabama Driver's Examination",
                              style: TextStyle(
                                fontFamily: 'GoogleSans-Medium',
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "(From the 2021 Alabama driver handbook)",
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
                                'DMV Practice 1',
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
                                        Container(
                                          child: Text('Select State'),
                                        ),
                                        Container(
                                          height: 200,
                                          margin: EdgeInsets.only(top: 80),
                                          child: ScrollConfiguration(
                                            behavior: MyBehavior(),
                                            child: ListView(
                                              children: [
                                                Text('123'),
                                                Text('123'),
                                                Text('123'),
                                                Text('123'),
                                                Text('123'),
                                                Text('123'),
                                                Text('123'),
                                                Text('123'),
                                                Text('123'),
                                                Text('123'),
                                                Text('123'),
                                                Text('123'),
                                                Text('123'),
                                                Text('123'),
                                                Text('123'),
                                              ],
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
                                  child: Text(
                                    'AL',
                                    style: barTextStyle,
                                  ),
                                ),
                                SvgPicture.asset(
                                    'images/arrow-down-filling.svg',
                                    width: 12)
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 8),
                                child: Text(
                                  'DMV Test 1',
                                  style: barTextStyle,
                                ),
                              ),
                              SvgPicture.asset('images/arrow-down-filling.svg',
                                  width: 12)
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        top: 12,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                    'images/arrow-left-filling.svg',
                                    width: 12),
                                Container(
                                  margin: EdgeInsets.only(left: 8, right: 8),
                                  child: Text('123'),
                                ),
                                SvgPicture.asset(
                                    'images/arrow-right-filling.svg',
                                    width: 12),
                              ]),
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
