import 'package:app/page/test_list.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

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

// String licence = '';
// String licenceLower = '';

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
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Color(0xff255dd9)),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(color: Color(0xffdddddd)),
              child: Column(children: <Widget>[
                _typeItem('Car', 0),
                _typeItem('Motocycle', 1),
                _typeItem('CDL', 2),
              ]),
            )));
  }

  _typeItem(String licence, int index) {
    String licenceLower = licence.toLowerCase();
    return InkWell(
      onTap: () {
        // 本地存储 licence
        // 跳转
        // print(stateAbbr);
        // print(stateValue);
        // print(stateSlug);
        // print(licence);
        // print(licenceLower);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return testListPage(
            stateIndex: stateIndex,
            stateAbbr: stateAbbr,
            stateValue: stateValue,
            stateSlug: stateSlug,
            licenceIndex: index,
            licence: licence,
            licenceLower: licenceLower,
          );
        }));
      },
      child: Container(
          height: 120,
          width: double.infinity,
          margin: EdgeInsets.only(left: 16, right: 16, top: 32),
          padding: EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      licence,
                      style: TextStyle(fontFamily: 'GoogleSans-Regular'),
                    ),
                    SvgPicture.asset('images/go.svg', width: 16)
                  ],
                ),
              ),
              Image(
                  width: 160,
                  height: 160,
                  image: AssetImage('images/$licenceLower.png'))
            ],
          )),
    );
  }
}
