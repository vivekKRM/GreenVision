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
    
    
    var status: Int = 0
    var clockedInData = [crewClockedIn]()
    var clockedOutData = [crewClockedOut]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }

  

}
//MARK: First Call
extension AdminCrewVC{
    
    func firstCall()
    {
        self.title = "Crew"
        let rightBarButton = UIBarButtonItem(title: "+ Invite", style: .plain, target: self, action: #selector(inviteBtnTap))
        navigationItem.rightBarButtonItem = rightBarButton
        getCrew()
    }
    
    @objc func inviteBtnTap(){
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdminInviteVC") as? AdminInviteVC{
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
            return clockedInData.count
        }else{
            return clockedOutData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "acCell", for: indexPath) as! AdminCrewTVC
        if indexPath.section == 0{
            cell.nameLabel.text = clockedInData[indexPath.row].name
            cell.dateLabel.text = clockedInData[indexPath.row].date
            if clockedInData[indexPath.row].isSelected {
                cell.selectBtn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            }else{
                cell.selectBtn.setImage(UIImage(systemName: "square"), for: .normal)
            }
        }else{
            cell.nameLabel.text = clockedOutData[indexPath.row].name
            cell.dateLabel.text = clockedOutData[indexPath.row].date
            if clockedOutData[indexPath.row].isSelected {
                cell.selectBtn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            }else{
                cell.selectBtn.setImage(UIImage(systemName: "square"), for: .normal)
            }
        }
        cell.selectBtn.tag = indexPath.section * 1000 + indexPath.row
        cell.selectBtn.addTarget(self, action: #selector(editBtnTap(_:)), for: .touchUpInside)
       
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
            label1.text = "Clocked-In"
            label1.textColor = .black
            label1.font = UIFont(name: "Poppins-Medium", size: 16)
            viewHeader.addSubview(label1)
        }else{
            let label1 = UILabel(frame: CGRect(x: 15, y: 10, width: 150, height: 24))
            label1.text = "Clocked-Out"
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
    
    //MARK: Get Crew API
    func getCrew()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/get_crew"//get_invite
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
                           let loginResponse = try? JSONDecoder().decode(CrewResponse.self, from: jsonData) {
                            self.clockedInData.removeAll()
                            self.clockedOutData.removeAll()
                            for i in 0..<loginResponse.clockIn.count{
                                self.clockedInData.append(crewClockedIn.init(isSelected: false, name: loginResponse.clockIn[i].name, date: loginResponse.clockIn[i].time, ids: loginResponse.clockIn[i].id))
                            }
                            for i in 0..<loginResponse.clockOut.count{
                                self.clockedOutData.append(crewClockedOut.init(isSelected: false, name: loginResponse.clockOut[i].name, date: loginResponse.clockOut[i].time, ids: loginResponse.clockOut[i].id))
                            }
                            progressHUD.hide()
                            DispatchQueue.main.async {
                                self.crewTV.delegate = self
                                self.crewTV.dataSource = self
                                self.crewTV.reloadData()
                            }
                        } else {
                            print("Error decoding JSON")
                            _ = SweetAlert().showAlert("", subTitle: "Error Decoding", style: AlertStyle.error,buttonTitle:"OK")
                            progressHUD.hide()
                        }
                        
                    }else if self.status == 403{
                        progressHUD.hide()
                        if let appDomain = Bundle.main.bundleIdentifier {
                            UserDefaults.standard.removePersistentDomain(forName: appDomain)
                        }
                        NotificationCenter.default.removeObserver(self)
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK"){ (isOtherButton) -> Void in
                            if isOtherButton == true {
                                ksceneDelegate?.logout()
                            }
                        }
                    }else if self.status == 202{
                        progressHUD.hide()
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK")
                    }else if self.status == 201{
                        progressHUD.hide()
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.warning,buttonTitle:"OK")
                    }else{
                        progressHUD.hide()
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK")
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
                                _ = SweetAlert().showAlert("Failure", subTitle:  message, style: AlertStyle.error,buttonTitle:"OK")
                            }
                        } catch {
                            // Your handling code
                            _ = SweetAlert().showAlert("Oops..", subTitle:  "Something went wrong ", style: AlertStyle.error,buttonTitle:"OK")
                            
                        }
                    }
                }
            }
    }
}
