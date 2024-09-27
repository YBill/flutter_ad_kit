import 'package:flutter/material.dart';
import 'package:flutter_ad_kit/src/ads.dart';
import 'package:flutter_ad_kit/src/delegate/base_ad_delegate.dart';
import 'package:flutter_ad_kit/src/enums/ad_source.dart';
import 'package:flutter_ad_kit/src/enums/ad_type.dart';

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({
    required this.adSource,
    required this.adUnitId,
    required this.factoryId,
    Key? key,
  }) : super(key: key);

  final AdSource adSource;
  final String adUnitId;
  final String factoryId;

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  BaseAdDelegate? _nativeAd;

  @override
  void initState() {
    super.initState();
    _createNativeAd();
  }

  Future<void> _createNativeAd() async {
    _destroyNativeAd();
    _nativeAd = Ads.instance.createAd(widget.adSource, AdType.native, widget.adUnitId, nativeAdFactoryId: widget.factoryId, pushToQueue: false);
    _nativeAd?.loadAd();
    _nativeAd?.onAdLoaded = onAdReadyForSetState;
  }

  void onAdReadyForSetState([data]) {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant NativeAdWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _createNativeAd();
  }

  @override
  void dispose() {
    super.dispose();
    _destroyNativeAd();
  }

  void _destroyNativeAd() {
    if (_nativeAd != null) {
      _nativeAd?.dispose();
      _nativeAd = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic adWidget = _nativeAd?.showAd();
    if (adWidget is Widget) {
      return Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: adWidget,
      );
    }
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
    );
  }
}
