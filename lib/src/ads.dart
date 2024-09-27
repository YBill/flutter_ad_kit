import 'package:collection/collection.dart';
import 'package:flutter_ad_kit/src/delegate/app_open_ad_delegate.dart';
import 'package:flutter_ad_kit/src/delegate/banner_ad_delegate.dart';
import 'package:flutter_ad_kit/src/delegate/base_ad_delegate.dart';
import 'package:flutter_ad_kit/src/delegate/interstitial_ad_delegate.dart';
import 'package:flutter_ad_kit/src/delegate/native_ad_delegate.dart';
import 'package:flutter_ad_kit/src/delegate/rewarded_ad_delegate.dart';
import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/enums/ad_status.dart';
import 'package:flutter_ad_kit/src/enums/ad_type.dart';
import 'package:flutter_ad_kit/src/utils/ad_config.dart';
import 'package:flutter_ad_kit/src/utils/ad_event.dart';
import 'package:flutter_ad_kit/src/utils/ad_event_controller.dart';
import 'package:flutter_ad_kit/src/utils/ad_load_monitor.dart';
import 'package:flutter_ad_kit/src/utils/ad_log.dart';
import 'package:gma_mediation_applovin/gma_mediation_applovin.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Ads {
  Ads._privateConstructor();

  static final Ads instance = Ads._privateConstructor();

  late BaseAdConfig _adConfig;

  final _eventController = AdEventController();

  Stream<AdEvent> get onEvent => _eventController.onEvent;

  List<BaseAdDelegate> get _allAds => [..._interstitialAdsPool, ..._rewardedAdsPool, ..._appOpenAdsPool, ..._nativeAdsPool];

  /// All the interstitial ads will be stored in it
  final List<BaseAdDelegate> _interstitialAdsPool = [];

  /// All the rewarded ads will be stored in it
  final List<BaseAdDelegate> _rewardedAdsPool = [];

  /// All the appOpen ads will be stored in it
  final List<BaseAdDelegate> _appOpenAdsPool = [];

  /// All the native ads will be stored in it
  final List<BaseAdDelegate> _nativeAdsPool = [];

  /// 初始化广告SDK
  /// [adConfig] 广告配置，广告源ID传入才初始化对应的SDK
  /// [admobConfiguration] 添加Admob测试ID
  /// [enableLogger] 是否开启日志
  Future<void> initialize(
    BaseAdConfig adConfig, {
    RequestConfiguration? admobConfiguration,
  }) async {
    if (adConfig.enableLogger) {
      AdLog.enableLogger();
      AdLoadMonitor().listen();
    }
    _adConfig = adConfig;
    await _initAdmob(adConfig.admobConfig.appId, admobConfiguration);
  }

  Future<void> _initAdmob(String admobId, RequestConfiguration? admobConfiguration) async {
    if (admobId.isEmpty) {
      return;
    }

    //AppLovin GDPR
    var appLovin = GmaMediationApplovin();
    appLovin.setHasUserConsent(true);
    appLovin.setIsAgeRestrictedUser(true);
    appLovin.setDoNotSell(true);

    if (admobConfiguration != null) {
      MobileAds.instance.updateRequestConfiguration(admobConfiguration);
    }

    final response = await MobileAds.instance.initialize();
    final status = response.adapterStatuses.values.firstOrNull?.state;

    response.adapterStatuses.forEach((key, value) {
      AdLog.i('AdmobPage initialize -> Adapter status for $key: ${value.description}');
    });

    _eventController.emitSdkInitializedEvent(AdSource.admob, status == AdapterInitializationState.ready);
  }

  /// 创建广告
  BaseAdDelegate? createAd(AdSource adSource, AdType adType, String adUnitId, {String? nativeAdFactoryId, bool pushToQueue = true}) {
    if (adType == AdType.native) {
      final ad = NativeAdDelegate(adSource, adUnitId, nativeAdFactoryId!, _eventController, _adConfig);
      if (pushToQueue) {
        _nativeAdsPool.add(ad);
      }
      return ad;
    } else if (adType == AdType.rewarded) {
      final ad = RewardedAdDelegate(adSource, adUnitId, _eventController, _adConfig);
      if (pushToQueue) {
        _rewardedAdsPool.add(ad);
      }
      return ad;
    } else if (adType == AdType.interstitial) {
      final ad = InterstitialAdDelegate(adSource, adUnitId, _eventController, _adConfig);
      if (pushToQueue) {
        _interstitialAdsPool.add(ad);
      }
      return ad;
    } else if (adType == AdType.appOpen) {
      final ad = AppOpenAdDelegate(adSource, adUnitId, _eventController, _adConfig);
      if (pushToQueue) {
        _appOpenAdsPool.add(ad);
      }
      return ad;
    }
    return null;
  }

  /// 创建横幅广告
  BannerAdDelegate createBannerAd({required AdSource adSource, required AdSize adSize, required String adUnitId}) {
    return BannerAdDelegate(adSource, adUnitId, adSize, _eventController, _adConfig);
  }

  /// 查看广告
  /// 不传参数按照[_allAds]顺序获取缓存的广告
  BaseAdDelegate? peekAd({AdSource? adSource, AdType? adType, String? adUnitId, String? nativeAdFactoryId}) {
    if (adType == AdType.banner) {
      throw ArgumentError('Banner ad is not supported in this method');
    }

    BaseAdDelegate? ad = _allAds.firstWhereOrNull((element) {
      bool only = (adSource == null || element.adSource == adSource) &&
          (adType == null || element.adType == adType) &&
          (adUnitId == null || element.adUnitId == adUnitId);
      if (element.adType == AdType.native) {
        only = only && (nativeAdFactoryId == null || element.nativeAdFactoryId == nativeAdFactoryId);
      }
      return only;
    });
    return ad;
  }

  /// 预加载广告
  /// [isForcePreload] 是否强制缓存广告
  Future<bool> preloadAd(AdSource adSource, AdType adType, String adUnitId, {String? nativeAdFactoryId, bool isForcePreload = false}) async {
    if (adType == AdType.banner) {
      throw ArgumentError('Banner ad is not supported in this method');
    }
    if (adType == AdType.native && (nativeAdFactoryId?.isEmpty ?? true)) {
      throw ArgumentError('Native factoryId cannot be empty');
    }

    BaseAdDelegate? cacheAd = peekAd(adSource: adSource, adType: adType, adUnitId: adUnitId, nativeAdFactoryId: nativeAdFactoryId);
    if (cacheAd != null) {
      if (cacheAd.adStatus == AdStatus.failed || cacheAd.isExpired()) {
        cacheAd.loadAd();
      }
    }

    if (!isForcePreload) {
      if (cacheAd != null) {
        return false;
      }
    }

    BaseAdDelegate? ad = createAd(adSource, adType, adUnitId, nativeAdFactoryId: nativeAdFactoryId, pushToQueue: true);
    await ad?.loadAd();

    return true;
  }

  /// 消费一条广告
  /// [autoRefillAd] 消费广告后是否自动补一条（默认在onAdDismissed或onAdFailedToShow中补充）
  BaseAdDelegate? popAd({AdSource? adSource, AdType? adType, String? adUnitId, String? nativeAdFactoryId, bool autoRefillAd = true}) {
    if (adType == AdType.banner) {
      throw ArgumentError('Banner ad is not supported in this method');
    }

    BaseAdDelegate? ad = peekAd(adSource: adSource, adType: adType, adUnitId: adUnitId, nativeAdFactoryId: nativeAdFactoryId);
    if (ad == null) {
      return null;
    }

    ad.setAutoRefillAd(autoRefillAd);

    if (ad.adType == AdType.native) {
      _nativeAdsPool.remove(ad);
    } else if (ad.adType == AdType.appOpen) {
      _appOpenAdsPool.remove(ad);
    } else if (ad.adType == AdType.interstitial) {
      _interstitialAdsPool.remove(ad);
    } else if (ad.adType == AdType.rewarded) {
      _rewardedAdsPool.remove(ad);
    }

    if (ad.adStatus == AdStatus.failed) {
      return null;
    }
    if (ad.isExpired()) {
      ad.dispose();
      return null;
    }

    return ad;
  }

  /// 消费一条广告，先从缓存中取，没有则先拉取一条
  /// [autoRefillAd] 消费广告后是否自动补一条（默认在onAdDismissed或onAdFailedToShow中补充）
  Future<BaseAdDelegate?> fetchAd(
      {required AdSource adSource, required AdType adType, required String adUnitId, String? nativeAdFactoryId, bool autoRefillAd = true}) async {
    if (adType == AdType.banner) {
      throw ArgumentError('Banner ad is not supported in this method');
    }
    if (adType == AdType.native && (nativeAdFactoryId?.isEmpty ?? true)) {
      throw ArgumentError('Native factoryId cannot be empty');
    }

    BaseAdDelegate? ad =
        popAd(adSource: adSource, adType: adType, adUnitId: adUnitId, nativeAdFactoryId: nativeAdFactoryId, autoRefillAd: autoRefillAd);

    if (ad == null) {
      ad = createAd(adSource, adType, adUnitId, nativeAdFactoryId: nativeAdFactoryId, pushToQueue: false);
      ad?.setAutoRefillAd(autoRefillAd);
      await ad?.loadAd();
    }

    return ad;
  }

  /// 显示广告
  /// [autoRefillAd] 消费广告后是否自动补一条（默认在onAdDismissed或onAdFailedToShow中补充）
  Future<bool> showAd(
      {required AdSource adSource, required AdType adType, required String adUnitId, String? nativeAdFactoryId, bool autoRefillAd = true}) async {
    if (adType == AdType.banner || adType == AdType.native) {
      throw ArgumentError('Native or Banner ad is not supported in this method');
    }
    var ad = await Ads.instance
        .fetchAd(adSource: adSource, adType: adType, adUnitId: adUnitId, nativeAdFactoryId: nativeAdFactoryId, autoRefillAd: autoRefillAd);
    if (ad == null) {
      return false;
    }

    if (ad.adStatus == AdStatus.loaded) {
      ad.showAd();
      return true;
    }

    ad.onAdLoaded = ([data]) {
      ad.showAd();
    };
    return true;
  }

  /// 检查广告是否加载完成
  /// 如果过期则重新加载
  bool isLoaded({AdSource? adSource, AdType? adType, String? adUnitId, String? nativeAdFactoryId}) {
    BaseAdDelegate? ad = peekAd(adSource: adSource, adType: adType, adUnitId: adUnitId, nativeAdFactoryId: nativeAdFactoryId);
    if (ad?.adStatus == AdStatus.loaded) {
      if (ad?.isExpired() ?? false) {
        ad?.loadAd();
        return false;
      }
      return true;
    }
    return false;
  }

  void destroy() {
    _eventController.dispose();
    destroyAds();
  }

  void destroyAds({AdSource? adSource, AdType? adType, String? adUnitId, String? nativeAdFactoryId}) {
    for (final element in _allAds) {
      bool only = (adSource == null || element.adSource == adSource) &&
          (adType == null || element.adType == adType) &&
          (adUnitId == null || element.adUnitId == adUnitId);
      if (element.adType == AdType.native) {
        only = only && (nativeAdFactoryId == null || element.nativeAdFactoryId == nativeAdFactoryId);
      }
      if (only) {
        element.dispose();
      }
    }
  }
}
