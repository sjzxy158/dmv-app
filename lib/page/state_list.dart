import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:app/page/type.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class StateListPage extends StatefulWidget {
  const StateListPage({Key? key}) : super(key: key);

  @override
  _StateListPageState createState() => _StateListPageState();
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
int stateIndex = -1;
String stateAbbr = '';
String stateValue = '';
String stateSlug = '';

class _StateListPageState extends State<StateListPage> {
  bool _tipVisible = false;
  @override
  Widget build(BuildContext context) {
    double statusBar = MediaQuery.of(context).padding.top;
    return MaterialApp(
      title: 'Home',
      home: Scaffold(
          appBar: AppBar(
              title: Text(
                'Select the State',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Color(0xff255dd9)),
          body: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Stack(children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 80),
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: StateDataList(),
                ),
              ),
              Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                      decoration: BoxDecoration(color: Color(0xffeeeeee)),
                      child: Center(
                          child: InkWell(
                        onTap: () {
                          if (stateValue == '') {
                            setState(() {
                              _tipVisible = true;
                            });
                            Timer.periodic(const Duration(milliseconds: 2000),
                                (timer) {
                              setState(() {
                                _tipVisible = false;
                              });
                              if (_tipVisible == false) {
                                timer.cancel();
                              }
                            });
                          } else {
                            // 本地存储state
                            // 跳转
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return TypeSelectPage(
                                  stateIndex: stateIndex,
                                  stateAbbr: stateAbbr,
                                  stateValue: stateValue,
                                  stateSlug: stateSlug);
                            }));
                          }
                        },
                        child: Container(
                            height: 48,
                            width: 200,
                            margin: EdgeInsets.only(top: 16, bottom: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Color(0xff255dd9)),
                            child: Center(
                              child: Text(
                                'Next',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'GoogleSans-Bold',
                                    fontSize: 18),
                              ),
                            )),
                      )))),
              Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: Visibility(
                    visible: _tipVisible,
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      padding: EdgeInsets.only(left: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.black87),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Please select a state',
                            style: TextStyle(
                                fontFamily: 'GoogleSans-Regular',
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )),
            ]),
          )),
      // routes: <String, WidgetBuilder>{
      //   'type': (BuildContext context) => TypeSelectPage(),
      // },
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
  int _selectIndex = -1;

  Widget _getStateList(context, index) {
    return InkWell(
        onTap: () {
          // stateAbbr = STATE_LIST[index]["abbr"];
          // stateValue = STATE_LIST[index]["value"];
          // stateSlug = STATE_LIST[index]["slug"];
          stateIndex = index;
          stateAbbr = 'AL';
          stateValue = 'Alabama';
          stateSlug = 'alabama';
          setState(() {
            if (_selectIndex == index) {
              return;
            } else {
              _selectIndex = index;
            }
          });
        },
        child: Stack(
          children: [
            Container(
                height: 60,
                decoration: BoxDecoration(
                    color: index == _selectIndex
                        ? Color(0xffe8f0fe)
                        : Colors.transparent,
                    border: Border(
                        bottom:
                            BorderSide(width: 1, color: Color(0xffcccccc)))),
                alignment: Alignment.centerLeft,
                // margin: EdgeInsets.only(left: 32, right: 32),
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      STATE_LIST[index]["value"],
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'GoogleSans-Regular',
                      ),
                    ),
                    Visibility(
                        visible: index == _selectIndex ? true : false,
                        child:
                            SvgPicture.asset('images/correct.svg', width: 24))
                  ],
                )),
            // Opacity(
            //   opacity: index == _selectIndex ? 0.4 : 0,
            //   child: Container(
            //     height: 60,
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //         color: Color(0xffdddddd),
            //         border: Border(
            //             top: BorderSide(width: 1, color: Color(0xffcccccc)),
            //             bottom:
            //                 BorderSide(width: 1, color: Color(0xffcccccc)))),
            //     child: Text('213'),
            //   ),
            // )

            // cover
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: STATE_LIST.length, itemBuilder: this._getStateList);
  }
}
