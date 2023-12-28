//
//  SelectionVC.swift
//  Cleansing
//
//  Created by UIS on 10/11/23.
//

import UIKit
import Alamofire
class SelectionVC: UIViewController {
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var checkListTV: UITableView!
    @IBOutlet weak var checkListTopName: UILabel!
    //    @IBOutlet weak var addCustomerBtn: UIButton!
    //    @IBOutlet weak var customerHeight: NSLayoutConstraint!
    
    
    var taskId: Int = 0
    var locations: [String] = []
    var saveLat: [String] = []
    var saveLng: [String] = []
    var status: Int = 0
    var selection: [Bool] = []
    var selectedRow: Int?
    var index = 0
    var sm: [String] = []
    var si: [String] = []
    var calledType:String = ""
    var checklist = [showCheckListDetails]()
    var selections = [selectionDetails]()
    var breakPolicy: [String] = ["Paid","UnPaid"]
    var exemption: [String] = ["Exempt","Non Exempt"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    
    
    @IBAction func submitBtnTap(_ sender: UIButton) {
        
//        if calledType == "Watcher"{
//            selections.append(selectionDetails.init(member_id: "", timezone_id: 0, project_id: 0, label_id: 0, watcher_id: si.joined(separator: ","), member_name: "", timezone_name: "", project_name: "", label_name: "", watcher_name: sm.joined(separator: ", "), type: "Watcher", location: ""))
//        }else 
        if calledType == "Member"{
            selections.append(selectionDetails.init(member_id: si.joined(separator: ","), timezone_id: 0, project_id: 0, label_id: 0, watcher_id: "", member_name: sm.joined(separator: ", "), timezone_name: "", project_name: "", label_name: "", watcher_name: "", type: "Member", location: ""))
        }
//        
        if selections.count > 0{
            print(selections[0])
            do {
                let encodedData = try JSONEncoder().encode(selections)
                UserDefaults.standard.set(encodedData, forKey: "selections")
            } catch {
                print("Error encoding selections: \(error.localizedDescription)")
            }
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "disconnectPaxiSockets"), object: nil)
        self.dismiss(animated: true)
    }
    
}
//MARK: First Call
extension SelectionVC {
    
    func firstCall()
    {
        sm.removeAll()
        si.removeAll()
        submitBtn.roundedButton()
        if calledType == "TimeZone"{
            getTimeZone()
        }else if calledType == "Project"{
            getProject()
        }else if calledType == "Label"{
            
        }else if calledType == "Watcher"{
            getManager()
        }else if calledType == "Exempt"{
            self.title = "Select an exemption status"
            self.checklist.append(showCheckListDetails(id: 0, employee_id: 0, title: "Exempt", project_id: 0, task_id: 0, status:0))
            self.checklist.append(showCheckListDetails(id: 0, employee_id: 0, title: "Non Exempt", project_id: 0, task_id: 0, status:0))
            self.selection = Array(repeating: false, count: self.checklist.count)
            self.checkListTV.delegate = self
            self.checkListTV.dataSource = self
            self.checkListTV.reloadData()
        }else if calledType == "Break"{
            self.title = "Select a meal break policy"
            self.checklist.append(showCheckListDetails(id: 0, employee_id: 0, title: "Paid", project_id: 0, task_id: 0, status:0))
            self.checklist.append(showCheckListDetails(id: 0, employee_id: 0, title: "UnPaid", project_id: 0, task_id: 0, status:0))
            self.selection = Array(repeating: false, count: self.checklist.count)
            self.checkListTV.delegate = self
            self.checkListTV.dataSource = self
            self.checkListTV.reloadData()
        }else{
            getMembers()
        }
        
        
    }
}

//MARK: TableView Delegate
extension SelectionVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.count//groupedChecklists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tclCell", for: indexPath) as! CheckListTVC
        
        cell.firstLabel.text = checklist[indexPath.row].title
        cell.firstView.tag = indexPath.row
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(firstviewTapped(_:)))
        cell.firstView.addGestureRecognizer(tapGesture)
        if indexPath.row == selectedRow {
            cell.firstButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            if calledType == "TimeZone"{
                selections.append(selectionDetails.init(member_id: "", timezone_id: checklist[indexPath.row].id, project_id: 0, label_id: 0, watcher_id: "", member_name: "", timezone_name: checklist[indexPath.row].title, project_name: "", label_name: "", watcher_name: "", type: "TimeZone", location: ""))
            }else if calledType == "Project"{
                selections.append(selectionDetails.init(member_id: "", timezone_id: 0, project_id: checklist[indexPath.row].id, label_id: 0, watcher_id: "", member_name: "", timezone_name: "", project_name: checklist[indexPath.row].title, label_name: "", watcher_name: "", type: "Project", location: locations[indexPath.row]))
            }else if calledType == "Label"{
                selections.append(selectionDetails.init(member_id: "", timezone_id: 0, project_id: 0, label_id: checklist[indexPath.row].id, watcher_id: "", member_name: "", timezone_name: "", project_name: "", label_name: checklist[indexPath.row].title, watcher_name: "", type: "Label", location: ""))
            }else if calledType == "Watcher"{
                selections.append(selectionDetails.init(member_id: "", timezone_id: 0, project_id: 0, label_id: 0, watcher_id: "\(checklist[indexPath.row].id)", member_name: "", timezone_name: "", project_name: "", label_name: "", watcher_name: checklist[indexPath.row].title, type: "Watcher", location: ""))
            }else if calledType == "Exempt"{
                selections.append(selectionDetails.init(member_id: "", timezone_id: 0, project_id: 0, label_id: 0, watcher_id: "", member_name: "", timezone_name: "", project_name: "", label_name: "", watcher_name: checklist[indexPath.row].title, type: "Exempt", location: ""))
            }else if calledType == "Break"{
                selections.append(selectionDetails.init(member_id: "", timezone_id: 0, project_id: 0, label_id: 0, watcher_id: "", member_name: "", timezone_name: "", project_name: "", label_name: "", watcher_name: checklist[indexPath.row].title, type: "Break", location: ""))
            }else{
//                selections.append(selectionDetails.init(member_id: "\(checklist[indexPath.row].id)", timezone_id: 0, project_id: 0, label_id: 0, watcher_id: "", member_name: checklist[indexPath.row].title, timezone_name: "", project_name: "", label_name: "", watcher_name: "", type: "Member", location: ""))
            }
        } else {
            cell.firstButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
        cell.editBtn.isHidden = true
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
//        if calledType == "Watcher"{
//            if let cell = checkListTV.cellForRow(at: indexPath) as? CheckListTVC {
//                cell.firstButton.isSelected = !cell.firstButton.isSelected
//                
//                // Handle storing selected items in your arrays (self.sm and self.si)
//                if cell.firstButton.isSelected {
//                    self.sm.append(checklist[indexPath.row].title)
//                    self.si.append("\(checklist[indexPath.row].id)")
//                    cell.firstButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
//                } else {
//                    cell.firstButton.setImage(UIImage(systemName: "square"), for: .normal)
//                    if let index = self.sm.firstIndex(of: checklist[indexPath.row].title) {
//                        self.sm.remove(at: index)
//                    }
//                    if let index = self.si.firstIndex(of: "\(checklist[indexPath.row].id)") {
//                        self.si.remove(at: index)
//                    }
//                }
//            }
//        }else 
        if calledType == "Member"{
            if let cell = checkListTV.cellForRow(at: indexPath) as? CheckListTVC {
                cell.firstButton.isSelected = !cell.firstButton.isSelected
                
                // Handle storing selected items in your arrays (self.sm and self.si)
                if cell.firstButton.isSelected {
                    self.sm.append(checklist[indexPath.row].title)
                    self.si.append("\(checklist[indexPath.row].id)")
                    cell.firstButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
                } else {
                    cell.firstButton.setImage(UIImage(systemName: "square"), for: .normal)
                    if let index = self.sm.firstIndex(of: checklist[indexPath.row].title) {
                        self.sm.remove(at: index)
                    }
                    if let index = self.si.firstIndex(of: "\(checklist[indexPath.row].id)") {
                        self.si.remove(at: index)
                    }
                }
            }
        }else{
            if indexPath.row == selectedRow {
                selectedRow = nil
            } else {
                selectedRow = indexPath.row
            }
            tableView.reloadData()
        }
    }
    
    @objc func firstviewTapped(_ gesture: UITapGestureRecognizer) {
        print("View1 tapped!")
        if let tappedView = gesture.view {
            let tag = tappedView.tag
            let indexPath = IndexPath(row: tag, section: 0)
//            if calledType == "Watcher"{
//                if let cell = checkListTV.cellForRow(at: indexPath) as? CheckListTVC {
//                    cell.firstButton.isSelected = !cell.firstButton.isSelected
//                    
//                    // Handle storing selected items in your arrays (self.sm and self.si)
//                    if cell.firstButton.isSelected {
//                        self.sm.append(checklist[indexPath.row].title)
//                        self.si.append("\(checklist[indexPath.row].id)")
//                        cell.firstButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
//                    } else {
//                        cell.firstButton.setImage(UIImage(systemName: "square"), for: .normal)
//                        if let index = self.sm.firstIndex(of: checklist[indexPath.row].title) {
//                            self.sm.remove(at: index)
//                        }
//                        if let index = self.si.firstIndex(of: "\(checklist[indexPath.row].id)") {
//                            self.si.remove(at: index)
//                        }
//                    }
//                }
//            }else 
            if calledType == "Member"{
                if let cell = checkListTV.cellForRow(at: indexPath) as? CheckListTVC {
                    cell.firstButton.isSelected = !cell.firstButton.isSelected
                    
                    // Handle storing selected items in your arrays (self.sm and self.si)
                    if cell.firstButton.isSelected {
                        self.sm.append(checklist[indexPath.row].title)
                        self.si.append("\(checklist[indexPath.row].id)")
                        cell.firstButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
                    } else {
                        cell.firstButton.setImage(UIImage(systemName: "square"), for: .normal)
                        if let index = self.sm.firstIndex(of: checklist[indexPath.row].title) {
                            self.sm.remove(at: index)
                        }
                        if let index = self.si.firstIndex(of: "\(checklist[indexPath.row].id)") {
                            self.si.remove(at: index)
                        }
                    }
                }
            }else{
                if indexPath.row == selectedRow {
                    selectedRow = nil
                } else {
                    selectedRow = indexPath.row
                }
                
                checkListTV.reloadData()
            }
        }
    }
}
//MARK: API Implement

extension SelectionVC {
    
    //MARK: Get TimeZone to create task Admin
    func getTimeZone()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/get_timezone"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        print(param)
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
                           let loginResponse = try? JSONDecoder().decode(TimeZoneResponse.self, from: jsonData) {
                            
                            self.checkListTopName.text = "Select timezone"
                            
                            
                            self.checklist.removeAll()
                            for i in 0..<loginResponse.timezone.count{
                                self.checklist.append(showCheckListDetails(id: loginResponse.timezone[i].id, employee_id: 0, title: loginResponse.timezone[i].name, project_id: 0, task_id: 0, status:0))
                            }
                            progressHUD.hide()
                            self.selection = Array(repeating: false, count: self.checklist.count)
                            self.checkListTV.delegate = self
                            self.checkListTV.dataSource = self
                            self.checkListTV.reloadData()
                            
                            
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
    
    
    //MARK: Get Project API to create Task Admin
    func getProject()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/get_project"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        print(param)
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
                           let loginResponse = try? JSONDecoder().decode(ProjectResponse.self, from: jsonData) {
                            self.checkListTopName.text = "Select project name"
                            self.locations.removeAll()
                            self.saveLat.removeAll()
                            self.saveLng.removeAll()
                            self.checklist.removeAll()
                            for i in 0..<loginResponse.projects.count{
                                self.locations.append(loginResponse.projects[i].location)
                                self.saveLat.append(loginResponse.projects[i].latitude)
                                self.saveLng.append(loginResponse.projects[i].longitude)
                                self.checklist.append(showCheckListDetails(id: loginResponse.projects[i].id, employee_id: 0, title: loginResponse.projects[i].projectName + " - " + loginResponse.projects[i].location, project_id: 0, task_id: 0, status:0))
                            }
                            progressHUD.hide()
                            
                            self.selection = Array(repeating: false, count: self.checklist.count)
                            self.checkListTV.delegate = self
                            self.checkListTV.dataSource = self
                            self.checkListTV.reloadData()
                            
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
    
    //MARK: Get memebers API to create Task Admin
    func getMembers()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/get_members"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        print(param)
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
                           let loginResponse = try? JSONDecoder().decode(MembersResponse.self, from: jsonData) {
                            self.checkListTopName.text = "Select member name"
                            
                            
                            self.checklist.removeAll()
                            for i in 0..<loginResponse.members.count{
                                self.checklist.append(showCheckListDetails(id: loginResponse.members[i].id, employee_id: 0, title: loginResponse.members[i].fullname, project_id: 0, task_id: 0, status:0))
                            }
                            progressHUD.hide()
                            self.selection = Array(repeating: false, count: self.checklist.count)
                            self.checkListTV.delegate = self
                            self.checkListTV.dataSource = self
                            self.checkListTV.reloadData()
                            
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
    
    //MARK: Get Manager API to create Project Admin
    func getManager()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/get_manager"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        print(param)
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
                           let loginResponse = try? JSONDecoder().decode(ManagerResponse.self, from: jsonData) {
                            self.checkListTopName.text = "Select manager name"
                            
                            progressHUD.hide()
                            self.checklist.removeAll()
                            for i in 0..<loginResponse.manager.count{
                                self.checklist.append(showCheckListDetails(id: loginResponse.manager[i].id, employee_id: 0, title: loginResponse.manager[i].fullname, project_id: 0, task_id: 0, status:0))
                            }
                            self.selection = Array(repeating: false, count: self.checklist.count)
                            self.checkListTV.delegate = self
                            self.checkListTV.dataSource = self
                            self.checkListTV.reloadData()
                            
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
