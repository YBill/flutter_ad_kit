import 'package:flutter_ad_kit/src/listener/ad_listener.dart';

class AdEventCallbacks {
  AdCallback? onAdLoaded;
  AdCallback? onAdShowed;
  AdCallback? onAdClicked;
  AdFailedCallback? onAdFailedToLoad;
  AdFailedCallback? onAdFailedToShow;
  AdCallback? onAdDismissed;
  AdEarnedRewardCallback? onAdEarnedReward;
  AdPriceCallback? onAdPrice;

  AdEventCallbacks({
    this.onAdLoaded,
    this.onAdShowed,
    this.onAdClicked,
    this.onAdFailedToLoad,
    this.onAdFailedToShow,
    this.onAdDismissed,
    this.onAdEarnedReward,
    this.onAdPrice,
  });
}
