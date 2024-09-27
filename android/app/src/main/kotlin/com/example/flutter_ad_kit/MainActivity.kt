package com.example.flutter_ad_kit

import com.example.flutter_ad_kit.ad.BannerNativeAdFactory
import com.example.flutter_ad_kit.ad.CardNativeAdFactory
import com.example.flutter_ad_kit.ad.InterstitialNativeAdFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "interstitialAdFactory", InterstitialNativeAdFactory(layoutInflater))
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "cardAdFactory", CardNativeAdFactory(layoutInflater))
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "bannerAdFactory", BannerNativeAdFactory(layoutInflater))
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "interstitialAdFactory")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "cardAdFactory")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "bannerAdFactory")
    }

}
