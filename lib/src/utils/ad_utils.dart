import 'package:flutter_ad_kit/src/enums/ad_precision_type.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdUtils {
  /// precision to AdPrecisionType
  static AdPrecisionType getAdPrecisionType(PrecisionType precision) {
    switch (precision) {
      case PrecisionType.unknown:
        return AdPrecisionType.unknown;
      case PrecisionType.estimated:
        return AdPrecisionType.estimated;
      case PrecisionType.publisherProvided:
        return AdPrecisionType.publisherProvided;
      case PrecisionType.precise:
        return AdPrecisionType.precise;
      default:
        return AdPrecisionType.unknown;
    }
  }
}
