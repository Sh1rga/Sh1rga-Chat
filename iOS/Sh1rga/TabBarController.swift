//
//  TabBarController.swift
//  Sh1rga
//
//  Created by tsg0o0 on 2022/07/19.
//
import UIKit

import Foundation

class TabBarController: UITabBarController {
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    weak var viewController: ViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.title {
        case "Chat":
            self.viewControllers?[0].tabBarItem.badgeValue = nil
            appDelegate.selectedTabBar = "Chat"
        case "Settings":
            appDelegate.selectedTabBar = "Settings"
        default:
            appDelegate.selectedTabBar = nil
        }
    }
    
    override var shouldAutorotate: Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return false
        } else {
            return true
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
