//
//  CheckListVC.swift
//  Cleansing
//
//  Created by United It Services on 13/10/23.
//

import UIKit
import Alamofire
class CheckListVC: UIViewController {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var checkListTV: UITableView!
    @IBOutlet weak var checkListTopName: UILabel!
    @IBOutlet weak var addCustomerBtn: UIButton!
    @IBOutlet weak var customerHeight: NSLayoutConstraint!
    
    
    var groupedChecklists: [(CheckLists, CheckLists?)] = []
    var taskId: Int = 0
    var status: Int = 0
    var selection: [Bool] = []
    var selectedRow: Int?
    var selectedRows: [Int]?
    var index = 0
    var sm: [String] = []
    var si: [String] = []
    var calledType:String = ""
    var checklist = [showCheckListDetails]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    

    @IBAction func submitBtnTap(_ sender: UIButton) {
        if calledType == ""{
            //submit checklist and move back
            let id = checklist[selectedRow ?? 0].id
            if self.checklist.count < 1{
                self.dismiss(animated: true)
            }else{
                submitCheckList(id: id)
            }
        }else if calledType == "AdminProj"{
            NotificationCenter.default.post(name: Notification.Name(rawValue: "disconnectPaxiSockets"), object: nil)
            self.dismiss(animated: true)
        }else{
            UserDefaults.standard.setValue(sm, forKey: "sm")
            UserDefaults.standard.setValue(si, forKey: "si")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "disconnectPaxiSocket"), object: nil)
            self.dismiss(animated: true)
        }
    }
    
    
    @IBAction func addCustomerTap(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add Customer".localizeString(string: lang), message: nil, preferredStyle: .alert)
              // Add a text field to the alert
              alertController.addTextField { textField in
                  textField.tintColor = UIColor.init(hexString: "528E4A")
                  textField.placeholder = "Enter customer name".localizeString(string: lang)
              }

              // Create a "Submit" action
        let submitAction = UIAlertAction(title: "Add".localizeString(string: lang), style: .default) { action in
                  if let textField = alertController.textFields?.first {
                      if let text = textField.text {
                          print("Entered text: \(text)")
                          self.addCustomer(name: text)
                      }
                  }
              }
              // Create a "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel".localizeString(string: lang), style: .cancel, handler: nil)
              // Add the actions to the alert controller
              alertController.addAction(submitAction)
              alertController.addAction(cancelAction)
              // Present the alert
              present(alertController, animated: true, completion: nil)
    }
    

}
//MARK: First Call
extension CheckListVC {
    
    func firstCall()
    {
        sm.removeAll()
        si.removeAll()
        submitBtn.roundedButton()
        submitBtn.setTitle("Submit".localizeString(string: lang), for: .normal)
        addCustomerBtn.setTitle("Add Customer".localizeString(string: lang), for: .normal)
        if calledType == ""{
            customerHeight.constant = 0
            addCustomerBtn.isHidden = true
            workerProjectDetails(id: taskId)
        }else if calledType == "AdminProj"{
            customerHeight.constant = 40
            addCustomerBtn.isHidden = false
            getCustomer()
        }else if calledType == "Invite"{
            customerHeight.constant = 0
            addCustomerBtn.isHidden = true
            getManager()
        }else{
            customerHeight.constant = 0
            addCustomerBtn.isHidden = true
            getManager()
        }
        
    }
}

//MARK: TableView Delegate
extension CheckListVC: UITableViewDelegate, UITableViewDataSource{
    
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
        if  calledType == "AdminProj"{
            cell.editBtn.isHidden = false
        }
        if indexPath.row == selectedRow {
//               cell.accessoryType = .checkmark // You can use your preferred indicator
                cell.firstButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            if calledType == "AdminProj" || calledType == "Invite"{
                UserDefaults.standard.setValue(checklist[indexPath.row].title, forKey: "cn")
                UserDefaults.standard.setValue(checklist[indexPath.row].id, forKey: "ci")
                if calledType == "AdminProj"{
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "disconnectPaxiSockets"), object: nil)
                    self.dismiss(animated: true)
                }
                
            }else if calledType == "AdminProjS"{
               
            }
           } else {
//               cell.accessoryType = .none
               cell.firstButton.setImage(UIImage(systemName: "square"), for: .normal)
           }
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(editTapped(_:)), for: .touchUpInside)
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
        if calledType == "AdminProjS"{
           
            if let cell = tableView.cellForRow(at: indexPath) as? CheckListTVC {
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
            if calledType == "AdminProjS"{
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
    
    @objc func editTapped(_ sender: UIButton){
        
        let alertController = UIAlertController(title: "Edit Customer".localizeString(string: lang), message: nil, preferredStyle: .alert)
              // Add a text field to the alert
              alertController.addTextField { textField in
                  textField.placeholder = "Enter customer name".localizeString(string: lang)
                  textField.text = self.checklist[sender.tag].title
              }

              // Create a "Submit" action
        let submitAction = UIAlertAction(title: "Save".localizeString(string: lang), style: .default) { action in
                  if let textField = alertController.textFields?.first {
                      if let text = textField.text {
                          print("Entered text: \(text)")
                          self.editCustomer(name: text, id: self.checklist[sender.tag].id)
                      }
                  }
              }
              // Create a "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel".localizeString(string: lang), style: .cancel, handler: nil)
              // Add the actions to the alert controller
              alertController.addAction(submitAction)
              alertController.addAction(cancelAction)
              // Present the alert
              present(alertController, animated: true, completion: nil)
        
    }
}
//MARK: API Implement

extension CheckListVC {
    
    func workerProjectDetails(id: Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
      
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/singletask"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["id": id]
        print(param)
        print("Access Token: \(accessToken)")
        AF.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: ["Authorization": "Bearer "+accessToken+""])
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
                               let loginResponse = try? JSONDecoder().decode(TaskDetailInfo.self, from: jsonData) {
                                self.taskId = loginResponse.data.id
                                self.checkListTopName.text = "CheckList for ".localizeString(string: lang) + loginResponse.data.task_title

                                // Loop through the checklist array and group items into pairs
                                for (index, checklist) in loginResponse.checklist.enumerated() {
                                    if index % 2 == 0 {
                                        // Create a pair of items (even-indexed item, next item)
                                        let nextIndex = index + 1
                                        let nextChecklist: CheckLists? = nextIndex < loginResponse.checklist.count ? loginResponse.checklist[nextIndex] : nil
                                        self.groupedChecklists.append((checklist, nextChecklist))
                                    }
                                }
                                
                                
                                progressHUD.hide()
                                self.checklist.removeAll()
                                for i in 0..<loginResponse.checklist.count{
                                    self.checklist.append(showCheckListDetails(id: loginResponse.checklist[i].id, employee_id: loginResponse.checklist[i].employee_id, title: loginResponse.checklist[i].title, project_id: loginResponse.checklist[i].project_id, task_id: loginResponse.checklist[i].task_id, status: loginResponse.checklist[i].status))
                                    if loginResponse.checklist[i].status == 1{
                                        self.selectedRow = i
                                    }
                                }
                                
                                if self.checklist.count < 1{
                                    self.dismiss(animated: true)
                                }
                                
                                self.selection = Array(repeating: false, count: self.checklist.count)
                                self.checkListTV.delegate = self
                                self.checkListTV.dataSource = self
                                self.checkListTV.reloadData()
                                
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
    
    func submitCheckList(id: Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
      
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/change_status_checklist"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["checkList_id": id]
        print(param)
        print("Access Token: \(accessToken)")
        AF.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: ["Authorization": "Bearer "+accessToken+""])
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
                               let _ = try? JSONDecoder().decode(DefaultInfo.self, from: jsonData) {
                             
                                
                                progressHUD.hide()
                                self.dismiss(animated: true)
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
    
    
    //MARK: Get Customer API to create Project Admin
    func getCustomer()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
      
        let param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/get_customer"
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
                               let loginResponse = try? JSONDecoder().decode(CustomerResponse.self, from: jsonData) {
                                self.checkListTopName.text = "Select customer name".localizeString(string: lang)

                                
                                
                                progressHUD.hide()
                                self.checklist.removeAll()
                                for i in 0..<loginResponse.customer.count{
                                    self.checklist.append(showCheckListDetails(id: loginResponse.customer[i].id, employee_id: 0, title: loginResponse.customer[i].name, project_id: 0, task_id: 0, status:0))
                                }
                                self.selection = Array(repeating: false, count: self.checklist.count)
                                self.checkListTV.delegate = self
                                self.checkListTV.dataSource = self
                                self.checkListTV.reloadData()
                                
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
    
    //MARK: Get Manager API to create Project Admin
    func getManager()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
      
        let param: Parameters = ["":""]
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
                                if self.calledType == "Invite"{
                                    self.checkListTopName.text = "Select Time Approver".localizeString(string: lang)
                                }else{
                                    self.checkListTopName.text = "Select manager name".localizeString(string: lang)
                                }
                                
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
    
    //MARK: Add Customer API to create Project Admin
    func addCustomer(name: String)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
      
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/add_customer"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["customer_name": name]
        print(param)
        print("Access Token: \(accessToken)")
        AF.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: ["Authorization": "Bearer "+accessToken+""])
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
                               let _ = try? JSONDecoder().decode(DefaultInfo.self, from: jsonData) {
                               
                                progressHUD.hide()
                                self.getCustomer()
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
    
    //MARK: Edit Customer API to create Project Admin
    func editCustomer(name: String, id: Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
      
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/edit_customer"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["customer_id": id, "customer_name": name]
        print(param)
        print("Access Token: \(accessToken)")
        AF.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: ["Authorization": "Bearer "+accessToken+""])
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
                             let  _ = try? JSONDecoder().decode(DefaultInfo.self, from: jsonData) {
                               
                                progressHUD.hide()
                                self.getCustomer()
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
