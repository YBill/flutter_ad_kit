import 'package:flutter_ad_kit/src/ads.dart';
import 'package:flutter_ad_kit/src/enums/ad_event_type.dart';
import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/utils/ad_event.dart';
import 'package:flutter_ad_kit/src/utils/ad_log.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdLoadMonitor {
  void listen() {
    Ads.instance.onEvent.listen(_onAdEvent);
  }

  void _onAdEvent(AdEvent event) {
    switch (event.eventType) {
      case AdEventType.adSdkInitialized:
        _onAdNetworkInitialized(event);
        break;
      case AdEventType.adLoaded:
        _onAdLoaded(event);
        break;
      case AdEventType.adDismissed:
        _onAdDismissed(event);
        break;
      case AdEventType.adShowed:
        _onAdShowed(event);
        break;
      case AdEventType.adFailedToLoad:
        _onAdFailedToLoad(event);
        break;
      case AdEventType.adFailedToShow:
        _onAdFailedShow(event);
        break;
      case AdEventType.earnedReward:
        _onEarnedReward(event);
        break;
      case AdEventType.adClicked:
        _onClicked(event);
        break;
    }
  }

  void _onAdNetworkInitialized(AdEvent event) {
    if (event.data == true) {
      AdLog.i("${event.adSource.name} has been initialized and is ready to use.");
    } else {
      AdLog.e("${event.adSource.name} could not be initialized.");
    }
  }

  void _onAdLoaded(AdEvent event) {
    String message = "[${event.adUnitId}] ${event.adType?.name} ads for ${event.adSource.name} have been loaded.";
    message += _getMediationAdapterName(event);
    AdLog.i(message);
  }

  void _onAdFailedToLoad(AdEvent event) {
    AdLog.e("[${event.adUnitId}] ${event.adType?.name} ads for ${event.adSource.name} could not be loaded.\nERROR: ${event.error.toString()}");
  }

  void _onAdShowed(AdEvent event) {
    String message = "[${event.adUnitId}] ${event.adType?.name} ad for ${event.adSource.name} has been shown.";
    message += _getMediationAdapterName(event);
    AdLog.i(message);
  }

  void _onAdFailedShow(AdEvent event) {
    String message = "[${event.adUnitId}] ${event.adType?.name} ad for ${event.adSource.name} could not be showed.\nERROR: ${event.error.toString()}";
    message += _getMediationAdapterName(event);
    AdLog.i(message);
  }

  void _onAdDismissed(AdEvent event) {
    String message = "[${event.adUnitId}] ${event.adType?.name} ad for ${event.adSource.name} has been dismissed.";
    message += _getMediationAdapterName(event);
    AdLog.i(message);
  }

  void _onEarnedReward(AdEvent event) {
    final dataMap = event.data as Map<String, dynamic>?;
    AdLog.i("[${event.adUnitId}] User has earned ${dataMap?['rewardAmount']} of ${dataMap?['rewardType']} from ${event.adSource.name}");
  }

  void _onClicked(AdEvent event) {
    String message = "[${event.adUnitId}] ${event.adType?.name} ad for ${event.adSource.name} has been clicked.";
    message += _getMediationAdapterName(event);
    AdLog.i(message);
  }

  String _getMediationAdapterName(AdEvent event) {
    if (event.adSource == AdSource.admob) {
      final ad = event.data as Ad?;
      return ' adapter: ${ad?.responseInfo?.mediationAdapterClassName}';
    }
    return '';
  }
}
