package com.dmv.app

import FullNativeAdFactory
import ListTileNativeAdFactory
import FullTileAdFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

    //     // TODO: Register the ListTileNativeAdFactory
        GoogleMobileAdsPlugin.registerNativeAdFactory(
                flutterEngine, "fullScreen", FullNativeAdFactory(context))
        GoogleMobileAdsPlugin.registerNativeAdFactory(
                flutterEngine, "listTile", ListTileNativeAdFactory(context))
        GoogleMobileAdsPlugin.registerNativeAdFactory(
                flutterEngine, "fullTile", FullTileAdFactory(context))
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)

    //     // TODO: Unregister the ListTileNativeAdFactory
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "fullScreen")

        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTile")

        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "fullTile")

    }
}
