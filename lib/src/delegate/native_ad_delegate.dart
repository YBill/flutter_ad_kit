import 'package:flutter_ad_kit/src/delegate/base_ad_delegate.dart';
import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/enums/ad_type.dart';
import 'package:flutter_ad_kit/src/mediation/admob/admob_native_ad.dart';
import 'package:flutter_ad_kit/src/mediation/base_ad.dart';
import 'package:flutter_ad_kit/src/utils/ad_config.dart';
import 'package:flutter_ad_kit/src/utils/ad_event_controller.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdDelegate extends BaseAdDelegate {
  NativeAdDelegate(AdSource adSource, String adUnitId, this._factoryId, AdEventController eventController, BaseAdConfig adConfig)
      : super(adSource, AdType.native, adUnitId, eventController, adConfig);

  final String _factoryId;

  @override
  BaseAd createAd(AdSource adSource, AdType adType, String adUnitId) {
    return AdmobNativeAd(adUnitId, _factoryId, const AdRequest());
  }

}
