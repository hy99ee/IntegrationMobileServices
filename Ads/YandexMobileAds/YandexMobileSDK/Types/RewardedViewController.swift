import UIKit
import YandexMobileAds

class RewardedViewController: UIViewController {
    
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    private var rewardedAd: YMARewardedAd?
    
    private var logView = LogView()
    private lazy var logViewHeight = self.logView.heightAnchor.constraint(equalToConstant: 0)
    private lazy var buttonsY = self.loadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    private var _logViewOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

        self.rewardedAd = YMARewardedAd(blockID: "R-M-DEMO-rewarded-client-side-rtb")
        self.rewardedAd?.delegate = self
        self.rewardedAd?.load()
    }
    
    @IBAction func show() {
        self.rewardedAd?.present(from: self) {[weak self] in
            self?.showButton.isEnabled = false
            self?.loadButton.isEnabled = true
        }
        
    }

}

extension RewardedViewController: LogViewControllerDelegate {
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


extension RewardedViewController: YMARewardedAdDelegate {
    func rewardedAd(_ rewardedAd: YMARewardedAd, didReward reward: YMAReward) {
        
        let message = "Rewarded ad did reward: \(reward.adReward.amount) \(reward.adReward.name)"
        let alertController = UIAlertController(title: "Reward", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        self.presentedViewController?.present(alertController, animated: true, completion: nil)
        print(message)
    }
    
    func rewardedAdDidLoad(_ rewardedAd: YMARewardedAd) {
        self.showButton.isEnabled = true
        logView.logEvent("Rewarded ad loaded")
    }
    
    func rewardedAdDidFail(toLoad rewardedAd: YMARewardedAd, error: Error) {
        logView.logEvent("Loading failed. Error: \(error)")
    }

    func rewardedAdDidClick(_ rewardedAd: YMARewardedAd) {
        logView.logEvent("Ad clicked")
    }

    func rewardedAd(_ rewardedAd: YMARewardedAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        logView.logEvent("Impression tracked")
    }
    
    func rewardedAdWillLeaveApplication(_ rewardedAd: YMARewardedAd) {
        logView.logEvent("Rewarded ad will leave application")
    }
    
    func rewardedAdDidFail(toPresent rewardedAd: YMARewardedAd, error: Error) {
        logView.logEvent(String("Failed to present rewarded ad. Error: \(error)"))
    }
    
    func rewardedAdWillAppear(_ rewardedAd: YMARewardedAd) {
        logView.logEvent("Rewarded ad will appear")
    }

    func rewardedAdDidAppear(_ rewardedAd: YMARewardedAd) {
        logView.logEvent("Rewarded ad did appear")
    }
    
    func rewardedAdWillDisappear(_ rewardedAd: YMARewardedAd) {
        logView.logEvent("Rewarded ad will disappear")
    }

    func rewardedAdDidDisappear(_ rewardedAd: YMARewardedAd) {
        logView.logEvent("Rewarded ad did disappear")
    }
    
    func rewardedAd(_ rewardedAd: YMARewardedAd, willPresentScreen viewController: UIViewController?) {
        logView.logEvent("Rewarded ad will present screen")
    }
}

private extension RewardedViewController {
    func setCloseButtonsPosition() {
        UIView.animate(withDuration: 0.5) { [weak self] in self?.buttonsY.constant = 0 }
    }

    func setOpenButtonsPosition() {
        UIView.animate(withDuration: 0.5) { [weak self] in self?.buttonsY.constant = -250 }
    }
}

class AdReward: NSObject {
    let name: String
    let amount: Double

    init(name: String, amount: Double) {
        self.name = name
        self.amount = amount
    }
}


// MARK: AdReward
private extension YMAReward {
    var adReward: AdReward { AdReward(name: "coins", amount: Double(self.amount)) }
}


