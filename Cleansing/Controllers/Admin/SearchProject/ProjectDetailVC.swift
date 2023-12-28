//
//  ProjectDetailVC.swift
//  Cleansing
//
//  Created by United It Services on 01/09/23.
//

import UIKit

class ProjectDetailVC: UIViewController {
    
    @IBOutlet weak var workerName: UILabel!
    @IBOutlet weak var workerImage: UIImageView!
    @IBOutlet weak var projectProgress: PaddingLabel!
    @IBOutlet weak var progressTime: UILabel!
    @IBOutlet weak var projectDetailTV: UITableView!
    

    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var breakDuration: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var notes: UILabel!
   
    var Projectdetails = [projectDetails]()
    override func viewDidLoad() {
        super.viewDidLoad()
        firstCall()
        
    }
    
    
    @IBAction func showMapBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GooglePathVC") as? GooglePathVC{
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
}

extension ProjectDetailVC{
    
    func firstCall()
    {
        self.title = "Project Details"
        projectProgress.textAlignment = .center
        projectProgress.layer.cornerRadius = 10
        projectProgress.layer.masksToBounds = true
        projectProgress.edgeInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
}
