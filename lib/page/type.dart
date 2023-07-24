import 'package:app/page/test_list.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class TypeSelectPage extends StatefulWidget {
  // final String stateAbbr;
  // final String stateValue;
  // final String stateSlug;

  const TypeSelectPage({
    Key? key,
    // required this.stateAbbr,
    // required this.stateValue,
    // required this.stateSlug
  }) : super(key: key);

  @override
  _TypeSelectPageState createState() => _TypeSelectPageState();
}

class _TypeSelectPageState extends State<TypeSelectPage> {
  // String stateAbbr = '';
  // String stateValue = '';
  // String stateSlug = '';
  // @override
  // void initState() {
  //   stateAbbr = widget.stateAbbr;
  //   stateValue = widget.stateValue;
  //   stateSlug = widget.stateSlug;
  // }

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
                _typeItem('Car'),
                _typeItem('Motocycle'),
                _typeItem('CDL'),
              ]),
            )));
  }

  _typeItem(String type) {
    String typeLower = type.toLowerCase();
    return InkWell(
      onTap: () {
        // print(stateAbbr);
        // print(stateValue);
        // print(stateSlug);
        // print(type);
        // print(typeLower);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return testListPage(
              // stateAbbr: 'AL',
              // stateValue: 'Alabama',
              // stateSlug: 'alabama',
              // type: type,
              // typeLower: typeLower,
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
                      type,
                      style: TextStyle(fontFamily: 'GoogleSans-Regular'),
                    ),
                    SvgPicture.asset('images/go.svg', width: 16)
                  ],
                ),
              ),
              Image(
                  width: 160,
                  height: 160,
                  image: AssetImage('images/$typeLower.png'))
            ],
          )),
    );
  }
}
