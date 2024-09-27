import 'dart:async';

import 'package:flutter_ad_kit/src/enums/ad_event_type.dart';
import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/enums/ad_type.dart';
import 'package:flutter_ad_kit/src/utils/ad_event.dart';

class AdEventController {
  Stream<AdEvent> get onEvent => _onEventController.stream;
  final _onEventController = StreamController<AdEvent>.broadcast();

  void dispose() {
    if (!_onEventController.isClosed) {
      _onEventController.close();
    }
  }

  void emitSdkInitializedEvent(AdSource adSource, bool status) {
    _onEventController.add(AdEvent(
      eventType: AdEventType.adSdkInitialized,
      adSource: adSource,
      data: status,
    ));
  }

  void emitAdLoaded(AdSource adSource, AdType adType, String adUnitId, String? nativeAdFactoryId, Object? data) {
    _onEventController.add(AdEvent(
      eventType: AdEventType.adLoaded,
      adSource: adSource,
      adType: adType,
      adUnitId: adUnitId,
      nativeAdFactoryId: nativeAdFactoryId,
      data: data,
    ));
  }

  void emitAdShowed(AdSource adSource, AdType adType, String adUnitId, String? nativeAdFactoryId, Object? data) {
    _onEventController.add(AdEvent(
      eventType: AdEventType.adShowed,
      adSource: adSource,
      adType: adType,
      adUnitId: adUnitId,
      nativeAdFactoryId: nativeAdFactoryId,
      data: data,
    ));
  }

  void emitAdClicked(AdSource adSource, AdType adType, String adUnitId, String? nativeAdFactoryId, Object? data) {
    _onEventController.add(AdEvent(
      eventType: AdEventType.adClicked,
      adSource: adSource,
      adType: adType,
      adUnitId: adUnitId,
      nativeAdFactoryId: nativeAdFactoryId,
      data: data,
    ));
  }

  void emitAdFailedToLoad(AdSource adSource, AdType adType, String adUnitId, String? nativeAdFactoryId, Object? error, Object? data) {
    _onEventController.add(AdEvent(
      eventType: AdEventType.adFailedToLoad,
      adSource: adSource,
      adType: adType,
      adUnitId: adUnitId,
      nativeAdFactoryId: nativeAdFactoryId,
      error: error,
      data: data,
    ));
  }

  void emitAdFailedToShow(AdSource adSource, AdType adType, String adUnitId, String? nativeAdFactoryId, Object? error, Object? data) {
    _onEventController.add(AdEvent(
      eventType: AdEventType.adFailedToShow,
      adSource: adSource,
      adType: adType,
      adUnitId: adUnitId,
      nativeAdFactoryId: nativeAdFactoryId,
      error: error,
      data: data,
    ));
  }

  void emitAdDismissed(AdSource adSource, AdType adType, String adUnitId, String? nativeAdFactoryId, Object? data) {
    _onEventController.add(AdEvent(
      eventType: AdEventType.adDismissed,
      adSource: adSource,
      adType: adType,
      adUnitId: adUnitId,
      nativeAdFactoryId: nativeAdFactoryId,
      data: data,
    ));
  }

  void emitAdEarnedReward(
      AdSource adSource, AdType adType, String adUnitId, String? nativeAdFactoryId, String? rewardType, num? rewardAmount, Object? data) {
    _onEventController.add(AdEvent(
      eventType: AdEventType.earnedReward,
      adSource: adSource,
      adType: adType,
      adUnitId: adUnitId,
      nativeAdFactoryId: nativeAdFactoryId,
      rewardType: rewardType,
      rewardAmount: rewardAmount,
      data: data,
    ));
  }
}
