import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import com.dmv.app.R
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class ListTileNativeAdFactory(val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {

    override fun createNativeAd(
            nativeAd: NativeAd,
            customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val nativeAdView = LayoutInflater.from(context)
                .inflate(R.layout.list_tile_native_ad, null) as NativeAdView

        with(nativeAdView) {
            val attributionViewSmall =
                    findViewById<TextView>(R.id.tv_list_tile_native_ad_attribution_small)
            val attributionViewLarge =
                    findViewById<TextView>(R.id.tv_list_tile_native_ad_attribution_large)

            val iconView = findViewById<ImageView>(R.id.iv_list_tile_native_ad_icon)
            val icon = nativeAd.icon
            if (icon != null) {
                attributionViewSmall.visibility = View.VISIBLE
                attributionViewLarge.visibility = View.INVISIBLE
                iconView.setImageDrawable(icon.drawable)
            } else {
                attributionViewSmall.visibility = View.INVISIBLE
                attributionViewLarge.visibility = View.VISIBLE
            }
            this.iconView = iconView

            val headlineView = findViewById<TextView>(R.id.tv_list_tile_native_ad_headline)
            headlineView.text = nativeAd.headline
            this.headlineView = headlineView

            val bodyView = findViewById<TextView>(R.id.tv_list_tile_native_ad_body)
            with(bodyView) {
                text = nativeAd.body
                visibility = if (nativeAd.body.isNotEmpty()) View.VISIBLE else View.INVISIBLE
            }
            this.bodyView = bodyView

            val button = findViewById<Button>(R.id.ad_tile_button)
            button.setOnClickListener { nativeAd.callToAction }
            button.setText(nativeAd.callToAction)
            this.callToActionView = button

//            var ratingView = findViewById<RatingBar>(R.id.ad_rating)
//            ratingView.numStars = nativeAd.starRating.toInt()
//            this.starRatingView = ratingView

            setNativeAd(nativeAd)
        }

        return nativeAdView
    }
}