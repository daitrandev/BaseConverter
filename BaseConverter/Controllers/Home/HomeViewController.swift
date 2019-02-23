//
//  HomeViewController.swift
//  BaseConverter
//
//  Created by Dai Tran on 4/23/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit
import MessageUI
import GoogleMobileAds

protocol HomeViewControllerDelegate: class {
    func loadThemeAndUpdateFormat()
    func showUpgradeAlert()
}

class HomeViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
        
    var bannerView: GADBannerView?
    
    var isLightTheme = UserDefaults.standard.bool(forKey: isLightThemeKey)
    
    var isFreeVersion = Bundle.main.infoDictionary?["isFreeVersion"] as? Bool ?? true

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isLightTheme ? .default : .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAds()
        setupViews()
    }
    
    func setupViews() {
        navigationItem.title = NSLocalizedString("Home", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .done, target: self, action: #selector(closedButtonAction))
    }
    
    func setupAds() {
        if isFreeVersion {
            bannerView = createAndLoadBannerView()
        }
    }
    
    @objc func closedButtonAction() {
        delegate?.loadThemeAndUpdateFormat()
        dismiss(animated: true) {
            if self.isFreeVersion {
                self.delegate?.showUpgradeAlert()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTheme()
    }
    
    
    func loadTheme() {
        isLightTheme = UserDefaults.standard.bool(forKey: isLightThemeKey)
        
        navigationController?.navigationBar.tintColor = isLightTheme ? UIColor.deepBlue : UIColor.orange
        
        navigationController?.navigationBar.barTintColor = isLightTheme ? UIColor.white : UIColor.black
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: isLightTheme ? UIColor.black : UIColor.white]
        
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension HomeViewController:  MFMailComposeViewControllerDelegate {
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["universappteam@gmail.com"])
        mailComposerVC.setSubject("[Base-Converter++ Feedback]")
        
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension HomeViewController : GADBannerViewDelegate {
    
    private func createAndLoadBannerView() -> GADBannerView? {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        guard let bannerView = bannerView else {
            return nil
        }
        bannerView.adUnitID = "ca-app-pub-7005013141953077/4204266995"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        return bannerView
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerViewToView(bannerView)
        
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}