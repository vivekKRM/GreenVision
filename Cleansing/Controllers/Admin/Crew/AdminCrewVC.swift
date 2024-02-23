//
//  AdminCrewVC.swift
//  Cleansing
//
//  Created by UIS on 08/11/23.
//

import UIKit
import Alamofire
class AdminCrewVC: UIViewController {

    
    @IBOutlet weak var crewTV: UITableView!
    @IBOutlet weak var topLabel: UILabel!
    
    var status: Int = 0
    var crewList = [crewListing]()
    var registerList = [registerListing]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

  

}
//MARK: First Call
extension AdminCrewVC{
    
    func firstCall()
    {
        self.title = "Crew".localizeString(string: lang)
        self.topLabel.text = "Crew Listing".localizeString(string: lang)
        UserDefaults.standard.set("", forKey: "dfilter")
        UserDefaults.standard.setValue( "", forKey: "workerT")
        UserDefaults.standard.setValue( "all", forKey: "statusT")
        UserDefaults.standard.setValue("", forKey: "workerV")
        UserDefaults.standard.setValue("", forKey: "statusV")
        UserDefaults.standard.setValue("", forKey: "approverV")
        UserDefaults.standard.setValue("", forKey: "approverT")
        floatingBtn()
        getInvite()
    }
    
    @objc func inviteBtnTap(){
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdminInviteVC") as? AdminInviteVC{
            VC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    //MARK: Add Floating Button
    func floatingBtn(){
        let floatingButton = UIButton(type: .system)
        floatingButton.frame = CGRect(x: UIScreen.main.bounds.width * 0.8, y: UIScreen.main.bounds.height * 0.8, width: 60, height: 60)
        floatingButton.backgroundColor =  UIColor.init(hexString: "5FB8EE")
        floatingButton.layer.cornerRadius = 30 // Half of the width
        floatingButton.setTitle("+", for: .normal)
        floatingButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        floatingButton.setTitleColor(UIColor.black, for: .normal)
        // Add a tap action to the button
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        // Add the floating button to the view
        view.addSubview(floatingButton)
    }
    
    @objc func floatingButtonTapped() {
        // Handle the button tap action
        print("Floating button tapped!")
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdminInviteVC") as? AdminInviteVC{
            VC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
}

//MARK: TableView Delegate
extension AdminCrewVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return registerList.count
        }else{
            return crewList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "acCell", for: indexPath) as! AdminCrewTVC
        if indexPath.section == 0{
            cell.nameLabel.text = registerList[indexPath.row].name
            cell.emailLabel.text = registerList[indexPath.row].email
            cell.mobileLabel.text = registerList[indexPath.row].mobile
            cell.activeView.isHidden = true
        }else{
            cell.activeView.isHidden = false
            cell.nameLabel.text = crewList[indexPath.row].name
            cell.emailLabel.text = crewList[indexPath.row].email
            cell.mobileLabel.text = crewList[indexPath.row].phone
            if crewList[indexPath.row].status == "1"{
                cell.activeLabel.text = "Active".localizeString(string: lang)
            }else{
                cell.activeLabel.text = "InActive".localizeString(string: lang)
            }
            
        }
//        cell.selectBtn.tag = indexPath.section * 1000 + indexPath.row
//        cell.selectBtn.addTarget(self, action: #selector(editBtnTap(_:)), for: .touchUpInside)
       
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
        viewHeader.backgroundColor = UIColor.init(hexString: "f5f5f5")
        if section == 0{
            let label1 = UILabel(frame: CGRect(x: 15, y: 10, width: 150, height: 24))
            label1.text = "Invited Crew".localizeString(string: lang)
            label1.textColor = .black
            label1.font = UIFont(name: "Poppins-Medium", size: 16)
            viewHeader.addSubview(label1)
        }else{
            let label1 = UILabel(frame: CGRect(x: 15, y: 10, width: 300, height: 24))
            label1.text = "Active/In-Active Crew".localizeString(string: lang)
            label1.textColor = .black
            label1.font = UIFont(name: "Poppins-Medium", size: 16)
            viewHeader.addSubview(label1)
        }
        return viewHeader
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    @objc func editBtnTap(_ sender: UIButton){
        let tag = sender.tag
        // Extract section and row from the tag
            let section = tag / 1000
            let row = tag % 1000
            
            // Now you have both section and row
            print("Section: \(section), Row: \(row)")
        //To be uncommented on 30 Nov
//        if section == 0 {
//                clockedInData[row].isSelected.toggle()
//                clockedOutData[row].isSelected = false
//            } else {
//                clockedOutData[row].isSelected.toggle()
//                clockedInData[row].isSelected = false
//            }
//        
//        crewTV.reloadRows(at: [IndexPath(row: row, section: section)], with: .none)
    }
    
}
//MARK: API Integartion
extension AdminCrewVC{

    //MARK: Get Invite API
    func getInvite()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/get_activeInactive_user"
        print(param)
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        print("Access Token: \(accessToken)")
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["Authorization": "Bearer "+accessToken+""])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                    
                case .success(let value):
                    let dict = value as! [String:Any]
                    self.status = dict["status"] as! Int
                    if self.status == 200
                    {
                        if let jsonData = try? JSONSerialization.data(withJSONObject: value),
                           let loginResponse = try? JSONDecoder().decode(EmployeeResponse.self, from: jsonData) {
                           
                            self.crewList.removeAll()
                            for i in 0..<loginResponse.emp_data.count{
                                self.crewList.append(crewListing.init(email: loginResponse.emp_data[i].email, name: loginResponse.emp_data[i].name, phone: loginResponse.emp_data[i].phone, profile_image: loginResponse.emp_data[i].profile_image, status: loginResponse.emp_data[i].status))
                            }
                            
                            self.registerList.removeAll()
                            for i in 0..<loginResponse.invite_data.count{
                                self.registerList.append(registerListing.init(role: loginResponse.invite_data[i].role, name: loginResponse.invite_data[i].name, email: loginResponse.invite_data[i].email, mobile: loginResponse.invite_data[i].mobile, status: loginResponse.invite_data[i].status, time_tracking: loginResponse.invite_data[i].time_tracking, time_approver: loginResponse.invite_data[i].time_approver, overtime_status: loginResponse.invite_data[i].overtime_status, mealbreak_policy: loginResponse.invite_data[i].mealbreak_policy))
                            }
                            
                            progressHUD.hide()
                            DispatchQueue.main.async {
                                self.crewTV.delegate = self
                                self.crewTV.dataSource = self
                                self.crewTV.reloadData()
                            }
                        } else {
                            print("Error decoding JSON")
                            _ = SweetAlert().showAlert("", subTitle: "Error Decoding".localizeString(string: lang), style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
                            progressHUD.hide()
                        }
                        
                    }else if self.status == 502{
                        progressHUD.hide()
                        if let appDomain = Bundle.main.bundleIdentifier {
                            UserDefaults.standard.removePersistentDomain(forName: appDomain)
                        }
                        NotificationCenter.default.removeObserver(self)
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang)){ (isOtherButton) -> Void in
                            if isOtherButton == true {
                                ksceneDelegate?.logout()
                            }
                        }
                    }else if self.status == 202{
                        progressHUD.hide()
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
                    }else if self.status == 201{
                        progressHUD.hide()
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
                    }else{
                        progressHUD.hide()
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
                    }
                    
                    
                case .failure(_):
                    progressHUD.hide()
                    if let response = response.data{
                        var JSON: [String: Any]?
                        do {
                            JSON = try (JSONSerialization.jsonObject(with: response, options: []) as? [String: Any])!
                            if let code = JSON?["code"] as? Int {
                                print(code)
                            }
                            if let message = JSON?["message"] as? String {
                                print(message)
                                _ = SweetAlert().showAlert("Failure".localizeString(string: lang), subTitle:  message, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
                            }
                        } catch {
                            // Your handling code
                            _ = SweetAlert().showAlert("Oops..".localizeString(string: lang), subTitle:  "Something went wrong".localizeString(string: lang), style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
                            
                        }
                    }
                }
            }
    }
    
    
}
