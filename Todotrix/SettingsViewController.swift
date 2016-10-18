//
//  SettingsViewController.swift
//  Todotrix
//
//  Created by leo on 16/7/5.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit
import VBFPopFlatButton

class SettingsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let closeButton = VBFPopFlatButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22), buttonType: FlatButtonType.buttonCloseType, buttonStyle: FlatButtonStyle.buttonPlainStyle, animateToInitialState: false)
        closeButton?.lineRadius = 1
        closeButton?.addTarget(self, action: #selector(SettingsViewController.closeButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton!)

    }
    
    func closeButtonPressed(_ button: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 0 {
            guard let url = URL(string:"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=939523047&onlyLatestVersion=true&type=Purple+Software") else {
                return
            }
            UIApplication.shared.openURL(url);
        }
        else if ((indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 1) {
            guard let url = URL(string:"mailto:yucong1118@gmail.com") else {
                return
            }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

}
