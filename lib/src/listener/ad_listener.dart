import 'package:flutter_ad_kit/src/enums/ad_precision_type.dart';

typedef AdCallback = void Function([Object? data]);

typedef AdFailedCallback = void Function(Object error, [Object? data]);

typedef AdEarnedRewardCallback = void Function(String? rewardType, num? rewardAmount, [Object? data]);

typedef AdPriceCallback = void Function(AdPrecisionType precisionType, int price, String currencyCode, [Object? data]);
