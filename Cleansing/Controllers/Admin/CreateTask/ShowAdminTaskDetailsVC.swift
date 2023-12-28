//
//  ShowAdminTaskDetailsVC.swift
//  Cleansing
//
//  Created by UIS on 13/11/23.
//

import UIKit
import Alamofire
class ShowAdminTaskDetailsVC: UIViewController {
    
    @IBOutlet weak var showTaskTV: UITableView!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var selectDateTime: UITextField!
    @IBOutlet weak var selectDueDate: UITextField!
    @IBOutlet weak var selectProject: UILabel!
    @IBOutlet weak var selectWatcher: UITextField!
    @IBOutlet weak var addNotes: UIButton!
    @IBOutlet weak var EditTask: UIButton!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var selectMember: UITextField!
    @IBOutlet weak var navigateBtn: UIButton!
    
    @IBOutlet weak var checkListView: UIView!
    
    
    var status: Int = 0
    var taskId: Int = 0
    var endLat: Double = 0.0
    var endLng: Double = 0.0
    var checkListData = [createCheckList]()
    var completeStatus: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    
    
    @IBAction func editTaskBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateTaskAdminVC") as? CreateTaskAdminVC{
            VC.taskId = taskId
            VC.called = "Show"
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func addNotesBtnTap(_ sender: UIButton) {
        //add notes
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowNotesVC") as? ShowNotesVC{
            VC.taskID = taskId
            VC.calledFrom = "AdminTask"
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func statusBtnTap(_ sender: UIButton) {
        if completeStatus != 3{
            let refreshAlert = UIAlertController(title: "Complete Task", message: "Do you want to complete this task ?", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                refreshAlert .dismiss(animated: true, completion: nil)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Complete", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                self.taskComplete(id: self.taskId)
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func navigateBtnTap(_ sender: UIButton) {
        mapBtnTap()
    }
    
  
    
}

//MARK: First Call
extension ShowAdminTaskDetailsVC {
    
    func firstCall()
    {
        getTask()
        self.title = "View Task"
        EditTask.roundedButton()
        addNotes.roundedButton()
        selectDateTime.inputView = UIView()
        selectDateTime.inputAccessoryView = UIView()
        selectDateTime.tintColor = .white
        selectDueDate.inputView = UIView()
        selectDueDate.inputAccessoryView = UIView()
        selectDueDate.tintColor = .white
        selectWatcher.inputView = UIView()
        selectWatcher.inputAccessoryView = UIView()
        selectWatcher.tintColor = .white
        selectMember.inputView = UIView()
        selectMember.inputAccessoryView = UIView()
        selectMember.tintColor = .white
        
        navigateBtn.layer.masksToBounds = true
        navigateBtn.layer.cornerRadius = 5
        navigateBtn.layer.borderWidth = 1
        navigateBtn.layer.borderColor = UIColor.lightGray.cgColor
        createBar()
    }
    
    //MARK: Create UINavigationBar Button
    func createBar(){
        if let deleteImage = UIImage(named: "trash-bin") {
            let originalDeleteImage = deleteImage.withRenderingMode(.alwaysOriginal)
            let deleteButton = UIBarButtonItem(
                image: originalDeleteImage,
                style: .plain,
                target: self,
                action: #selector(deleteButtonTapped)
            )
            navigationItem.rightBarButtonItem = deleteButton
        }
    }
    
    @objc func deleteButtonTapped() {
        let refreshAlert = UIAlertController(title: "Delete Task", message: "Deleting the task will remove all your task data, do you want to delete ?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            refreshAlert .dismiss(animated: true, completion: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.deleteTasks(id: self.taskId)
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
   
    
    func mapBtnTap() {
        let latitude = endLat // Replace with your desired latitude
        let longitude = endLng // Replace with your desired longitude
        
        if let url = URL(string: "comgooglemaps://?q=\(latitude),\(longitude)&directionsmode=driving") {
            if UIApplication.shared.canOpenURL(url) {
                // Open Google Maps app if available
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Open Google Maps in Safari if the app is not installed
                let webUrl = URL(string: "https://maps.google.com/maps?q=\(latitude),\(longitude)&directionsmode=driving")
                UIApplication.shared.open(webUrl!, options: [:], completionHandler: nil)
            }
        }
        
        //        showRouteOnAppleMaps(startLat: 28.5355, startLong: 77.3910, endLat: 28.4089, endLong: 77.3178)
        
    }
}

//MARK: TableView Delegate
extension ShowAdminTaskDetailsVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cclCell", for: indexPath) as! CreateCheckListTVC
        cell.topLabel.text = checkListData[indexPath.row].title
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTap(_:)), for: .touchUpInside)
        //        checkLists.append(checkListData[indexPath.row].title)
        cell.topButton.tag = indexPath.row
        cell.topButton.addTarget(self, action: #selector(selectBtnTap(_:)), for: .touchUpInside)
        if checkListData[indexPath.row].status == 1{
            cell.topButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        }else{
            cell.topButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
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
    
    @objc func deleteBtnTap(_ sender: UIButton){
        let tag = sender.tag
        let refreshAlert = UIAlertController(title: "Delete Checklist", message: "Do you want to delete this task checklist ?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            refreshAlert .dismiss(animated: true, completion: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.deleteCheckList(id: self.checkListData[tag].id, tag: tag)
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    @objc func selectBtnTap(_ sender: UIButton){
        let tag = sender.tag
        submitCheckList(id: checkListData[tag].id, tag: tag)
    }
}

//MARK: API Integration
extension ShowAdminTaskDetailsVC{
    
    //MARK: Get Task API
    func getTask()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/get_task_detail"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["task_id" : taskId]
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
                           let loginResponse = try? JSONDecoder().decode(DetailAdminTasks.self, from: jsonData) {
                            self.checkListData.removeAll()
                            self.taskTitle.text = loginResponse.task.title
                            self.selectMember.text = loginResponse.task.memberName
                            self.selectDateTime.text = loginResponse.task.startDateTime
                            self.selectDueDate.text = loginResponse.task.dueDateTime
                            self.selectProject.text = loginResponse.task.projectName + " - " + loginResponse.task.location
                            self.selectWatcher.text = loginResponse.task.managerName
                            
                            if let doubleValue = Double(loginResponse.task.latitude) {
                                // Use doubleValue as a Double
                                print(doubleValue)
                                self.endLat = doubleValue
                            } else {
                                // Handle the case where the conversion fails
                                print("Invalid double value")
                            }
                            
                            if let doubleValue1 = Double(loginResponse.task.longitude) {
                                // Use doubleValue as a Double
                                print(doubleValue1)
                                self.endLng = doubleValue1
                            } else {
                                // Handle the case where the conversion fails
                                print("Invalid double value")
                            }
                            self.completeStatus = loginResponse.task.status
                            if loginResponse.task.status == 3 {
                                if let image = UIImage(systemName: "checkmark.circle.fill") {
                                    let tintedImage = image.withTintColor(UIColor.systemGreen, renderingMode: .alwaysOriginal)
                                    self.statusBtn.setImage(tintedImage, for: .normal)
                                }
                                self.EditTask.isHidden = true
                                self.addNotes.isHidden = true
                            }else{
                                if let image = UIImage(systemName: "checkmark.circle.fill") {
                                    let tintedImage = image.withTintColor(UIColor.lightGray, renderingMode: .alwaysOriginal)
                                    self.statusBtn.setImage(tintedImage, for: .normal)
                                }
                            }
                            
                            
                            for i in 0..<loginResponse.task.checklist.count{
                                self.checkListData.append(createCheckList.init(id: loginResponse.task.checklist[i].id, title: loginResponse.task.checklist[i].title, status: loginResponse.task.checklist[i].status))
                            }
                            progressHUD.hide()
                            
                            self.showTaskTV.delegate = self
                            self.showTaskTV.dataSource = self
                            self.showTaskTV.reloadData()
                            
                            
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
    
    func submitCheckList(id: Int, tag: Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
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
                           let loginResponse = try? JSONDecoder().decode(DefaultInfo.self, from: jsonData) {
                            
                            progressHUD.hide()
                            
                            self.getTask()
                            //                                print(self.checkListData[tag])
                            //                                self.checkListData.insert(createCheckList.init(id:  self.checkListData[tag].id, title:  self.checkListData[tag].title, status: 1), at: tag)
                            //                                print(self.checkListData[tag])
                            //                                self.checkListData.remove(at: tag + 1)
                            //                                self.createTaskTV.reloadData()
                            
                            
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
    
    //MARK: Delete Tasks
    func deleteTasks(id : Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let url = "\(ApiLink.HOST_URL)/delete_task"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        
        print("Access Token: \(accessToken)")
        var param: Parameters = ["":""]
        param = ["task_id": id]
        print(param)
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
                           let loginResponse = try? JSONDecoder().decode(DefaultInfo.self, from: jsonData) {
                            progressHUD.hide()
                            _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.success,buttonTitle:"OK"){ (isOtherButton) -> Void in
                                if isOtherButton == true {
                                    self.navigationController?.popViewController(animated: true)
                                }
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
    
    //MARK: Delete Checklist
    func deleteCheckList(id: Int, tag: Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/delete_checklist"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["checklist_id": id]
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
                           let loginResponse = try? JSONDecoder().decode(DefaultInfo.self, from: jsonData) {
                            
                            progressHUD.hide()
                            self.getTask()
                            
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
    
    //MARK: Task Completion
    func taskComplete(id: Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/task_completion"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["task_id": id]
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
                           let loginResponse = try? JSONDecoder().decode(DefaultInfo.self, from: jsonData) {
                            
                            progressHUD.hide()
                            self.completeStatus = 3
                            if let image = UIImage(systemName: "checkmark.circle.fill") {
                                let tintedImage = image.withTintColor(UIColor.systemGreen, renderingMode: .alwaysOriginal)
                                self.statusBtn.setImage(tintedImage, for: .normal)
                            }
                           
                            _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.success,buttonTitle:"OK")
                            
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

//MARK: TextField Delegate

extension ShowAdminTaskDetailsVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Disable paste, replace, etc. by always returning false
        textField.inputAssistantItem.leadingBarButtonGroups = []
        textField.inputAssistantItem.trailingBarButtonGroups = []
        return false
    }
}


