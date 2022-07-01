//
//  ViewController.swift
//  YandexMobileAds
//
//  Created by hy99ee on 29.06.2022.
//

import UIKit
import YandexMobileAds

class BannerViewController: UIViewController {
    var adView: YMAAdView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Replace demo R-M-DEMO-320x50 with actual Ad Unit ID
        let adSize = YMAAdSize.fixedSize(with: .init(width: 320, height: 50))
        self.adView = YMAAdView(blockID: "R-M-DEMO-320x50", adSize: adSize)
        self.adView.delegate = self
    }
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
    
    @IBAction func load(_ sender: Any) {
        loadButton.isEnabled = false
        self.adView.removeFromSuperview()
        self.adView.loadAd()
    }
    @IBAction func show(_ sender: Any) {
        self.adView.displayAtBottom(in: self.view)
        loadButton.isEnabled = true
        showButton.isEnabled = false
    }
}


extension BannerViewController: YMAAdViewDelegate {
    func adViewDidLoad(_ adView: YMAAdView) {
        showButton.isEnabled = true
        print("Ad loaded")
    }

    func adViewDidClick(_ adView: YMAAdView) {
        print("Ad clicked")
    }

    func adView(_ adView: YMAAdView, didTrackImpressionWith impressionData: YMAImpressionData?) {
        print("Impression tracked")
    }
    
    func adViewDidFailLoading(_ adView: YMAAdView, error: Error) {
        print("Ad failed loading. Error: \(error)")
    }
    
    func adViewWillLeaveApplication(_ adView: YMAAdView) {
        print("Ad will leave application")
    }
    
    func adView(_ adView: YMAAdView, willPresentScreen viewController: UIViewController?) {
        print("Ad will present screen")
    }

    func adView(_ adView: YMAAdView, didDismissScreen viewController: UIViewController?) {
        print("Ad did dismiss screen")
    }
    
}
