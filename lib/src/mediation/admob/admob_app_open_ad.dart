import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/enums/ad_status.dart';
import 'package:flutter_ad_kit/src/enums/ad_type.dart';
import 'package:flutter_ad_kit/src/mediation/base_ad.dart';
import 'package:flutter_ad_kit/src/utils/ad_utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobAppOpenAd extends BaseAd {
  AdmobAppOpenAd(super.adUnitId, this._adRequest);

  final AdRequest _adRequest;

  AppOpenAd? _appOpenAd;
  AdStatus _adStatus = AdStatus.none;

  @override
  AdSource get adSource => AdSource.admob;

  @override
  AdType get adType => AdType.appOpen;

  @override
  AdStatus get adStatus => _adStatus;

  @override
  void dispose() {
    _adStatus = AdStatus.none;
    _appOpenAd?.dispose();
    _appOpenAd = null;
  }

  @override
  Future<void> load() async {
    _adStatus = AdStatus.loading;

    await AppOpenAd.load(
      adUnitId: adUnitId,
      request: _adRequest,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _adStatus = AdStatus.loaded;
          onAdLoaded?.call(ad);
        },
        onAdFailedToLoad: (error) {
          _appOpenAd = null;
          _adStatus = AdStatus.failed;
          onAdFailedToLoad?.call(error);
        },
      ),
    );
  }

  @override
  show() {
    if (_adStatus.isInvalid()) {
      return;
    }

    if (_appOpenAd == null) return;

    _appOpenAd?.onPaidEvent = (ad, valueMicros, precision, currencyCode) {
      var type = AdUtils.getAdPrecisionType(precision);
      int price = valueMicros.toInt();
      onAdPrice?.call(type, price, currencyCode);
    };
    _appOpenAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        onAdShowed?.call(ad);
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        onAdDismissed?.call(ad);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        onAdFailedToShow?.call(error, ad);
      },
      onAdClicked: (ad) {
        onAdClicked?.call(ad);
      },
    );

    _adStatus = AdStatus.none;
    _appOpenAd?.show();
    _appOpenAd = null;
  }
}
