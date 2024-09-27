import 'package:flutter_ad_kit/src/enums/ad_event_type.dart';
import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/enums/ad_type.dart';

/// [AdEvent] is used to pass data inside event streams in easy ads instance
/// You can use this to distinguish between different event types and each event type has a data attached to it.
class AdEvent {
  final AdEventType eventType;
  final AdSource adSource;
  final AdType? adType;
  final String? adUnitId;
  final String? nativeAdFactoryId;

  /// Any custom data along with the event
  final Object? data;

  /// In case of [AdEventType.adFailedToLoad] & [AdEventType.adFailedToShow] or in any error case
  final Object? error;

  /// In case of [AdEventType.adEarnedReward]
  String? rewardType;
  num? rewardAmount;

  AdEvent({
    required this.eventType,
    required this.adSource,
    this.adType,
    this.adUnitId,
    this.nativeAdFactoryId,
    this.data,
    this.error,
    this.rewardType,
    this.rewardAmount,
  });
}
