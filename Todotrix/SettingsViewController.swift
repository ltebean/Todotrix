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
        let closeButton = VBFPopFlatButton(frame: CGRectMake(0, 0, 22, 22), buttonType: FlatButtonType.buttonCloseType, buttonStyle: FlatButtonStyle.buttonPlainStyle, animateToInitialState: false)
        closeButton.lineRadius = 1
        closeButton.addTarget(self, action: #selector(SettingsViewController.closeButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)

    }
    
    func closeButtonPressed(button: UIButton) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            guard let url = NSURL(string:"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=939523047&onlyLatestVersion=true&type=Purple+Software") else {
                return
            }
            UIApplication.sharedApplication().openURL(url);
        }
        else if (indexPath.section == 0 && indexPath.row == 1) {
            guard let url = NSURL(string:"mailto:yucong1118@gmail.com") else {
                return
            }
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}
