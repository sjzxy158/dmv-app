import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

const FOOTER_LIST = ['About', 'Test', 'Resources', 'aPPLICATION'];

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double statusBar = MediaQuery.of(context).padding.top;
    return MaterialApp(
      title: 'Home',
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Home'),
        // ),
        body: Container(
            decoration: BoxDecoration(color: Colors.white),
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: statusBar),
            child: Column(
              children: <Widget>[
                // header
                Container(
                  height: 56,
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  decoration:
                      BoxDecoration(color: Color.fromARGB(255, 37, 93, 217)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image(
                          width: 170,
                          height: 28,
                          image: AssetImage('images/logo-white.png')),
                      SvgPicture.asset('images/menu.svg', width: 22),
                    ],
                  ),
                ),
                // main
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  // 跳转链接
                  // child: InkWell(
                  //   onTap: () {
                  //     Navigator.pushReplacement(context,
                  //         MaterialPageRoute(builder: (content) {
                  //       return MaterialApp(
                  //         title: 'Welcome to DMV',
                  //         theme: ThemeData(
                  //             primarySwatch: Colors.green,
                  //             primaryColor: Colors.white),
                  //         routes: {
                  //           "/": (_) => WebviewScaffold(
                  //               // url: "https://www.menuwithnutrition.com/",
                  //               // url: "https://dmv.silversiri.com",
                  //               url: "https://es.dmv-test-pro.com",
                  //               appBar: PreferredSize(
                  //                   // child: AppBar(), preferredSize: const Size.fromHeight(0.0))),
                  //                   child: AppBar(
                  //                     backgroundColor: Colors.white,
                  //                   ),
                  //                   preferredSize: Size.fromHeight(0.0))),
                  //         },
                  //         debugShowCheckedModeBanner: false,
                  //       );
                  //     }));
                  //   },
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: <Widget>[Text('Free DMV  Practice Tests')],
                  //   ),
                  // ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[Text('Free DMV  Practice Tests')],
                  ),
                ),
                // footer
                Container(
                    // height: 428,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
                    decoration:
                        BoxDecoration(color: Color.fromARGB(255, 11, 34, 57)),
                    child: Column(children: <Widget>[
                      // footer Top
                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        children: [
                          Column(
                            children: <Widget>[
                              Text(
                                'About',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          )
                        ],
                      ),
                      // footer Bottom
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image(
                                  width: 170,
                                  height: 28,
                                  image: AssetImage('images/logo-white.png')),
                              Container(
                                margin: EdgeInsets.only(top: 4),
                                child: Text(
                                  '© 2023 DMV Test Pro. All rights reserved.',
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 12),
                                ),
                              )
                            ],
                          ),
                          Container(
                              height: 40,
                              width: 120,
                              padding: EdgeInsets.only(left: 16, right: 16),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'English',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SvgPicture.asset(
                                    'images/arrow.svg',
                                    width: 12,
                                    height: 12,
                                  ),
                                ],
                              ))
                        ],
                      )
                    ])),
                // _loadingCircleWidget(),
              ],
            )),
      ),
    );
  }

  Widget _loadingCircleWidget() {
    return const Center(
      child: CircularProgressIndicator(
        backgroundColor: Color.fromARGB(255, 37, 93, 217),
        valueColor: AlwaysStoppedAnimation(Color.fromARGB(255, 225, 225, 225)),
      ),
    );
  }

  List<Widget> _buildFooterList() {
    return FOOTER_LIST.map((footer) => _footerItem(footer)).toList();
  }

  Widget _footerItem(String footer) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.teal),
        child: Text(footer));
  }
}
