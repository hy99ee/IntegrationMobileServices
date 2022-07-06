import UIKit
import YandexMobileAds

protocol LogViewControllerDelegate: AnyObject {
    var topOffset: CGFloat { set get }

    func initLogView()
    func openLogView()
    func closeLogView()
}

class BannerViewController: UIViewController {
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!

    private var logView = LogView()
    private lazy var logViewHeight = self.logView.heightAnchor.constraint(equalToConstant: 0)
    private lazy var buttonsY = self.loadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    private var _logViewOffset: CGFloat = 0
    
    var adView: YMAAdView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let adSize = YMAAdSize.fixedSize(with: .init(width: 320, height: 50))
        self.adView = YMAAdView(blockID: "R-M-DEMO-320x50", adSize: adSize)
        self.adView.delegate = self


        logView.viewControllerDelegate = self
        do {
            logView.configured(with: try LogStore.shared.data(self))
        } catch {
            print(String.logDataErrorString(self))
        }

        logView.translatesAutoresizingMaskIntoConstraints = false
        buttonsY.isActive = true
    }
    
    @IBAction func load(_ sender: Any) {
        loadButton.isEnabled = false
        self.adView.removeFromSuperview()
        self.adView.loadAd()
    }
    @IBAction func show(_ sender: Any) {
        self.adView.displayAtTop(in: self.view)
        loadButton.isEnabled = true
        showButton.isEnabled = false
    }
}

extension BannerViewController: LogViewControllerDelegate {
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
        logViewHeight.constant = topOffset
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


extension BannerViewController: YMAAdViewDelegate {
    func adViewDidLoad(_ adView: YMAAdView) {
        showButton.isEnabled = true
        logView.logEvent("Ad loaded")
    }

    func adViewDidClick(_ adView: YMAAdView) {
        logView.logEvent("Ad clicked")
    }

    func adView(_ adView: YMAAdView, didTrackImpressionWith impressionData: YMAImpressionData?) {
        logView.logEvent("Impression tracked")
    }
    
    func adViewDidFailLoading(_ adView: YMAAdView, error: Error) {
        showButton.isEnabled = true
        logView.logEvent("Ad failed loading. Error: \(error)")
    }
    
    func adViewWillLeaveApplication(_ adView: YMAAdView) {
        logView.logEvent("Ad will leave application")
    }
    
    func adView(_ adView: YMAAdView, willPresentScreen viewController: UIViewController?) {
        logView.logEvent("Ad will present screen")
    }

    func adView(_ adView: YMAAdView, didDismissScreen viewController: UIViewController?) {
        logView.logEvent("Ad did dismiss screen")
    }
    
}

private extension BannerViewController {
    func setCloseButtonsPosition() {
        UIView.animate(withDuration: 0.5) { [weak self] in self?.buttonsY.constant = 0 }
    }

    func setOpenButtonsPosition() {
        UIView.animate(withDuration: 0.5) { [weak self] in self?.buttonsY.constant = -250 }
    }
}
