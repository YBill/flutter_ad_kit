import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/enums/ad_status.dart';
import 'package:flutter_ad_kit/src/enums/ad_type.dart';
import 'package:flutter_ad_kit/src/mediation/base_ad.dart';
import 'package:flutter_ad_kit/src/utils/ad_utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobInterstitialAd extends BaseAd {
  AdmobInterstitialAd(super.adUnitId, this._adRequest);

  final AdRequest _adRequest;

  InterstitialAd? _interstitialAd;
  AdStatus _adStatus = AdStatus.none;

  @override
  AdSource get adSource => AdSource.admob;

  @override
  AdType get adType => AdType.interstitial;

  @override
  AdStatus get adStatus => _adStatus;

  @override
  void dispose() {
    _adStatus = AdStatus.none;
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }

  @override
  Future<void> load() async {
    _adStatus = AdStatus.loading;

    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: _adRequest,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _adStatus = AdStatus.loaded;
          onAdLoaded?.call(ad);
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
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

    if (_interstitialAd == null) return;

    _interstitialAd?.onPaidEvent = (ad, valueMicros, precision, currencyCode) {
      var type = AdUtils.getAdPrecisionType(precision);
      int price = valueMicros.toInt();
      onAdPrice?.call(type, price, currencyCode);
    };
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
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
    _interstitialAd?.setImmersiveMode(true);
    _interstitialAd?.show();
    _interstitialAd = null;
  }
}
