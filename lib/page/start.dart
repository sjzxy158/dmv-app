import 'dart:io';

import 'package:app/page/home.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../ad_helper.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StartPage extends StatefulWidget {
  // final String? lang;

  // const StartPage({Key? key, required this.lang}) : super(key: key);
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPage();
}

class _StartPage extends State<StartPage> {
  // String? lang;
  NativeAd? _ad;
  int show = 0;
  int _adError = 0;

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    // lang = widget.lang;
    NativeAd(
      adUnitId: AdHelper.nativeFullScreenAdUnitId,
      factoryId: 'fullScreen',
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
  }

  @override
  Widget build(BuildContext context) {
    double statusBar = MediaQuery.of(context).padding.top;
    return Scaffold(
        body: show == 1
            ? ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: Stack(
                  alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 36, 0, 0),
                      // margin: const EdgeInsets.only(top: 36)
                      alignment: Alignment.center,
                      child: AdWidget(ad: _ad!),
                    ),
                    Positioned(
                      top: statusBar + 8,
                      left: 8,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            // return WebView(
                            //   initialUrl: 'https://www.dmv-test-pro.com',
                            // );
                            return HomePage();
                            // return MaterialApp(
                            //   title: 'Welcome to DMV',
                            //   theme: ThemeData(
                            //       primarySwatch: Colors.green,
                            //       primaryColor: Colors.white),
                            //   routes: {
                            //     "/": (_) => WebviewScaffold(
                            //         // url: "https://www.menuwithnutrition.com/",
                            //         // url: "https://dmv.silversiri.com",
                            //         url: "https://www.dmv-test-pro.com",
                            //         appBar: PreferredSize(
                            //             // child: AppBar(), preferredSize: const Size.fromHeight(0.0))),
                            //             child: AppBar(
                            //               backgroundColor: Colors.white,
                            //             ),
                            //             preferredSize: Size.fromHeight(0.0))),
                            //   },
                            //   debugShowCheckedModeBanner: false,
                            // );
                          }));
                        },
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child:
                              SvgPicture.asset('images/close.svg', width: 30),
                        ),
                      ),
                    ),
                  ],
                ))
            : Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 300, bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: const Color.fromARGB(16, 0, 0, 0)),
                      image: const DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("images/logo.png"),
                      ),
                    ),
                  ),
                ),
                const Text('DMV Test Pro',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'GoogleSans',
                    )),
                const Spacer(),
                Container(
                    height: 56,
                    margin:
                        const EdgeInsets.only(left: 24, right: 24, bottom: 100),
                    child: _ad != null || _adError != 0
                        ? ElevatedButton(
                            onPressed: () {
                              if (_adError != 0) {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  // return WebView(
                                  //   initialUrl: 'https://www.dmv-test-pro.com',
                                  // );
                                  return HomePage();
                                  // return MaterialApp(
                                  //   title: 'Welcome to DMV',
                                  //   theme: ThemeData(
                                  //       primarySwatch: Colors.green,
                                  //       primaryColor: Colors.white),
                                  //   routes: {
                                  //     "/": (_) => WebviewScaffold(
                                  //         // url: "https://www.menuwithnutrition.com/",
                                  //         // url: "https://dmv.silversiri.com",
                                  //         url: "https://www.dmv-test-pro.com",
                                  //         appBar: PreferredSize(
                                  //             // child: AppBar(), preferredSize: const Size.fromHeight(0.0))),
                                  //             child: AppBar(
                                  //               backgroundColor: Colors.white,
                                  //             ),
                                  //             preferredSize:
                                  //                 Size.fromHeight(0.0))),
                                  //   },
                                  //   debugShowCheckedModeBanner: false,
                                  // );
                                }));
                              }
                              if (_ad != null) {
                                setState(() {
                                  show = 1;
                                });
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 37, 93, 217)),
                              overlayColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 26, 78, 203)),
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0))),
                            ),
                            child: const Center(
                                child: Text(
                              'CONTINUE',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 16),
                            )),
                          )
                        : _loadDownloadWidget())
              ]));
  }

  Widget _loadDownloadWidget() {
    return const Center(
        child: CircularProgressIndicator(
            backgroundColor: Color.fromARGB(255, 37, 93, 217),
            valueColor:
                AlwaysStoppedAnimation(Color.fromARGB(255, 225, 225, 225))));
  }
}
