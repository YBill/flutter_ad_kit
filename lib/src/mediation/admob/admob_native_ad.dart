import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/enums/ad_status.dart';
import 'package:flutter_ad_kit/src/enums/ad_type.dart';
import 'package:flutter_ad_kit/src/mediation/base_ad.dart';
import 'package:flutter_ad_kit/src/utils/ad_utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobNativeAd extends BaseAd {
  AdmobNativeAd(
    String adUnitId,
    String factoryId,
    this._adRequest,
  ) : super(adUnitId, nativeAdFactoryId: factoryId);

  final AdRequest _adRequest;

  NativeAd? _nativeAd;
  AdStatus _adStatus = AdStatus.none;

  @override
  AdSource get adSource => AdSource.admob;

  @override
  AdType get adType => AdType.native;

  @override
  AdStatus get adStatus => _adStatus;

  @override
  void dispose() {
    _adStatus = AdStatus.none;
    _nativeAd?.dispose();
    _nativeAd = null;
  }

  @override
  Future<void> load() async {
    _adStatus = AdStatus.loading;

    _nativeAd = NativeAd(
      adUnitId: adUnitId,
      request: _adRequest,
      factoryId: nativeAdFactoryId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          _adStatus = AdStatus.loaded;
          onAdLoaded?.call(ad);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _nativeAd = null;
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
    await _nativeAd?.load();
  }

  @override
  dynamic show() {
    if (_nativeAd != null && !_adStatus.isInvalid()) {
      return AdWidget(ad: _nativeAd!);
    }
    return null;
  }
}
