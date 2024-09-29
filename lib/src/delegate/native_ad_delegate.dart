import 'package:flutter_ad_kit/src/delegate/base_ad_delegate.dart';
import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/enums/ad_type.dart';
import 'package:flutter_ad_kit/src/mediation/admob/admob_native_ad.dart';
import 'package:flutter_ad_kit/src/mediation/base_ad.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdDelegate extends BaseAdDelegate {
  final String _factoryId;

  NativeAdDelegate(super.adSource, super.adType, super.adUnitId, super.eventController, this._factoryId);

  @override
  BaseAd createAd(AdSource adSource, AdType adType, String adUnitId) {
    return AdmobNativeAd(adUnitId, _factoryId, const AdRequest());
  }
}
