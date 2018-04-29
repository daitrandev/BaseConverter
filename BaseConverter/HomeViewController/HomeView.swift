//
//  HomeView.swift
//  BaseConverter
//
//  Created by Dai Tran on 4/23/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit
import MessageUI

protocol HomeViewDelegate: class {
    func pushViewController(viewController: UIViewController)
    func presentMailComposeViewController()
    func presentRatingAction()
    func presentShareAction()
}

class HomeView: UIView, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    
    weak var delegate: HomeViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("I'm here")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func onSettingsAction(_ sender: UIButton) {
        let settingViewController = SettingViewController()
        delegate?.pushViewController(viewController: settingViewController)
        
    }
    
    @IBAction func onFeedBackAction(_ sender: UIButton) {
        delegate?.presentMailComposeViewController()
    }
    
    @IBAction func onRatingAction(_ sender: UIButton) {
        delegate?.presentRatingAction()
    }
    
    @IBAction func onSharingAction(_ sender: UIButton) {
        delegate?.presentShareAction()
    }
    
    func updateLabelText() {
        settingLabel.adjustsFontSizeToFitWidth = true
        feedbackLabel.adjustsFontSizeToFitWidth = true
        rateLabel.adjustsFontSizeToFitWidth = true
        shareLabel.adjustsFontSizeToFitWidth = true
        
        settingLabel.text = NSLocalizedString("Settings", comment: "")
        feedbackLabel.text = NSLocalizedString("Feedback", comment: "")
        rateLabel.text = NSLocalizedString("Rate", comment: "")
        shareLabel.text = NSLocalizedString("Share", comment: "")
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Home", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}

extension HomeView {
    func loadTheme() {
        let isLightTheme = UserDefaults.standard.bool(forKey: isLightThemeKey)
        backgroundColor = isLightTheme ? UIColor.white : UIColor.black
        let labelArray = [settingLabel, feedbackLabel, rateLabel, shareLabel]
        
        if isLightTheme {
            settingButton.setImage(#imageLiteral(resourceName: "settings-blue"), for: .normal)
            feedbackButton.setImage(#imageLiteral(resourceName: "feedback-blue"), for: .normal)
            rateButton.setImage(#imageLiteral(resourceName: "rate-blue"), for: .normal)
            shareButton.setImage(#imageLiteral(resourceName: "share-blue"), for: .normal)
            
        } else {            
            settingButton.setImage(#imageLiteral(resourceName: "settings-orange"), for: .normal)
            feedbackButton.setImage(#imageLiteral(resourceName: "feedback-orange"), for: .normal)
            rateButton.setImage(#imageLiteral(resourceName: "rate-orange"), for: .normal)
            shareButton.setImage(#imageLiteral(resourceName: "share-orange"), for: .normal)
            
        }
        
        for i in 0..<labelArray.count {
            labelArray[i]?.textColor = isLightTheme ? UIColor.black : UIColor.white
        }
        
    }
}
