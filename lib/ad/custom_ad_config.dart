import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/enums/ad_type.dart';
import 'package:flutter_ad_kit/src/utils/ad_config.dart';

class CustomAdConfig extends BaseAdConfig {
  @override
  AdConfig get admobConfig => AdConfigImpl();

  @override
  bool get enableLogger => true;

  @override
  int maxCacheDurationMinutes(AdSource adSource, AdType adType) {
    if (adType == AdType.appOpen) {
      return 4 * 60;
    }
    return 60;
  }
}

class AdConfigImpl extends AdConfig {
  @override
  String get appId => 'ca-app-pub-3940256099942544~3347511713';
}
