import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/page/tests/test_home.dart';
import 'package:app/page/setting.dart';
import 'package:app/page/handbook/handbook.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

class TabNavigator extends StatefulWidget {
  final int stateIndex;
  final String stateAbbr;
  final String stateValue;
  final String stateSlug;
  final int licenceIndex;
  final String licence;
  final String licenceLower;

  const TabNavigator(
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
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = Color(0xff255dd9);
  final PageController _controller = PageController(
    initialPage: 0,
  );
  int _currentIndex = 0;

  int stateIndex = -1;
  String stateAbbr = '';
  String stateValue = '';
  String stateSlug = '';
  int licenceIndex = -1;
  String licence = '';
  String licenceLower = '';

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    stateIndex = widget.stateIndex;
    stateAbbr = widget.stateAbbr;
    stateValue = widget.stateValue;
    stateSlug = widget.stateSlug;
    licenceIndex = widget.licenceIndex;
    licence = widget.licence;
    licenceLower = widget.licenceLower;
    _getStateAndTypeSelectStatus();
    _testSetCurrentScreen();
  }

  Future<void> _testSetCurrentScreen() async {
    await FirebaseAnalytics.instance.setCurrentScreen(
      screenName: 'Tab Navigator',
      screenClassOverride: 'Tab Navigator',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            TestHomePage(
              stateIndex: stateIndex,
              stateAbbr: stateAbbr,
              stateValue: stateValue,
              stateSlug: stateSlug,
              licenceIndex: licenceIndex,
              licence: licence,
              licenceLower: licenceLower,
            ),
            HandbookPage(
              stateAbbr: stateAbbr,
              stateValue: stateValue,
              stateSlug: stateSlug,
              licence: licence,
              licenceLower: licenceLower,
            ),
            SettingPage(),
          ],
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              _controller.jumpToPage(index);
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            iconSize: 20,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedItemColor: _activeColor,
            selectedLabelStyle: TextStyle(
              fontFamily: 'GoogleSans-Medium',
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: 'GoogleSans-Medium',
            ),
            items: [
              _bottomItem('DMV Tests', 'tests', 0),
              _bottomItem('Handbooks', 'handbook', 1),
              _bottomItem('Settings', 'setting', 2),
            ],
          ),
        ));
  }

  _bottomItem(String title, String icon, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        margin: EdgeInsets.only(bottom: 4),
        child: SvgPicture.asset(
          'images/${icon}.svg',
          width: 20,
          height: 20,
          color: _defaultColor,
        ),
      ),
      activeIcon: Container(
          margin: EdgeInsets.only(bottom: 4),
          child: SvgPicture.asset(
            'images/${icon}.svg',
            width: 20,
            height: 20,
            color: _activeColor,
          )),
      label: title,
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
      licenceLower = prefs.getString('typeSelectLicenceLower');
    });
  }
}
