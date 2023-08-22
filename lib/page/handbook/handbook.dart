import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../ad_helper.dart';
import '../../http/api.dart';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bubble/bubble.dart';

class HandbookPage extends StatefulWidget {
  final String stateAbbr;
  final String stateValue;
  final String stateSlug;
  final String licence;
  final String licenceLower;
  const HandbookPage(
      {Key? key,
      required this.stateAbbr,
      required this.stateValue,
      required this.stateSlug,
      required this.licence,
      required this.licenceLower})
      : super(key: key);

  @override
  _HandbookPageState createState() => _HandbookPageState();
}

List HANDBOOK_LIST = [];

class _HandbookPageState extends State<HandbookPage>
    with AutomaticKeepAliveClientMixin {
  NativeAd? _ad;
  int _adError = 0;

  String stateAbbr = '';
  String stateValue = '';
  String stateSlug = '';
  String licence = '';
  String licenceLower = '';
  int _getHandbookInfoStatus = -1;
  String pageTitle = '';
  int pageNum = 0;

  double currentProgress = 0.0;
  bool downloading = false;
  bool isShowBubble = false;

  String pdfUrl = "https://cdn.dmv-test-pro.com/handbook/";
  String downloadUrl = "";
  String fileName = 'sample.pdf';
  String imageUrl = '';

  bool isInProduction = bool.fromEnvironment("dart.vm.product");
  String path = '';

  @override
  void initState() {
    super.initState();
    stateAbbr = widget.stateAbbr;
    stateValue = widget.stateValue;
    stateSlug = widget.stateSlug;
    licence = widget.licence;
    licenceLower = widget.licenceLower;

    NativeAd(
      adUnitId: AdHelper.nativeAdUnitId,
      factoryId: 'fullTile',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _ad = ad as NativeAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          setState(() {
            _adError = error.code;
          });
          debugPrint(
              'Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    ).load();

    _getStateAndTypeSelectStatus();
    _testSetCurrentScreen();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  Future getHandbookInfo() async {
    setState(() {
      if (isInProduction) {
        path = productionApi.getHandbookList;
      } else {
        path = silversiriApi.getHandbookList;
      }
    });
    var res = await http.post(
      Uri.parse(path),
      body: {'type': licenceLower, 'state': stateSlug},
    );
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      // print(body);
      setState(() {
        HANDBOOK_LIST = body['data'];
        if (licenceLower == 'car') {
          pageTitle = '$stateAbbr Drivers Handbook';
        } else if (licenceLower == 'motorcycle') {
          pageTitle = '$stateAbbr Motorcycle Handbook';
        } else if (licenceLower == 'cdl') {
          pageTitle = '$stateAbbr CDL Handbook';
        }
        pageNum = HANDBOOK_LIST[0]['page'];
        downloadUrl = '$pdfUrl${HANDBOOK_LIST[0]['file']}';
        fileName = HANDBOOK_LIST[0]['file'];
        imageUrl = '$pdfUrl${HANDBOOK_LIST[0]['file'].split('.')[0]}.jpg';
        // print('===================');
        // print(downloadUrl);
        // print(imageUrl);
        _getHandbookInfoStatus = res.statusCode;
      });
      // _setListStatus(TEST_LIST);
      return body;
    } else {
      return null;
    }
  }

  @override
  bool get wantKeepAlive => true;

  void _downloadPdf() async {
    bool isPermissionReady = await _checkDownloadPermission();

    if (isPermissionReady) {
      String savePath = '/storage/emulated/0/Download';
      Dio dio = Dio();
      setState(() {
        downloading = true;
      });

      try {
        Response response = await dio
            .download(downloadUrl, "$savePath/$fileName",
                onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              currentProgress = received / total;
              print(currentProgress);
            });
            if (currentProgress == 1) {
              setState(() {
                downloading = false;
                isShowBubble = true;
                currentProgress = 0.0;
              });
            }
          }
        });
      } catch (e) {
        if (e is DioException && e.response?.statusCode == 403) {
          // Fluttertoast.showToast(msg: "Http status error 403");
        }
      }
    } else {
      // Fluttertoast.showToast(msg: "DMV Permission Denied");
    }
  }

  Future<bool> _checkDownloadPermission() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    var version = androidInfo.version.release;
    List<String> versionList = version!.split('.');
    Permission permission;
    if (int.parse(versionList[0]) < 13) {
      permission = Permission.storage;
    } else {
      permission = Permission.mediaLibrary;
    }

    PermissionStatus status = await permission.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      //权限拒绝， 需要区分IOS和Android，二者不一样
      requestPermission(permission);
      return false;
    } else if (status.isPermanentlyDenied) {
      //权限永久拒绝，且不在提示，需要进入设置界面，IOS和Android不同
      openAppSettings();
      return false;
    } else if (status.isRestricted) {
      //活动限制（例如，设置了家长///控件，仅在iOS以上受支持。
      openAppSettings();
      return false;
    } else {
      //第一次申请
      requestPermission(permission);
      return false;
    }
  }

  void requestPermission(Permission permission) async {
    //发起权限申请
    PermissionStatus status = await permission.request();
    // 返回权限申请的状态 status

    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _testSetCurrentScreen() async {
    await FirebaseAnalytics.instance.setCurrentScreen(
      screenName: '${stateValue} ${licence} Handbook',
      screenClassOverride: '${stateValue} ${licence} Handbook',
    );
  }

  @override
  Widget build(BuildContext context) {
    double statusBar = MediaQuery.of(context).padding.top;
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
          toolbarHeight: 32,
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
                      margin: EdgeInsets.only(bottom: 8),
                      child: Column(children: <Widget>[
                        Text(
                          pageTitle,
                          style: TextStyle(
                              fontFamily: 'Gilroy-Bold', fontSize: 24),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 16),
                          padding: EdgeInsets.only(bottom: 16),
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
                                  child: _getHandbookInfoStatus == 200
                                      ? Container(
                                          height: 200,
                                          child: Image.network(
                                            imageUrl,
                                            width: 150,
                                          ),
                                        )
                                      : SizedBox(
                                          height: 200,
                                          child: _loadDownloadWidget(),
                                        )),
                              Container(
                                margin: EdgeInsets.only(top: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    _pdfInfoItem('Pages', pageNum.toString()),
                                    _pdfInfoItem('Language', 'EN'),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        _ad != null || _adError != 0
                            ? Container(
                                // decoration: BoxDecoration(color: Colors.red),
                                height: 220,
                                margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                // margin: const EdgeInsets.only(top: 36)
                                alignment: Alignment.center,
                                child: AdWidget(ad: _ad!))
                            : Text(''),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 8),
                          child: Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        // print('download');
                                        _downloadPdf();
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
                                              downloading
                                                  ? SizedBox(
                                                      width: 14,
                                                      height: 14,
                                                      child:
                                                          CircularProgressIndicator(
                                                        value: currentProgress,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : SvgPicture.asset(
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
                                // Expanded(
                                //     flex: 1,
                                //     child: InkWell(
                                //       onTap: () {},
                                //       child: Container(
                                //           width: double.infinity,
                                //           height: 56,
                                //           margin: EdgeInsets.only(left: 6),
                                //           alignment: Alignment.center,
                                //           decoration: BoxDecoration(
                                //               color: Color(0xff255dd9),
                                //               borderRadius:
                                //                   BorderRadius.circular(28)),
                                //           child: Row(
                                //             mainAxisAlignment:
                                //                 MainAxisAlignment.center,
                                //             children: <Widget>[
                                //               SvgPicture.asset(
                                //                 'images/read.svg',
                                //                 width: 18,
                                //                 height: 18,
                                //                 color: Colors.white,
                                //               ),
                                //               Container(
                                //                 margin:
                                //                     EdgeInsets.only(left: 12),
                                //                 child: Text(
                                //                   'Read Now',
                                //                   style: TextStyle(
                                //                       fontFamily:
                                //                           'GoogleSans-Medium',
                                //                       fontSize: 16,
                                //                       color: Colors.white),
                                //                 ),
                                //               )
                                //             ],
                                //           )),
                                //     ))
                              ]),
                        ),
                        if (isShowBubble)
                          Bubble(
                            margin: const BubbleEdges.only(
                                left: 16, right: 16, top: 24),
                            nip: BubbleNip.no,
                            // color: const Color.fromARGB(255, 37, 93, 217),
                            color: Color.fromARGB(255, 0, 0, 0),
                            child: const Text(
                              'Download Successful! You can find your downloaded pdf in your Download folder',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'GoogleSans-Regular'),
                            ),
                          ),
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

  _getStateAndTypeSelectStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      licenceLower = prefs.getString('typeSelectLicenceLower');
    });
    print('===================');
    print(stateAbbr);
    print(stateSlug);
    print(licenceLower);
    getHandbookInfo();
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
