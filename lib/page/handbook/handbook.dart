import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

class HandbookPage extends StatefulWidget {
  const HandbookPage({Key? key}) : super(key: key);

  @override
  _HandbookPageState createState() => _HandbookPageState();
}

class _HandbookPageState extends State<HandbookPage> {
  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    //  请求推送授权
    // PermissionStatus status = await Permission.notification.request();
    // PermissionStatus status = await Permission.storage.request();
    // if (status.isGranted) {
    //   // 用户已授权推送权限
    //   print('yesyesyesyesyesyesyes');
    // } else {
    //   // 用户拒绝了推送权限
    //   print('nononononononono');
    // }
  }
  // Future<void> downApkFunction() async {
  //   ///手机储存目录
  //   final directory = await getTemporaryDirectory();
  //   String savePath = directory.path;
  //   //FIXME: 需要生成随记文件名
  //   String appName = "temp.pdf";
  //   String fileFullPath = "${savePath}/${appName}";
  //   print('===========fileFullPath:$fileFullPath');
  //   Dio dio = Dio();
  //   await dio.download(
  //       'https://cdn.dmv-test-pro.com/handbook/ca-drivers-handbook.pdf',
  //       fileFullPath);
  // }

  @override
  Widget build(BuildContext context) {
    double statusBar = MediaQuery.of(context).padding.top;
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
          toolbarHeight: 40,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView(children: <Widget>[
                    Container(
                      width: double.infinity,
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Column(children: <Widget>[
                        Text(
                          "AL Driver's Handbook",
                          style: TextStyle(
                              fontFamily: 'Gilroy-Bold', fontSize: 24),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 32),
                          padding: EdgeInsets.only(bottom: 32),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(0.0, -1.0),
                                end: Alignment(0.0, 1.0),
                                colors: <Color>[
                                  Colors.white,
                                  Color(0xfff4f7f9),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  child: Image.network(
                                    'https://cdn.dmv-test-pro.com/handbook/ca-drivers-handbook.jpg',
                                    width: 150,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 24),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    _pdfInfoItem('Pages', '120'),
                                    _pdfInfoItem('Language', 'ENG'),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 24),
                          child: Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        print('download');
                                      },
                                      child: Container(
                                          width: double.infinity,
                                          height: 56,
                                          margin: EdgeInsets.only(right: 6),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Color(0xff38c296),
                                              borderRadius:
                                                  BorderRadius.circular(28)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SvgPicture.asset(
                                                'images/download.svg',
                                                width: 18,
                                                height: 18,
                                                color: Colors.white,
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 12),
                                                child: Text(
                                                  'Download',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'GoogleSans-Medium',
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                              )
                                            ],
                                          )),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                          width: double.infinity,
                                          height: 56,
                                          margin: EdgeInsets.only(left: 6),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Color(0xff255dd9),
                                              borderRadius:
                                                  BorderRadius.circular(28)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              SvgPicture.asset(
                                                'images/read.svg',
                                                width: 18,
                                                height: 18,
                                                color: Colors.white,
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 12),
                                                child: Text(
                                                  'Read Now',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'GoogleSans-Medium',
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                              )
                                            ],
                                          )),
                                    ))
                              ]),
                        )
                      ]),
                    )
                  ])),
            )
          ],
        ));
  }

  _pdfInfoItem(title, value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
              fontFamily: 'GoogleSans-Regular',
              fontSize: 16,
              color: Color(0xff999999)),
        ),
        Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'GoogleSans-Medium',
                fontSize: 18,
              ),
            )),
      ],
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
