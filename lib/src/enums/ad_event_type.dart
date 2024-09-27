enum AdEventType {
  /// When ad network is initialized and ready to load ad units this will be triggered
  /// In case of [adNetworkInitialized], [AdEvent.data] will have a boolean value indicating status of initialization
  adSdkInitialized,
  adLoaded,
  adDismissed,
  adShowed,
  adFailedToLoad,
  adFailedToShow,
  earnedReward,
  adClicked,
}
