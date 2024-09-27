import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/enums/ad_status.dart';
import 'package:flutter_ad_kit/src/enums/ad_type.dart';
import 'package:flutter_ad_kit/src/mediation/base_ad.dart';
import 'package:flutter_ad_kit/src/utils/ad_utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobRewardedAd extends BaseAd {
  AdmobRewardedAd(super.adUnitId, this._adRequest);

  final AdRequest _adRequest;

  RewardedAd? _rewardedAd;
  AdStatus _adStatus = AdStatus.none;

  @override
  AdSource get adSource => AdSource.admob;

  @override
  AdType get adType => AdType.rewarded;

  @override
  AdStatus get adStatus => _adStatus;

  @override
  void dispose() {
    _adStatus = AdStatus.none;
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }

  @override
  Future<void> load() async {
    _adStatus = AdStatus.loading;

    await RewardedAd.load(
      adUnitId: adUnitId,
      request: _adRequest,
      rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
        _rewardedAd = ad;
        _adStatus = AdStatus.loaded;
        onAdLoaded?.call(ad);
      }, onAdFailedToLoad: (LoadAdError error) {
        _rewardedAd = null;
        _adStatus = AdStatus.failed;
        onAdFailedToLoad?.call(error);
      }),
    );
  }

  @override
  show() {
    if (_adStatus.isInvalid()) {
      return;
    }

    if (_rewardedAd == null) return;

    _rewardedAd?.onPaidEvent = (ad, valueMicros, precision, currencyCode) {
      var type = AdUtils.getAdPrecisionType(precision);
      int price = valueMicros.toInt();
      onAdPrice?.call(type, price, currencyCode);
    };
    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
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
    _rewardedAd?.setImmersiveMode(true);
    _rewardedAd?.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      onAdEarnedReward?.call(reward.type, reward.amount);
    });
    _rewardedAd = null;
  }
}
