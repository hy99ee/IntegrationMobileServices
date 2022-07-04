//
//  ViewController.swift
//  YandexMobileAds
//
//  Created by hy99ee on 29.06.2022.
//

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
    private var _logViewOffset: CGFloat = 0
    
    var adView: YMAAdView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logView.viewControllerDelegate = self
        logView.configured()
        
        let adSize = YMAAdSize.fixedSize(with: .init(width: 320, height: 50))
        self.adView = YMAAdView(blockID: "R-M-DEMO-320x50", adSize: adSize)
        self.adView.delegate = self
        
        
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
        showButton.isEnabled = true
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
