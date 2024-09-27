import 'package:flutter/foundation.dart';
import 'package:flutter_ad_kit/src/ads.dart';
import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/enums/ad_status.dart';
import 'package:flutter_ad_kit/src/enums/ad_type.dart';
import 'package:flutter_ad_kit/src/listener/ad_listener.dart';
import 'package:flutter_ad_kit/src/mediation/base_ad.dart';
import 'package:flutter_ad_kit/src/utils/ad_config.dart';
import 'package:flutter_ad_kit/src/utils/ad_event_controller.dart';

abstract class BaseAdDelegate {
  BaseAdDelegate(AdSource adSource, AdType adType, String adUnitId, this._eventController, this.adConfig) {
    _baseAd = createAd(adSource, adType, adUnitId);
    _bindCallback(_baseAd);
  }

  @protected
  final BaseAdConfig adConfig;
  final AdEventController _eventController;
  late BaseAd _baseAd;

  String get adUnitId => _baseAd.adUnitId;

  String? get nativeAdFactoryId => _baseAd.nativeAdFactoryId;

  AdSource get adSource => _baseAd.adSource;

  AdType get adType => _baseAd.adType;

  AdStatus get adStatus => _baseAd.adStatus;

  @protected
  BaseAd createAd(AdSource adSource, AdType adType, String adUnitId);

  void dispose() {
    _baseAd.dispose();
  }

  dynamic showAd() {
    return _baseAd.show();
  }

  Future<void> loadAd() async {
    if (adStatus == AdStatus.loaded) {
      if (isExpired()) {
        dispose();
      } else {
        return;
      }
    } else if (adStatus == AdStatus.loading) {
      return;
    }

    await _baseAd.load();
  }

  bool isExpired() {
    if (_adLoadTime == null) {
      return false;
    }
    int maxCacheDurationMinutes = adConfig.maxCacheDurationMinutes(adSource, adType);
    if (maxCacheDurationMinutes == 0) {
      return false;
    }
    if (DateTime.now().subtract(Duration(minutes: maxCacheDurationMinutes)).isAfter(_adLoadTime!)) {
      return true;
    } else {
      return false;
    }
  }

  /// 使用广告后是否自动填充一个新的广告到缓存池中，默认为true
  void setAutoRefillAd(bool isAutoRefillAd) {
    _isAutoRefillAd = isAutoRefillAd;
  }

  AdCallback? onAdLoaded;
  AdCallback? onAdShowed;
  AdCallback? onAdClicked;
  AdFailedCallback? onAdFailedToLoad;
  AdFailedCallback? onAdFailedToShow;
  AdCallback? onAdDismissed;
  AdEarnedRewardCallback? onAdEarnedReward;
  AdPriceCallback? onAdPrice;

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _adLoadTime;

  void _recordAdLoadTime() {
    _adLoadTime = DateTime.now();
  }

  bool _isAutoRefillAd = true;

  void _preloadAd() {
    if (_isAutoRefillAd) {
      Ads.instance.preloadAd(adSource, adType, adUnitId, nativeAdFactoryId: nativeAdFactoryId);
    }
  }

  void _bindCallback(BaseAd ad) {
    ad.onAdLoaded = ([data]) {
      _recordAdLoadTime();
      _eventController.emitAdLoaded(ad.adSource, ad.adType, ad.adUnitId, ad.nativeAdFactoryId, data);
      onAdLoaded?.call(data);
    };
    ad.onAdShowed = ([data]) {
      _eventController.emitAdShowed(ad.adSource, ad.adType, ad.adUnitId, ad.nativeAdFactoryId, data);
      onAdShowed?.call(data);
    };
    ad.onAdClicked = ([data]) {
      _eventController.emitAdClicked(ad.adSource, ad.adType, ad.adUnitId, ad.nativeAdFactoryId, data);
      onAdClicked?.call(data);
    };
    ad.onAdFailedToLoad = (error, [data]) {
      _eventController.emitAdFailedToLoad(ad.adSource, ad.adType, ad.adUnitId, ad.nativeAdFactoryId, error, data);
      onAdFailedToLoad?.call(error, data);
    };
    ad.onAdFailedToShow = (error, [data]) {
      _preloadAd();
      _eventController.emitAdFailedToShow(ad.adSource, ad.adType, ad.adUnitId, ad.nativeAdFactoryId, error, data);
      onAdFailedToShow?.call(error, data);
    };
    ad.onAdDismissed = ([data]) {
      _preloadAd();
      _eventController.emitAdDismissed(ad.adSource, ad.adType, ad.adUnitId, ad.nativeAdFactoryId, data);
      onAdDismissed?.call(data);
    };
    ad.onAdEarnedReward = (rewardType, rewardAmount, [data]) {
      _eventController.emitAdEarnedReward(ad.adSource, ad.adType, ad.adUnitId, ad.nativeAdFactoryId, rewardType, rewardAmount, data);
      onAdEarnedReward?.call(rewardType, rewardAmount, data);
    };
    ad.onAdPrice = (precisionType, price, currencyCode, [data]) {
      onAdPrice?.call(precisionType, price, currencyCode, data);
    };
  }
}
