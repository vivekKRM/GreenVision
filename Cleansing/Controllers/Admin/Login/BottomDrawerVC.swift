//
//  BottomDrawerVC.swift
//  Cleansing
//
//  Created by United It Services on 14/09/23.
//

import UIKit

class BottomDrawerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    override func viewDidLayoutSubviews() {
                super.viewDidLayoutSubviews()
                
                if #available(iOS 15.0, *) {
                    
                } else {
                    // Below iOS 15, change frame here
//                    self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 0.4, width: self.view.bounds.width, height: 320)
//                    self.view.layer.cornerRadius = 20
//                    self.view.layer.masksToBounds = true
                }
            }

}
