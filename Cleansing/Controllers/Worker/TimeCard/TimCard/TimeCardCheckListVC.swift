//
//  TimeCardCheckListVC.swift
//  Cleansing
//
//  Created by uis on 14/02/24.
//

import UIKit
import Alamofire
class TimeCardCheckListVC: UIViewController {

    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var checkListTV: UITableView!
    @IBOutlet weak var checkListTopName: UILabel!
    
    
    var taskId: Int = 0
    var status: Int = 0
    var selection: [Bool] = []
    var selectedRows: [Int] = []
    var selectedRow: Int?
    var groupedChecklists: [(CheckLists, CheckLists?)] = []
    var checklist = [showCheckListDetails]()
    var selections = [selectionDetails]()
    var breakPolicy: [String] = ["Paid".localizeString(string: lang),"UnPaid".localizeString(string: lang)]
    var exemption: [String] = ["Exempt".localizeString(string: lang),"Non Exempt".localizeString(string: lang)]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    
    
    @IBAction func submitBtnTap(_ sender: UIButton) {
//        let id = checklist[selectedRow ?? 0].id
//        if self.checklist.count < 1{
//            self.dismiss(animated: true)
//        }else{
//            submitCheckList(id: id)
//        }
        self.dismiss(animated: true)
    }
    
}
//MARK: First Call
extension TimeCardCheckListVC {
    
    func firstCall()
    {
        submitBtn.setTitle("Submit".localizeString(string: lang), for: .normal)
        submitBtn.roundedButton()
        workerProjectDetails(id: taskId)
        
    }
}

//MARK: TableView Delegate
extension TimeCardCheckListVC: UITableViewDelegate, UITableViewDataSource{
    
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
        if selectedRows.contains(indexPath.row) {
                  cell.firstButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
              } else {
                  cell.firstButton.setImage(UIImage(systemName: "square"), for: .normal)
              }
              
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(firstviewTapped(_:)))
        cell.firstView.addGestureRecognizer(tapGesture)
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
        if let index = selectedRows.firstIndex(of: indexPath.row) {
                   selectedRows.remove(at: index)
               } else {
                   selectedRows.append(indexPath.row)
               }
               
               // Reload selected cell to update UI
               tableView.reloadRows(at: [indexPath], with: .automatic)
               
               // Call function when cell is selected or deselected
               cellSelectionDidChange(at: indexPath, isSelected: selectedRows.contains(indexPath.row))
    }
    
    @objc func firstviewTapped(_ gesture: UITapGestureRecognizer) {
        if let tappedView = gesture.view {
            let tag = tappedView.tag
            let indexPath = IndexPath(row: tag, section: 0)
            if let cell = checkListTV.cellForRow(at: indexPath) as? CheckListTVC {
                //added
                if let index = selectedRows.firstIndex(of: indexPath.row) {
                           selectedRows.remove(at: index)
                       } else {
                           selectedRows.append(indexPath.row)
                       }
                       // Reload selected cell to update UI
                       checkListTV.reloadRows(at: [indexPath], with: .automatic)
                       // Call function when cell is selected or deselected
                       cellSelectionDidChange(at: indexPath, isSelected: selectedRows.contains(indexPath.row))
                //added
            }
        }
    }
    func cellSelectionDidChange(at indexPath: IndexPath, isSelected: Bool) {
           if isSelected {
               // Call your function when cell is selected
               print("Cell at index \(indexPath.row) selected")
               let id = checklist[indexPath.row].id
               submitCheckList(id: id)
           } else {
               // Call your function when cell is deselected
               print("Cell at index \(indexPath.row) deselected")
               let id = checklist[indexPath.row].id
               submitCheckList(id: id)
           }
       }
}
//MARK: API Implement

extension TimeCardCheckListVC {
    
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
                                        self.selectedRows.append(i)
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
