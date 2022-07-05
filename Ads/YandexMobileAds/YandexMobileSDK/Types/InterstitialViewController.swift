import UIKit
import YandexMobileAds

class InterstitialViewController: UIViewController {
    
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    private var interstitialAd: YMAInterstitialAd!
    
    private var logView = LogView()
    private lazy var logViewHeight = self.logView.heightAnchor.constraint(equalToConstant: 0)
    private var _logViewOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logView.viewControllerDelegate = self
        guard let logData = try? LogStore.shared.data(self) else { return }
        logView.configured(with: logData)
    }
    
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

}

extension InterstitialViewController: LogViewControllerDelegate {
    var topOffset: CGFloat {
        get {
            _logViewOffset
        }
        set {
            _logViewOffset = newValue
        }
    }
    
    
    
    func initLogView() {
        view.addSubview(logView)
        logView.translatesAutoresizingMaskIntoConstraints = false
        logView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        logView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        logView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        logViewHeight.constant = self.topOffset
        logViewHeight.isActive = true
        
        self.view.layoutIfNeeded()
    }
    
    func openLogView() {
        logViewHeight.constant = 500
        UIView.animate(withDuration: 0.5) { [unowned self] in self.view.layoutIfNeeded() }
    }
    
    func closeLogView() {
        logViewHeight.constant = self.topOffset
        UIView.animate(withDuration: 0.5) { [unowned self] in self.view.layoutIfNeeded() }
    }
}

extension InterstitialViewController: YMAInterstitialAdDelegate {
    func interstitialAdDidLoad(_ interstitialAd: YMAInterstitialAd) {
        showButton.isEnabled = true
        logView.logEvent("Ad loaded")
    }

    func interstitialAdDidFail(toLoad interstitialAd: YMAInterstitialAd, error: Error) {
        logView.logEvent("Loading failed. Error: \(error)")
    }

    func interstitialAdDidClick(_ interstitialAd: YMAInterstitialAd) {
        logView.logEvent("Ad clicked")
    }

    func interstitialAd(_ interstitialAd: YMAInterstitialAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        logView.logEvent("Impression tracked")
    }

    func interstitialAdWillLeaveApplication(_ interstitialAd: YMAInterstitialAd) {
        logView.logEvent("Will leave application")
    }

    func interstitialAdDidFail(toPresent interstitialAd: YMAInterstitialAd, error: Error) {
        showButton.isEnabled = true
        logView.logEvent("Failed to present interstitial. Error: \(error)")
    }

    func interstitialAdWillAppear(_ interstitialAd: YMAInterstitialAd) {
        logView.logEvent("Interstitial ad will appear")
    }

    func interstitialAdDidAppear(_ interstitialAd: YMAInterstitialAd) {
        logView.logEvent("Interstitial ad did appear")
    }

    func interstitialAdWillDisappear(_ interstitialAd: YMAInterstitialAd) {
        logView.logEvent("Interstitial ad will disappear")
    }

    func interstitialAdDidDisappear(_ interstitialAd: YMAInterstitialAd) {
        logView.logEvent("Interstitial ad did disappear")
    }

    func interstitialAd(_ interstitialAd: YMAInterstitialAd, willPresentScreen webBrowser: UIViewController?) {
        logView.logEvent("Interstitial ad will present screen")
    }
}
