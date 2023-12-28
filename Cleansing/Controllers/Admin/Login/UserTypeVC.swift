//
//  UserTypeVC.swift
//  surfers
//
//  Created by United It Services on 18/08/23.
//

import UIKit

class UserTypeVC: UIViewController {
    
    
    @IBOutlet weak var coachBtn: GradientButton!
    @IBOutlet weak var surferBtn: GradientButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        coachBtn.roundedButton()
        surferBtn.roundedButton()
        
        coachBtn.startColor = UIColor(hexString: "6616d44b")
        coachBtn.endColor = UIColor(hexString: "12c201")
        
        surferBtn.startColor = UIColor(hexString: "0088cc")
        surferBtn.endColor = UIColor(hexString: "5fb8ee")
        
    }
    
    @IBAction func coachBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC{
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    
    
    @IBAction func surferBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC{
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    
    
}
