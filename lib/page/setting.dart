import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/page/state_list.dart';
import 'package:app/page/type.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int stateIndex = -1;
  String stateAbbr = '';
  String stateValue = '';
  String stateSlug = '';
  int licenceIndex = -1;
  String licence = '';
  String licenceLower = '';

  @override
  void initState() {
    _getStateAndTypeSelectStatus();
  }

  @override
  Widget build(BuildContext context) {
    double statusBar = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(left: 20, top: statusBar),
        child: Column(children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 32, bottom: 32),
            child: Text(
              'Settings',
              style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'GoogleSans-Bold',
                  color: Colors.black),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xfff4f7f9)))),
            child: Text('Tests Related',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'GoogleSans-Medium',
                    color: Color(0xff999999))),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 16, bottom: 16),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xfff4f7f9)))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: 16),
                          child:
                              SvgPicture.asset('images/state.svg', width: 19)),
                      Text(
                        'State',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'GoogleSans-Regular',
                            color: Colors.black),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return StateListPage(
                            backVisible: true, currentStateIndex: stateIndex);
                      }));
                    },
                    child: Row(
                      children: <Widget>[
                        Text(
                          stateValue,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'GoogleSans-Regular',
                              color: Color(0xff999999)),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 20, left: 16),
                          child: Transform.rotate(
                              angle: math.pi,
                              child: SvgPicture.asset('images/next.svg',
                                  width: 7,
                                  height: 12,
                                  color: Color(0xffcccccc))),
                        )
                      ],
                    ),
                  )
                ]),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 16, bottom: 16),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xfff4f7f9)))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: 16),
                          child: SvgPicture.asset('images/type.svg',
                              width: 20, color: Colors.black)),
                      Text(
                        'Vehicle Type',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'GoogleSans-Regular',
                            color: Colors.black),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return TypeSelectPage(
                            stateIndex: stateIndex,
                            stateAbbr: stateAbbr,
                            stateValue: stateValue,
                            stateSlug: stateSlug);
                      }));
                    },
                    child: Row(
                      children: <Widget>[
                        Text(
                          licence,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'GoogleSans-Regular',
                              color: Color(0xff999999)),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 20, left: 16),
                          child: Transform.rotate(
                              angle: math.pi,
                              child: SvgPicture.asset('images/next.svg',
                                  width: 7,
                                  height: 12,
                                  color: Color(0xffcccccc))),
                        )
                      ],
                    ),
                  )
                ]),
          )
        ]),
      ),
    );
  }

  _getStateAndTypeSelectStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      stateIndex = prefs.getInt('stateSelectIndex');
      stateAbbr = prefs.getString('stateSelectAbbr');
      stateValue = prefs.getString('stateSelectValue');
      stateSlug = prefs.getString('stateSelectSlug');
      licenceIndex = prefs.getInt('typeSelectLicenceIndex');
      licence = prefs.getString('typeSelectLicence');
      licenceLower = prefs.getString('typeSelectLicenceLowerr');
    });
  }
}
