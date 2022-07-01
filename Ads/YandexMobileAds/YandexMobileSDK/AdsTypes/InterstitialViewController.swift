import UIKit
import YandexMobileAds

class InterstitialViewController: UIViewController {
    
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    var interstitialAd: YMAInterstitialAd!
    
    @IBAction func load() {
        loadButton.isEnabled = false
        // Replace demo R-M-DEMO-interstitial with actual Ad Unit ID
        self.interstitialAd = YMAInterstitialAd(blockID: "R-M-DEMO-interstitial")
        self.interstitialAd.delegate = self;
        self.interstitialAd.load()
    }
    
    @IBAction func show() {
        self.interstitialAd.present(from: self) {[weak self] in
            self?.showButton.isEnabled = false
            self?.loadButton.isEnabled = true
        }
        
    }

    private func toggle() {
        showButton.isEnabled.toggle()
        loadButton.isEnabled.toggle()
    }

}

extension InterstitialViewController: YMAInterstitialAdDelegate {
    func interstitialAdDidLoad(_ interstitialAd: YMAInterstitialAd) {
        showButton.isEnabled = true
        print("Ad loaded")
    }

    func interstitialAdDidFail(toLoad interstitialAd: YMAInterstitialAd, error: Error) {
        print("Loading failed. Error: \(error)")
    }

    func interstitialAdDidClick(_ interstitialAd: YMAInterstitialAd) {
        print("Ad clicked")
    }

    func interstitialAd(_ interstitialAd: YMAInterstitialAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        print("Impression tracked")
    }

    func interstitialAdWillLeaveApplication(_ interstitialAd: YMAInterstitialAd) {
        print("Will leave application")
    }

    func interstitialAdDidFail(toPresent interstitialAd: YMAInterstitialAd, error: Error) {
        print("Failed to present interstitial. Error: \(error)")
    }

    func interstitialAdWillAppear(_ interstitialAd: YMAInterstitialAd) {
        print("Interstitial ad will appear")
    }

    func interstitialAdDidAppear(_ interstitialAd: YMAInterstitialAd) {
        print("Interstitial ad did appear")
    }

    func interstitialAdWillDisappear(_ interstitialAd: YMAInterstitialAd) {
        print("Interstitial ad will disappear")
    }

    func interstitialAdDidDisappear(_ interstitialAd: YMAInterstitialAd) {
        print("Interstitial ad did disappear")
    }

    func interstitialAd(_ interstitialAd: YMAInterstitialAd, willPresentScreen webBrowser: UIViewController?) {
        print("Interstitial ad will present screen")
    }
}
