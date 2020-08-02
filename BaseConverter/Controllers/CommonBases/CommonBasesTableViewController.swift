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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAdsViews()
    }
    
    override func viewDidLoad() {
        view.addSubview(tableView)
        
        setupTableView()
        setupColor()
        
        viewModel.delegate = self
        
        tabBarController?.tabBar.isTranslucent = false
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "refresh"),
            style: .plain,
            target: self,
            action: #selector(didTapClear)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "unlock"),
            style: .plain,
            target: self,
            action: #selector(didTapUnlock)
        )
        
        title = "Common Bases"
    }
    
    @objc func didTapClear() {
        viewModel.clear(exclusive: nil)
    }
    
    private func setupTableView() {
        tableView.constraintTo(
            top: view.layoutMarginsGuide.topAnchor,
            bottom: view.layoutMarginsGuide.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor
        )
    }
    
    private func setupAdsViews() {
        if viewModel.isPurchased {
            removeAds()
            return
        }
        
        if bannerView == nil && interstitial == nil {
            bannerView = createAndLoadBannerView()
            interstitial = createAndLoadInterstitial()
        }
    }
    
    @objc private func didTapUnlock() {
        tabBarController?.tabBar.layer.zPosition = -1
        
        let vc = PurchasingPopupViewController()
        vc.delegate = self
        present(vc, animated: true)
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

extension CommonBasesTableViewController: PurchasingPopupViewControllerDelegate {
    func removeAds() {
        showTabbar()
        
        bannerView?.removeFromSuperview()
        tableView.tableHeaderView = nil
        navigationItem.leftBarButtonItem = nil
    }
    
    func showTabbar() {
        tabBarController?.tabBar.layer.zPosition = 0
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension CommonBasesTableViewController: CommonTableViewCellDelegate {
    @objc func didChange(value: String, from baseValue: Int) {
        viewModel.didChange(value: value, from: baseValue)
    }
    
    func presentCopiedAlert(message: String) {
        self.presentAlert(title: "Success", message: message)
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
        let interstitial = GADInterstitial(adUnitID: interstialAdsUnitID)
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self
        
        return interstitial
    }
    
    private func createAndLoadBannerView() -> GADBannerView? {
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = bannerAdsUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        return bannerView
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        ad.present(fromRootViewController: self)
    }
}
