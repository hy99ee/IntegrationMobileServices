import UIKit
import YandexMobileAds

class NativeViewController: UIViewController {
    
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    
    private var adView: YMANativeBannerView?
    private var adLoader: YMANativeAdLoader!
    
    private var logView = LogView()
    private lazy var logViewHeight = self.logView.heightAnchor.constraint(equalToConstant: 0)
    private lazy var buttonsY = self.loadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    private var _logViewOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adView = YMANativeBannerView()
        configureAdView()
        adView?.isHidden = true

        adLoader = YMANativeAdLoader()
        adLoader.delegate = self

        logView.viewControllerDelegate = self
        do {
            logView.configured(with: try LogStore.shared.data(self))
        } catch {
            print(String.logDataErrorString(self))
        }
        
        buttonsY.isActive = true
    }
    
    @IBAction func load() {
        loadButton.isEnabled = false

        adView?.removeFromSuperview()
        let requestConfiguration = YMANativeAdRequestConfiguration(blockID: "R-M-DEMO-native-c")
        adLoader.loadAd(with: requestConfiguration)
    }
    
    @IBAction func show() {
//        self.interstitialAd.present(from: self) {[weak self] in
//            self?.showButton.isEnabled = false
//            self?.loadButton.isEnabled = true
//        }
        configureAdView()
    }
}

extension NativeViewController: YMANativeAdLoaderDelegate {
    func nativeAdLoader(_ loader: YMANativeAdLoader, didLoad ad: YMANativeAd) {
        guard let adView = adView else { return }

        ad.delegate = self
        adView.isHidden = false
        adView.ad = ad
        showButton.isEnabled = true
    }

    func nativeAdLoader(_ loader: YMANativeAdLoader, didFailLoadingWithError error: Error) {
        print("Native ad loading error: \(error)")
        loadButton.isEnabled = true
    }
}


extension NativeViewController: LogViewControllerDelegate {
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
        setOpenButtonsPosition()
        self.view.layoutIfNeeded()
    }
    
    func closeLogView() {
        logViewHeight.constant = topOffset
        setCloseButtonsPosition()
        self.view.layoutIfNeeded()
    }
}

// MARK: - YMANativeAdDelegate

extension NativeViewController: YMANativeAdDelegate {

    func nativeAdDidClick(_ ad: YMANativeAd) {
        logView.logEvent("Ad clicked")
    }

    func nativeAd(_ ad: YMANativeAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        logView.logEvent("Impression tracked")
    }

    func nativeAdWillLeaveApplication(_ ad: YMANativeAd) {
        logView.logEvent("Will leave application")
    }

    func nativeAd(_ ad: YMANativeAd, willPresentScreen viewController: UIViewController?) {
        logView.logEvent("Will present screen")
    }

    func nativeAd(_ ad: YMANativeAd, didDismissScreen viewController: UIViewController?) {
        logView.logEvent("Did dismiss screen")
    }

    func close(_ ad: YMANativeAd) {
        adView?.isHidden = true
    }
}

private extension NativeViewController {
    func configureAdView() {
        guard let adView = adView else { return }

        adView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(adView)
        var layoutGuide = self.view.layoutMarginsGuide
        if #available(iOS 11.0, *) {
            layoutGuide = self.view.safeAreaLayoutGuide
        }
        let constraints = [
            adView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            adView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
            adView.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(constraints)
        
        showButton.isEnabled = false
    }

    func setCloseButtonsPosition() {
        UIView.animate(withDuration: 0.5) { [weak self] in self?.buttonsY.constant = 0 }
    }
    
    func setOpenButtonsPosition() {
        UIView.animate(withDuration: 0.5) { [weak self] in self?.buttonsY.constant = -250 }
    }
}
