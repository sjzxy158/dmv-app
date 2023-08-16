import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:app/page/type.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StateListPage extends StatefulWidget {
  final bool backVisible;
  final int currentStateIndex;
  const StateListPage({
    Key? key,
    required this.backVisible,
    required this.currentStateIndex,
  }) : super(key: key);

  @override
  _StateListPageState createState() => _StateListPageState();
}

List STATE_LIST = [];
int stateIndex = -1;
String stateAbbr = '';
String stateValue = '';
String stateSlug = '';

class _StateListPageState extends State<StateListPage> {
  bool backVisible = false;
  int _getStateListStatus = -1;

  bool isInProduction = bool.fromEnvironment("dart.vm.product");
  String Path = '';

  Future getStateList() async {
    print('---------------------');
    print(isInProduction);
    setState(() {
      if (isInProduction) {
        Path = 'https://api.dmv-test-pro.com/';
      } else {
        Path = 'https://api-dmv.silversiri.com/';
      }
    });
    print(Path);
    print('${Path}getStateList');
    String url = '${Path}getStateList';
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
    setState(() {
      stateIndex = widget.currentStateIndex;
      backVisible = widget.backVisible;
    });
    getStateList();
  }

  @override
  Widget build(BuildContext context) {
    double statusBar = MediaQuery.of(context).padding.top;
    return MaterialApp(
      title: 'Home',
      home: Scaffold(
          appBar: AppBar(
            title: Text(
              'Select your state',
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Gilroy-Bold', fontSize: 24),
            ),
            toolbarHeight: 90,
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Visibility(
                  visible: backVisible,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 36,
                      bottom: 36,
                    ),
                    child: Transform.rotate(
                        angle: math.pi,
                        child: SvgPicture.asset(
                          'images/go.svg',
                        )),
                  ),
                )),
          ),
          body: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Container(
              child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: _getStateListStatus == 200
                      ? StateDataList()
                      : _loadDownloadWidget()),
            ),
          )),
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

_setStateSelectStatus(stateIndex, stateAbbr, stateValue, stateSlug) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // 州选择状态
  await prefs.setInt('stateSelectStatus', 1);
  await prefs.setInt('stateSelectIndex', stateIndex);
  await prefs.setString('stateSelectAbbr', stateAbbr);
  await prefs.setString('stateSelectValue', stateValue);
  await prefs.setString('stateSelectSlug', stateSlug);
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
  Widget _getStateList(context, index) {
    return InkWell(
      onTap: () {
        // stateIndex = index;
        stateAbbr = STATE_LIST[index]["sub_name"];
        stateValue = STATE_LIST[index]["name"];
        stateSlug = STATE_LIST[index]["slug"];

        _setStateSelectStatus(index, stateAbbr, stateValue, stateSlug);

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return TypeSelectPage(
              stateIndex: index,
              stateAbbr: stateAbbr,
              stateValue: stateValue,
              stateSlug: stateSlug);
        }));
      },
      child: Container(
          height: 56,
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(width: 1, color: Color(0xfff4f7f9)))),
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 20),
          padding: EdgeInsets.only(right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image(
                      width: 36,
                      height: 24,
                      image: AssetImage(
                          "images/flags/${STATE_LIST[index]["slug"]}.png")),
                  Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Text(
                        STATE_LIST[index]["name"],
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'GoogleSans-Regular',
                        ),
                      )),
                ],
              ),
              Row(
                children: [
                  Visibility(
                      visible: index == stateIndex ? true : false,
                      child: Container(
                        margin: EdgeInsets.only(right: 24),
                        child: Text(
                          'Current Location',
                          style: TextStyle(
                              fontFamily: 'GoogleSans-Regular',
                              color: Color(
                                0xff999999,
                              )),
                        ),
                      )),
                  Transform.rotate(
                      angle: math.pi,
                      child: SvgPicture.asset('images/next.svg',
                          width: 7, height: 12, color: Color(0xffcccccc)))
                ],
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: STATE_LIST.length, itemBuilder: this._getStateList);
  }
}
