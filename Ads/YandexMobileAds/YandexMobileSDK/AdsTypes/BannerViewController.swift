//
//  ViewController.swift
//  YandexMobileAds
//
//  Created by hy99ee on 29.06.2022.
//

import UIKit
import YandexMobileAds

class BannerViewController: UIViewController {
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
    private let logView = LogView().configured()
    private lazy var logViewHeight = self.logView.heightAnchor.constraint(equalToConstant: 0)

    @IBAction func actionOpenLog(_ sender: Any) {
        if !view.subviews.contains(logView) { addLogView() }
        logViewHeight.constant = 300
        UIView.animate(withDuration: 0.7) { [unowned self] in self.view.layoutIfNeeded() }
    }

    @IBAction func toUpGestureAction(_ sender: UIPanGestureRecognizer) {
        if !view.subviews.contains(logView) { addLogView() }
        logViewHeight.constant = 500
        UIView.animate(withDuration: 0.7) { [unowned self] in self.view.layoutIfNeeded() }
    }
    
    var adView: YMAAdView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let adSize = YMAAdSize.fixedSize(with: .init(width: 320, height: 50))
        self.adView = YMAAdView(blockID: "R-M-DEMO-320x50", adSize: adSize)
        self.adView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
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
    
    private func addLogView() {
        view.addSubview(logView)
        logView.translatesAutoresizingMaskIntoConstraints = false
        logView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        logView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        logView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        logViewHeight.isActive = true
        
        self.view.layoutIfNeeded()
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
