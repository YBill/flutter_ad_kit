import 'package:flutter_ad_kit/src/delegate/base_ad_delegate.dart';
import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/enums/ad_type.dart';
import 'package:flutter_ad_kit/src/mediation/admob/admob_banner_ad.dart';
import 'package:flutter_ad_kit/src/mediation/base_ad.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdDelegate extends BaseAdDelegate {
  final AdSize _adSize;

  BannerAdDelegate(super.adSource, super.adType, super.adUnitId, super.eventController, this._adSize);

  @override
  BaseAd createAd(AdSource adSource, AdType adType, String adUnitId) {
    return AdmobBannerAd(adUnitId, const AdRequest(), _adSize);
  }

  @override
  bool isExpired() {
    return true;
  }
}
