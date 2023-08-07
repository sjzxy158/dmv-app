import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:app/page/type.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StateListPage extends StatefulWidget {
  const StateListPage({Key? key}) : super(key: key);

  @override
  _StateListPageState createState() => _StateListPageState();
}

List STATE_LIST = [];
int stateIndex = -1;
String stateAbbr = '';
String stateValue = '';
String stateSlug = '';

class _StateListPageState extends State<StateListPage> {
  bool _tipVisible = false;
  int _getStateListStatus = -1;

  // ad

  Future getStateList() async {
    String url = 'https://api-dmv.silversiri.com/getStateList';
    var res = await http.post(Uri.parse(url));
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      // print(body['data']);
      setState(() {
        STATE_LIST = body['data'];
        _getStateListStatus = res.statusCode;
      });
      return body;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    getStateList();
    //
  }

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
                    child: _getStateListStatus == 200
                        ? StateDataList()
                        : _loadDownloadWidget()),
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
                            _setStateSelectStatus(
                                stateIndex, stateAbbr, stateValue, stateSlug);
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

  _setStateSelectStatus(stateIndex, stateAbbr, stateValue, stateSlug) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 州选择状态
    await prefs.setInt('stateSelectStatus', 1);
    await prefs.setInt('stateSelectIndex', stateIndex);
    await prefs.setString('stateSelectAbbr', stateAbbr);
    await prefs.setString('stateSelectValue', stateValue);
    await prefs.setString('stateSelectSlug', stateSlug);
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
  int _selectIndex = -1;

  Widget _getStateList(context, index) {
    return InkWell(
        onTap: () {
          stateIndex = index;
          // stateAbbr = 'AL';
          // stateValue = 'Alabama';
          // stateSlug = 'alabama';
          stateAbbr = STATE_LIST[index]["sub_name"];
          stateValue = STATE_LIST[index]["name"];
          stateSlug = STATE_LIST[index]["slug"];

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
                      STATE_LIST[index]["name"],
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

// class CommonModel {
//   final int StatusCode;
//   final List dataList;

//   CommonModel({required this.StatusCode, required this.dataList});

//   factory CommonModel.fromJson(Map<String, dynamic> json) {
//     return CommonModel(StatusCode: json['code'], dataList: json['data']);
//   }
// }
