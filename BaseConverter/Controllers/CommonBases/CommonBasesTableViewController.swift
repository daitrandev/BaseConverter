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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(
            UINib(
                nibName: String(describing: CommonBasesTableViewCell.self),
                bundle: .main
            ),
            forCellReuseIdentifier: cellId
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let viewModel: CommonBasesViewModelType
    private var bannerView: GADBannerView?
    private var interstitial: GADInterstitial?
    
    init() {
        viewModel = CommonBasesViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.addSubview(tableView)
        
        setupTableView()
        setupColor()
        
        viewModel.delegate = self
        
        tabBarController?.tabBar.isTranslucent = false
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "refresh"), style: .plain, target: self, action: #selector(refreshButtonAction))
        self.title = "Common Bases"
    }
    
    @objc func refreshButtonAction() {
        viewModel.clear(exclusive: nil)
    }
    
    func setupTableView() {
        tableView.constraintTo(top: view.layoutMarginsGuide.topAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
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
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: {(action) in
            self.setNeedsStatusBarAppearanceUpdate()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupColor()
    }
}

extension CommonBasesTableViewController: CommonBasesViewModelDelegate {
    @objc func reloadTableView() {
        for cell in tableView.visibleCells {
            guard let indexPath = tableView.indexPath(for: cell) else { continue }
            let cell = cell as? CommonBasesTableViewCell
            cell?.configure(with: viewModel.cellLayoutItems[indexPath.row])
        }
    }
}

extension CommonBasesTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellLayoutItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommonBasesTableViewCell
        cell.configure(with: viewModel.cellLayoutItems[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension CommonBasesTableViewController: CommonTableViewCellDelegate {
    @objc func didChange(value: String, from baseValue: Int) {
        viewModel.didChange(value: value, from: baseValue)
    }
    
    func presentCopiedAlert(message: String) {
        self.presentAlert(title: message, message: "")
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
        
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        ad.present(fromRootViewController: self)
    }
}
