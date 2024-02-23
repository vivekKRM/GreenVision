//
//  SplashVC.swift
//  surfers
//
//  Created by United It Services on 18/08/23.
//

import UIKit

class SplashVC: UIViewController {
    
    @IBOutlet weak var splashImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        splashImageView.image = UIImage(named: "splash")
        UIView.animate(withDuration: 0 , animations: {
            let signed = UserDefaults.standard.bool(forKey: "signed")
            if signed
            {
                if UserDefaults.standard.string(forKey: "userType") == "Worker"{
                    let obj = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "WorkerTBC") as! WorkerTBC
                    ksceneDelegate!.window?.rootViewController = obj
                    ksceneDelegate!.window?.makeKeyAndVisible()
                }else{
                    let obj = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "CleansingTBC") as! CleansingTBC
                    ksceneDelegate!.window?.rootViewController = obj
                    ksceneDelegate!.window?.makeKeyAndVisible()
                }
            }else{
                if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LanguageVC") as? LanguageVC{
                    self.navigationController?.pushViewController(VC, animated: true)
                }
            }
        })
        
    }
    
}
