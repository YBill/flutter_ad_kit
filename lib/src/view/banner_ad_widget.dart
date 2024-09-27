import 'package:flutter/material.dart';
import 'package:flutter_ad_kit/src/ads.dart';
import 'package:flutter_ad_kit/src/delegate/banner_ad_delegate.dart';
import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({
    required this.adSource,
    required this.adUnitId,
    this.adSize = AdSize.banner,
    Key? key,
  }) : super(key: key);

  final AdSource adSource;
  final String adUnitId;
  final AdSize adSize;

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAdDelegate? _bannerAd;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    _destroyBannerAd();
    _bannerAd = Ads.instance.createBannerAd(adSource: widget.adSource, adUnitId: widget.adUnitId, adSize: widget.adSize);
    _bannerAd?.loadAd();
    _bannerAd?.onAdLoaded = onAdReadyForSetState;
  }

  void onAdReadyForSetState([data]) {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant BannerAdWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _createBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
    _destroyBannerAd();
  }

  void _destroyBannerAd() {
    if (_bannerAd != null) {
      _bannerAd?.dispose();
      _bannerAd = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic adWidget = _bannerAd?.showAd();
    if (adWidget is Widget) {
      return Container(
        alignment: Alignment.center,
        width: widget.adSize.width.toDouble(),
        height: widget.adSize.height.toDouble(),
        child: adWidget,
      );
    }
    return SizedBox(
      width: widget.adSize.width.toDouble(),
      height: widget.adSize.height.toDouble(),
    );
  }
}
