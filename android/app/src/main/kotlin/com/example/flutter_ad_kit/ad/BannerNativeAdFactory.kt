package com.example.flutter_ad_kit.ad

import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.example.flutter_ad_kit.R
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class BannerNativeAdFactory(private val layoutInflater: LayoutInflater) : NativeAdFactory {

    override fun createNativeAd(nativeAd: NativeAd?, customOptions: MutableMap<String, Any>?): NativeAdView {
        val adView = layoutInflater.inflate(R.layout.banner_native_ad_layout, null) as NativeAdView

        // Set the media view.
//        adView.mediaView = adView.findViewById(R.id.ad_media)

        // Set other ad assets.
        adView.headlineView = adView.findViewById(R.id.ad_headline)
        adView.bodyView = adView.findViewById(R.id.ad_body)
        adView.callToActionView = adView.findViewById(R.id.ad_call_to_action)
        adView.iconView = adView.findViewById(R.id.ad_app_icon)

        // The headline and mediaContent are guaranteed to be in every NativeAd.
        (adView.headlineView as TextView).text = nativeAd?.headline
//        adView.mediaView?.mediaContent = nativeAd?.mediaContent

        if (nativeAd?.body != null) {
            (adView.bodyView as TextView).text = nativeAd.body
        }

        if (nativeAd?.callToAction == null) {
            adView.callToActionView?.visibility = View.GONE
        } else {
            adView.callToActionView?.visibility = View.VISIBLE
            (adView.callToActionView as TextView).text = nativeAd.callToAction
        }

        if (nativeAd?.icon != null) {
            (adView.iconView as ImageView).setImageDrawable(nativeAd.icon?.drawable)
        }

        // This method tells the Google Mobile Ads SDK that you have finished populating your
        // native ad view with this native ad.
        nativeAd?.let {
            adView.setNativeAd(it)
        }

        return adView
    }
}