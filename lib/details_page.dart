import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ad_kit/ad/interstitial_native_ad_page.dart';
import 'package:flutter_ad_kit/navigation_manager.dart';
import 'package:flutter_ad_kit/src/ads.dart';
import 'package:flutter_ad_kit/src/delegate/base_ad_delegate.dart';
import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/enums/ad_status.dart';
import 'package:flutter_ad_kit/src/enums/ad_type.dart';
import 'package:flutter_ad_kit/src/listener/ad_event_callbacks.dart';
import 'package:flutter_ad_kit/src/utils/app_lifecycle_reactor.dart';
import 'package:flutter_ad_kit/src/view/banner_ad_widget.dart';
import 'package:flutter_ad_kit/src/view/native_ad_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    AppLifecycleReactor().listenToAppStateChanges((isForeground) {
      if (isForeground) {
        _showAppOpenAd();
      }
    });
    _preloadAppOpenAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Ads Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_outlined),
            onPressed: () {
              MobileAds.instance.openAdInspector((error) {
                // Error will be non-null if ad inspector closed due to an error.
                print('AdmobPage: openAdInspector error = $error');
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text(
                      'Refresh Ads',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )),
                TextButton(
                    onPressed: () {
                      _showInterstitialAd();
                    },
                    child: const Text(
                      'Show Interstitial Ad',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )),
                TextButton(
                    onPressed: () {
                      _showRewardedAd();
                    },
                    child: const Text(
                      'Show Rewarded Ad',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )),
                TextButton(
                    onPressed: () {
                      _checkShowNativeFullScreenAd();
                    },
                    child: const Text(
                      'Show Native Full Screen Ad',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNativeAdWidget(),
                _buildBannerAdWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNativeAdWidget() {
    final String adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/2247696110' : 'ca-app-pub-3940256099942544/3986624511';
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      alignment: Alignment.center,
      child: NativeAdWidget(
        adSource: AdSource.admob,
        adUnitId: adUnitId,
        factoryId: 'bannerAdFactory',
      ),
    );
  }

  Widget _buildBannerAdWidget() {
    final adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-3940256099942544/2934735716';
    return BannerAdWidget(adSource: AdSource.admob, adUnitId: adUnitId);
  }

  void _showInterstitialAd() {
    final adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/1033173712' : 'ca-app-pub-3940256099942544/4411468910';
    Ads.instance.showAd(
        adSource: AdSource.admob,
        adType: AdType.interstitial,
        adUnitId: adUnitId,
        eventCallback: AdEventCallbacks(
          onAdShowed: ([data]) {
            print('--------------------------- onAdShowed');
          },
          onAdLoaded: ([data]) {
            print('--------------------------- onAdLoaded');
          },
        ));
  }

  void _showRewardedAd() {
    final adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/5224354917' : 'ca-app-pub-3940256099942544/1712485313';
    Ads.instance.showAd(adSource: AdSource.admob, adType: AdType.rewarded, adUnitId: adUnitId);
  }

  Future<void> _checkShowNativeFullScreenAd() async {
    final String adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/2247696110' : 'ca-app-pub-3940256099942544/3986624511';
    var ad =
        await Ads.instance.fetchAd(adSource: AdSource.admob, adType: AdType.native, adUnitId: adUnitId, nativeAdFactoryId: 'interstitialAdFactory');
    if (ad == null) return;
    if (ad.adStatus.isInvalid()) {
      ad.onAdLoaded = ([data]) {
        _showNativeFullScreenAd(ad);
      };
    } else {
      _showNativeFullScreenAd(ad);
    }
  }

  void _showNativeFullScreenAd(BaseAdDelegate ad) {
    if (NavigationApp.navigatorKey.currentContext != null) {
      Navigator.of(NavigationApp.navigatorKey.currentContext!).push(MaterialPageRoute(builder: (BuildContext context) {
        return InterstitialNativeAdPage(ad);
      }));
    }
  }

  void _preloadAppOpenAd() {
    final adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/9257395921' : 'ca-app-pub-3940256099942544/5575463023';
    Ads.instance.preloadAd(AdSource.admob, AdType.appOpen, adUnitId);
  }

  void _showAppOpenAd() {
    final adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/9257395921' : 'ca-app-pub-3940256099942544/5575463023';
    var ad = Ads.instance.popAd(adSource: AdSource.admob, adType: AdType.appOpen, adUnitId: adUnitId);
    if (ad != null) {
      ad.showAd();
    }
  }
}
