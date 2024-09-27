import 'package:flutter_ad_kit/src/delegate/base_ad_delegate.dart';
import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/enums/ad_type.dart';
import 'package:flutter_ad_kit/src/mediation/admob/admob_app_open_ad.dart';
import 'package:flutter_ad_kit/src/mediation/base_ad.dart';
import 'package:flutter_ad_kit/src/utils/ad_config.dart';
import 'package:flutter_ad_kit/src/utils/ad_event_controller.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdDelegate extends BaseAdDelegate {
  AppOpenAdDelegate(AdSource adSource, String adUnitId, AdEventController eventController, BaseAdConfig adConfig)
      : super(adSource, AdType.appOpen, adUnitId, eventController, adConfig);

  @override
  BaseAd createAd(AdSource adSource, AdType adType, String adUnitId) {
    return AdmobAppOpenAd(adUnitId, const AdRequest());
  }

}
