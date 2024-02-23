//
//  LogsVC.swift
//  Cleansing
//
//  Created by UIS on 02/11/23.
//

import UIKit

class LogsVC: UIViewController {

    @IBOutlet weak var alertLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        alertLabel.text = ""//"Features Coming  Soon...".localizeString(string: lang)
    }
    

   

}
