//
//  AdminInviteVC.swift
//  Cleansing
//
//  Created by UIS on 16/11/23.
//

import UIKit
import Alamofire
class AdminInviteVC: UIViewController {

    @IBOutlet weak var inviteTV: UITableView!
    @IBOutlet weak var topLabel: UILabel!
    
    
    var status:Int = 0
    var invites: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        firstCall()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: First Call
extension AdminInviteVC {
    
    func firstCall()
    {
        topLabel.text = "Select a role to invite".localizeString(string: lang)
        invites.removeAll()
        invites.append("Track time and location for hourly, salaried or 1099 staff".localizeString(string: lang))
        invites.append("Monitor and approve time and cost codes submitted by your team".localizeString(string: lang))
        invites.append("Manage time, projects, job cost reports and export payroll".localizeString(string: lang))
        self.inviteTV.delegate = self
        self.inviteTV.dataSource = self
        self.inviteTV.reloadData()
    }
}


//MARK: TableView Delegate
extension AdminInviteVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aiCell", for: indexPath) as! AdminInviteTVC
        cell.inviteLabel.text = invites[indexPath.row]
        if indexPath.row == 0{
            cell.topLabel.text = "WORKER".localizeString(string: lang)
        }else if indexPath.row == 1{
            cell.topLabel.text = "MANAGER".localizeString(string: lang)
        }else{
            cell.topLabel.text = "ADMINISTRATOR".localizeString(string: lang)
        }
        cell.inviteBtn.tag = indexPath.row
        cell.inviteBtn.addTarget(self, action: #selector(editBtnTap(_:)), for: .touchUpInside)
       
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
    }
    
    @objc func editBtnTap(_ sender: UIButton){
        let tag = sender.tag
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddInviteVC") as? AddInviteVC{
            VC.hidesBottomBarWhenPushed = true
            VC.selected = tag
            self.navigationController?.pushViewController(VC, animated: true)
        }
      
    }
    
}
