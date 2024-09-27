import 'package:flutter/material.dart';
import 'package:flutter_ad_kit/src/delegate/base_ad_delegate.dart';

/// 插屏原生广告页面
class InterstitialNativeAdPage extends StatefulWidget {
  const InterstitialNativeAdPage(this.nativeAd, {super.key});

  final BaseAdDelegate nativeAd;

  @override
  State<InterstitialNativeAdPage> createState() => _InterstitialNativeAdPageState();
}

class _InterstitialNativeAdPageState extends State<InterstitialNativeAdPage> {
  late BaseAdDelegate _nativeAd;

  @override
  void initState() {
    super.initState();
    _nativeAd = widget.nativeAd;
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _nativeAdWidget(),
    );
  }

  Widget _nativeAdWidget() {
    if (_nativeAd.showAd() is Widget) {
      return Column(
        children: [
          Align(alignment: Alignment.centerRight, child: _closeBtnWidget()),
          Expanded(child: SizedBox(child: _nativeAd.showAd(), width: double.infinity, height: double.infinity)),
        ],
      );
    }
    return const SizedBox(width: double.infinity, height: double.infinity);
  }

  Widget _closeBtnWidget() {
    return SafeArea(
      child: Container(
        width: 225,
        height: 34,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 5),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.horizontal(left: Radius.circular(50)),
          boxShadow: [
            BoxShadow(
              color: Color(0x42000000),
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Close and continue to app',
              style: TextStyle(color: Color(0xFF292D33), fontSize: 12),
            ),
            const SizedBox(width: 12),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close, size: 20, color: Color(0xFF292D33))),
          ],
        ),
      ),
    );
  }
}
