import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/page/tab_navigator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class TypeSelectPage extends StatefulWidget {
  final int stateIndex;
  final String stateAbbr;
  final String stateValue;
  final String stateSlug;

  const TypeSelectPage(
      {Key? key,
      required this.stateIndex,
      required this.stateAbbr,
      required this.stateValue,
      required this.stateSlug})
      : super(key: key);

  @override
  _TypeSelectPageState createState() => _TypeSelectPageState();
}

int licenceIndex = -1;
String licence = '';
String licenceLower = '';
bool StartVisible = false;

class _TypeSelectPageState extends State<TypeSelectPage> {
  int stateIndex = -1;
  String stateAbbr = '';
  String stateValue = '';
  String stateSlug = '';
  @override
  void initState() {
    stateIndex = widget.stateIndex;
    stateAbbr = widget.stateAbbr;
    stateValue = widget.stateValue;
    stateSlug = widget.stateSlug;
    _testSetCurrentScreen();
  }

  Future<void> _testSetCurrentScreen() async {
    await FirebaseAnalytics.instance.setCurrentScreen(
      screenName: 'Choose Type',
      screenClassOverride: 'Choose Type',
    );
  }

  @override
  Widget build(BuildContext context) {
    double statusBar = MediaQuery.of(context).padding.top;
    return MaterialApp(
        title: 'Home',
        home: Scaffold(
            appBar: AppBar(
              title: Text(
                'Select type of Licence',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'GoogleSans-Bold',
                    fontSize: 24),
              ),
              toolbarHeight: 90,
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    // decoration: BoxDecoration(color: Colors.red),
                    margin: EdgeInsets.only(
                      top: 36,
                      bottom: 36,
                    ),
                    child: Transform.rotate(
                        angle: math.pi,
                        child: SvgPicture.asset(
                          'images/go.svg',
                        )),
                  )),
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(children: <Widget>[
                    _typeItem('Car', 0, 600),
                    _typeItem('Motorcycle', 1, 450),
                    _typeItem('CDL', 2, 2500),
                  ]),
                ),
                Positioned(
                    bottom: 24,
                    left: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        if (StartVisible) {
                          _setTypeSelectStatus(
                              licenceIndex, licence, licenceLower);
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
                        } else {
                          return;
                        }
                      },
                      child: Container(
                          height: 56,
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: StartVisible
                                ? Color(0xff255dd9)
                                : Color(0xffbbbbbb),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            'Start',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'GoogleSans-Medium',
                                color: Colors.white),
                          )),
                    ))
              ],
            )));
  }

  _setTypeSelectStatus(licenceIndex, licence, licenceLower) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 类型选择状态
    await prefs.setInt('typeSelectStatus', 1);
    await prefs.setInt('typeSelectLicenceIndex', licenceIndex);
    await prefs.setString('typeSelectLicence', licence);
    await prefs.setString('typeSelectLicenceLower', licenceLower);
  }

  _typeItem(String type, int index, int quesNum) {
    String licenceSlug = type.toLowerCase();
    return InkWell(
      onTap: () {
        setState(() {
          StartVisible = true;
          licenceIndex = index;
          licence = type;
          licenceLower = licence.toLowerCase();
        });
      },
      child: Container(
          height: 160,
          width: double.infinity,
          margin: EdgeInsets.only(left: 20, right: 20, top: 16),
          padding: EdgeInsets.only(left: 24),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 3,
                  color: licenceIndex == index
                      ? Color(0xff255dd9)
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: const Color.fromRGBO(0, 0, 0, 0.06),
                    offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                    blurRadius: 10.0, //阴影模糊程度
                    spreadRadius: 12.0 //阴影扩散程度
                    )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      type,
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'GoogleSans-Medium',
                          color: Colors.black),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Text(
                        '${quesNum} Questions',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'GoogleSans-Regular',
                            color: Color(0xff999999)),
                      ),
                    )
                  ],
                ),
              ),
              Image(
                  width: 190,
                  height: 200,
                  image: AssetImage('images/$licenceSlug.png'))
            ],
          )),
    );
  }
}
