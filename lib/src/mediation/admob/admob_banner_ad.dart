import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/enums/ad_status.dart';
import 'package:flutter_ad_kit/src/enums/ad_type.dart';
import 'package:flutter_ad_kit/src/mediation/base_ad.dart';
import 'package:flutter_ad_kit/src/utils/ad_utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobBannerAd extends BaseAd {
  AdmobBannerAd(super.adUnitId, this._adRequest, this._adSize);

  final AdRequest _adRequest;
  final AdSize _adSize;

  BannerAd? _bannerAd;
  AdStatus _adStatus = AdStatus.none;

  @override
  AdSource get adSource => AdSource.admob;

  @override
  AdType get adType => AdType.banner;

  @override
  AdStatus get adStatus => _adStatus;

  @override
  void dispose() {
    _adStatus = AdStatus.none;
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  @override
  Future<void> load() async {
    _adStatus = AdStatus.loading;

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: _adRequest,
      size: _adSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _adStatus = AdStatus.loaded;
          onAdLoaded?.call(ad);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
          _adStatus = AdStatus.failed;
          onAdFailedToLoad?.call(error);
        },
        onAdImpression: (Ad ad) {
          onAdShowed?.call(ad);
        },
        onAdClosed: (Ad ad) {
          onAdDismissed?.call(ad);
        },
        onAdClicked: (ad) {
          onAdClicked?.call(ad);
        },
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {
          var type = AdUtils.getAdPrecisionType(precision);
          int price = valueMicros.toInt();
          onAdPrice?.call(type, price, currencyCode);
        },
      ),
    );
    await _bannerAd?.load();
  }

  @override
  dynamic show() {
    if (_bannerAd != null && !_adStatus.isInvalid()) {
      return AdWidget(ad: _bannerAd!);
    }
    return null;
  }
}
