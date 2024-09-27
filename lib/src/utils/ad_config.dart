import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/enums/ad_type.dart';

abstract class BaseAdConfig {
  bool get enableLogger => false;

  /// 广告缓存时间 - 0:不失效
  int maxCacheDurationMinutes(AdSource adSource, AdType adType);

  AdConfig get admobConfig;
}

abstract class AdConfig {
  /// App AD ID
  String get appId;
}
