//
//  CleansingTBC.swift
//  surfers
//
//  Created by United It Services on 21/08/23.
//

import UIKit

class CleansingTBC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarAppearance = tabBar.standardAppearance
        tabBarAppearance.selectionIndicatorTintColor =  UIColor.init(hexString: "004080")
        tabBar.standardAppearance = tabBarAppearance
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let yourView = self.viewControllers![self.selectedIndex] as! UINavigationController
        yourView.popToRootViewController(animated: false)
    }

}
