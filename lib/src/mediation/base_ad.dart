import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/enums/ad_status.dart';
import 'package:flutter_ad_kit/src/enums/ad_type.dart';
import 'package:flutter_ad_kit/src/listener/ad_listener.dart';

abstract class BaseAd {
  BaseAd(this.adUnitId, {this.nativeAdFactoryId});

  final String adUnitId;
  final String? nativeAdFactoryId;

  AdSource get adSource;

  AdType get adType;

  AdStatus get adStatus;

  Future<void> load();

  dynamic show();

  void dispose();

  AdCallback? onAdLoaded;
  AdCallback? onAdShowed;
  AdCallback? onAdClicked;
  AdFailedCallback? onAdFailedToLoad;
  AdFailedCallback? onAdFailedToShow;
  AdCallback? onAdDismissed;
  AdEarnedRewardCallback? onAdEarnedReward;
  AdPriceCallback? onAdPrice;
}
