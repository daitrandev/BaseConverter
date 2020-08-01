//
//  ViewController.swift
//  BaseConverter
//
//  Created by Dai Tran on 4/20/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CommonBasesTableViewController: UIViewController {

    let cellId = "cellId"
    
    var bases = [Base(baseLabelText: "BIN", baseTextFieldTag: 0, baseTextFieldText: nil),
                 Base(baseLabelText: "OCT", baseTextFieldTag: 1, baseTextFieldText: nil),
                 Base(baseLabelText: "DEC", baseTextFieldTag: 2, baseTextFieldText: nil),
                 Base(baseLabelText: "HEX", baseTextFieldTag: 3, baseTextFieldText: nil)]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(CommonBasesTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
        
    private var bannerView: GADBannerView?
    
    private var interstitial: GADInterstitial?
    
    override func viewDidLoad() {
        view.addSubview(tableView)
        
        setupAds()
        setupTableView()
        setupColor()
        
        tabBarController?.tabBar.isTranslucent = false
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: self, action: #selector(refreshButtonAction))
        self.title = NSLocalizedString("CommonBases", comment: "")
    }
    
    @objc func refreshButtonAction() {
        for i in 0..<bases.count {
            bases[i].baseTextFieldText = nil
        }
        guard let visibleCells = tableView.visibleCells as? [CommonBasesTableViewCell] else { return }
        for i in 0..<visibleCells.count {
            let index = visibleCells[i].tag
            visibleCells[i].base = bases[index]
        }
    }
    
    func setupTableView() {
        tableView.constraintTo(top: view.layoutMarginsGuide.topAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
    }
    
    private func setupColor() {
        if #available(iOS 13, *) {
            tabBarController?.tabBar.tintColor = traitCollection.userInterfaceStyle.themeColor
            tabBarController?.tabBar.barTintColor = .secondarySystemBackground
            navigationController?.navigationBar.barTintColor = .secondarySystemBackground
            navigationController?.navigationBar.tintColor = traitCollection.userInterfaceStyle.themeColor
        } else {
            tabBarController?.tabBar.tintColor = .deepBlue
            tabBarController?.tabBar.barTintColor = .white
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.tintColor = .deepBlue
        }
    }
    
    private func setupAds() {
        bannerView = createAndLoadBannerView()
        interstitial = createAndLoadInterstitial()
    }
    
    func presentAlert(title: String, message: String, isUpgradeMessage: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: .cancel, handler: {(action) in
            self.setNeedsStatusBarAppearanceUpdate()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupColor()
    }
}

extension CommonBasesTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommonBasesTableViewCell
        cell.base = bases[indexPath.row]
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

extension CommonBasesTableViewController: CommonTableViewCellDelegate {
    func presentCopiedAlert(message: String) {
        self.presentAlert(title: message, message: "", isUpgradeMessage: false)
    }
    
    func updateAllBases(bases: [Base], excepted tag: Int) {
        self.bases = bases
        guard let visibleCells = tableView.visibleCells as? [CommonBasesTableViewCell] else { return }
        for i in 0..<visibleCells.count {
            if i == tag {
                continue
            }
            let index = visibleCells[i].tag
            visibleCells[i].base = bases[index]
        }
    }
}

extension CommonBasesTableViewController : GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            self.tableView.tableHeaderView?.frame = bannerView.frame
            bannerView.transform = CGAffineTransform.identity
            self.tableView.tableHeaderView = bannerView
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
}

extension CommonBasesTableViewController : GADInterstitialDelegate {
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: interstialAdsUnitID)
        
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self
        
        return interstitial
    }
    
    private func createAndLoadBannerView() -> GADBannerView? {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        guard let bannerView = bannerView else {
            return nil
        }
        bannerView.adUnitID = bannerAdsUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        return bannerView
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        presentAlert(title: NSLocalizedString("Appname", comment: ""), message: NSLocalizedString("UpgradeMessage", comment: ""), isUpgradeMessage: true)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        presentAlert(title: NSLocalizedString("Appname", comment: ""), message: NSLocalizedString("UpgradeMessage", comment: ""), isUpgradeMessage: true)
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        ad.present(fromRootViewController: self)
    }
}
