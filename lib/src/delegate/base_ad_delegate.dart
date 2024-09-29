import 'package:flutter/foundation.dart';
import 'package:flutter_ad_kit/src/ads.dart';
import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/enums/ad_status.dart';
import 'package:flutter_ad_kit/src/enums/ad_type.dart';
import 'package:flutter_ad_kit/src/listener/ad_event_callbacks.dart';
import 'package:flutter_ad_kit/src/listener/ad_listener.dart';
import 'package:flutter_ad_kit/src/mediation/base_ad.dart';
import 'package:flutter_ad_kit/src/utils/auto_refill_ad_policy.dart';

abstract class BaseAdDelegate {
  BaseAdDelegate(AdSource adSource, AdType adType, String adUnitId, this._adEventCallbacks) {
    _baseAd = createAd(adSource, adType, adUnitId);
    _bindCallback(_baseAd);
  }

  final AdEventCallbacks _adEventCallbacks;
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
    int maxCacheDurationMinutes = Ads.instance.adConfig.maxCacheDurationMinutes(adSource, adType);
    if (maxCacheDurationMinutes == 0) {
      return false;
    }
    if (DateTime.now().subtract(Duration(minutes: maxCacheDurationMinutes)).isAfter(_adLoadTime!)) {
      return true;
    } else {
      return false;
    }
  }

  /// 使用广告后是否自动填充一个新的广告到缓存池中，默认为不自动填充
  void setAutoRefillAd(AutoRefillAdPolicy autoRefillAdPolicy) {
    _autoRefillAdPolicy = autoRefillAdPolicy;
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

  AutoRefillAdPolicy? _autoRefillAdPolicy;

  void _preloadAd() {
    bool forceRefill = _autoRefillAdPolicy?.forceRefill ?? false;
    Ads.instance.preloadAd(adSource, adType, adUnitId, nativeAdFactoryId: nativeAdFactoryId, isForcePreload: forceRefill);
  }

  void _bindCallback(BaseAd ad) {
    ad.onAdLoaded = ([data]) {
      _recordAdLoadTime();
      _adEventCallbacks.onAdLoaded?.call(data);
      onAdLoaded?.call(data);
    };
    ad.onAdShowed = ([data]) {
      if (_autoRefillAdPolicy?.timing == RefillTiming.onAdShowed) {
        _preloadAd();
      }
      _adEventCallbacks.onAdShowed?.call(data);
      onAdShowed?.call(data);
    };
    ad.onAdClicked = ([data]) {
      _adEventCallbacks.onAdClicked?.call(data);
      onAdClicked?.call(data);
    };
    ad.onAdFailedToLoad = (error, [data]) {
      _adEventCallbacks.onAdFailedToLoad?.call(error, data);
      onAdFailedToLoad?.call(error, data);
    };
    ad.onAdFailedToShow = (error, [data]) {
      if (_autoRefillAdPolicy?.timing == RefillTiming.onAdCompleted) {
        _preloadAd();
      }
      _adEventCallbacks.onAdFailedToShow?.call(error, data);
      onAdFailedToShow?.call(error, data);
    };
    ad.onAdDismissed = ([data]) {
      if (_autoRefillAdPolicy?.timing == RefillTiming.onAdCompleted) {
        _preloadAd();
      }
      _adEventCallbacks.onAdDismissed?.call(data);
      onAdDismissed?.call(data);
    };
    ad.onAdEarnedReward = (rewardType, rewardAmount, [data]) {
      _adEventCallbacks.onAdEarnedReward?.call(rewardType, rewardAmount, data);
      onAdEarnedReward?.call(rewardType, rewardAmount, data);
    };
    ad.onAdPrice = (precisionType, price, currencyCode, [data]) {
      _adEventCallbacks.onAdPrice?.call(precisionType, price, currencyCode, data);
      onAdPrice?.call(precisionType, price, currencyCode, data);
    };
  }
}
