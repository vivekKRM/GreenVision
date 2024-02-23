//
//  CreateTaskAdminVC.swift
//  Cleansing
//
//  Created by UIS on 08/11/23.
//

import UIKit
import Alamofire
import CoreLocation
class CreateTaskAdminVC: UIViewController {
    
    
    @IBOutlet weak var createTaskTV: UITableView!
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var teamMember: UITextView!
    @IBOutlet weak var selectDateTime: UITextField!
    @IBOutlet weak var selectDueDate: UITextField!
    @IBOutlet weak var selectTimeZone: UITextField!
    @IBOutlet weak var selectProject: UITextView!
    @IBOutlet weak var selectWatcher: UITextField!
    @IBOutlet weak var createTask: UIButton!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var checkListView: UIView!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    
    @IBOutlet weak var newFirst: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    var status:Int = 0
    var selections = [selectionDetails]()
    var checkListData = [createCheckList]()
    var projectId: Int = 0
    var called: String = ""
    var watcherId: String = ""
    var checkLists: [String] = []
    var memberId: String = ""
    var savelat:String = ""
    var savelng:String = ""
    var startDate: String = ""
    var location: String = ""
    var dueDate: String = ""
    var taskId: Int = 0
    var datePicker = UIDatePicker()
    var tye:String = ""
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
    
    @IBAction func taskBtnTap(_ sender: UIButton) {
        self.view.endEditing(true)
        if checkAll(){
            if called == "Show"{
                editTask(title: taskTitle.text ?? "", members_id: memberId, task_watcher: watcherId, start_date_time: startDate, due_date_time: dueDate, time_zone: selectTimeZone.text ?? "", location:  location, project_id: projectId, latitude: savelat, longitude: savelng, checklist: checkLists)
            }else{
                addTask(title: taskTitle.text ?? "", members_id: memberId, task_watcher: watcherId, start_date_time: startDate, due_date_time: dueDate, time_zone: selectTimeZone.text ?? "", location: location, project_id: projectId, latitude: savelat, longitude: savelng, checklist: checkLists)
            }
        }
    }
    
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addCheckList(_ sender: UIButton) {
        showTextFieldAlert()
    }
    
    @IBAction func submitBtnTap(_ sender: UIButton) {
        let selectedDate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy hh:mm a"
        let formattedDate = dateFormatter.string(from: selectedDate)
        if tye == "selectDateTime"{
            selectDateTime.text = formattedDate
        }else{
            selectDueDate.text = formattedDate
        }
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd hh:mm a"
        let formattedDate1 = dateFormatter1.string(from: selectedDate)
        if tye == "selectDateTime"{
            self.startDate = formattedDate1
            selectDateTime.resignFirstResponder() // Close the date picker
        }else{
            self.dueDate = formattedDate1
            selectDueDate.resignFirstResponder() // Close the date picker
        }
        self.topView.isHidden = true
        self.datePicker.removeFromSuperview()
    }
    
    @IBAction func cancelBtnTap(_ sender: UIButton) {
        datePicker.removeFromSuperview()
        self.topView.isHidden = true
    }
    
}
//MARK: First Call
extension CreateTaskAdminVC{
    
    func firstCall()
    {
        selectProject.layer.cornerRadius = 5
        selectProject.layer.masksToBounds = true
        selectProject.layer.borderWidth = 0.5
        selectProject.delegate = self
        topView.dropShadowWithBlackColor()
        selectProject.layer.borderColor = UIColor.lightGray.cgColor
        createTask.setTitle("Create Task".localizeString(string: lang), for: .normal)
        submitBtn.setTitle("Submit".localizeString(string: lang), for: .normal)
        cancelBtn.setTitle("Cancel".localizeString(string: lang), for: .normal)
        newFirst.text = "Select Project".localizeString(string: lang)
        taskTitle.placeholder = "Enter a task title".localizeString(string: lang)
        teamMember.text = "Team Members".localizeString(string: lang)
        teamMember.textColor = .lightGray
        selectDateTime.placeholder = "Select Date & Time".localizeString(string: lang)
        selectDueDate.placeholder = "Select Due Date".localizeString(string: lang)
        selectWatcher.placeholder = "Select Task Watcher".localizeString(string: lang)
        selectProject.text = "Project".localizeString(string: lang)
        checkLabel.text = "Check Lists".localizeString(string: lang)
        checkBtn.setTitle("Add CheckList Item".localizeString(string: lang), for: .normal)
        if called == "Show"{
            topTitleLabel.text = "Edit Task".localizeString(string: lang)
        }else{
            topTitleLabel.text = "CREATE TASK".localizeString(string: lang)
        }
        createTask.roundedButton()
        taskTitle.tintColor = UIColor.init(hexString: "528E4A")
        teamMember.inputView = UIView()
        teamMember.inputAccessoryView = UIView()
        teamMember.tintColor = .white
        selectDateTime.inputView = UIView()
        selectDateTime.inputAccessoryView = UIView()
        selectDateTime.tintColor = .white
        selectDueDate.inputView = UIView()
        selectDueDate.inputAccessoryView = UIView()
        selectDueDate.tintColor = .white
        selectTimeZone.inputView = UIView()
        selectTimeZone.inputAccessoryView = UIView()
        selectTimeZone.tintColor = .white
        //        selectProject.inputView = UIView()
        //        selectProject.inputAccessoryView = UIView()
        selectProject.tintColor = .white
        selectWatcher.inputView = UIView()
        selectWatcher.inputAccessoryView = UIView()
        selectWatcher.tintColor = .white
        if called == "Show"{
            selectProject.textColor = .black
            addView.isHidden = true
            checkListView.isHidden = true
            createTask.setTitle("Save Task".localizeString(string: lang), for: .normal)
        }else{
            selectProject.textColor = .lightGray
            createTask.setTitle("Create Task".localizeString(string: lang), for: .normal)
            checkListView.isHidden = false
            addView.dropShadowWithBlackColor()
            getProject()
            getProfile()
        }
        
        if called == "Show"{
            getTask()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectPaxiSocket(_:)), name: Notification.Name(rawValue: "disconnectPaxiSockets"), object: nil)
        
    }
    
    func checkAll() -> Bool
    {
        if taskTitle.text == "" {
            _ = SweetAlert().showAlert("", subTitle:  "Please enter task title".localizeString(string: lang), style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return false
        }else if teamMember.text == "Team Members".localizeString(string: lang){
            _ = SweetAlert().showAlert("", subTitle:  "Please enter task member".localizeString(string: lang), style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return false
        }else if selectDateTime.text == ""{
            _ = SweetAlert().showAlert("", subTitle:  "Please select date time for task".localizeString(string: lang), style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return false
        }else if selectDueDate.text == ""{
            _ = SweetAlert().showAlert("", subTitle:  "Please select due date time for task".localizeString(string: lang), style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return false
        }else if selectTimeZone.text == ""{
            _ = SweetAlert().showAlert("", subTitle:  "Please select timezone for task".localizeString(string: lang), style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return false
        }else if selectProject.text == "Project".localizeString(string: lang) {
            _ = SweetAlert().showAlert("", subTitle:  "Please select project for task", style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return false
        }else if selectWatcher.text == ""{
            _ = SweetAlert().showAlert("", subTitle:  "Please select taskwatcher/manager for task".localizeString(string: lang), style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return false
        }else{
            return true
        }
    }
    
    
    
    @objc func disconnectPaxiSocket(_ notification: Notification) {
        if let savedData = UserDefaults.standard.data(forKey: "selections") {
            do {
                let decodedSelections = try JSONDecoder().decode([selectionDetails].self, from: savedData)
                print("Retrieved selections: \(decodedSelections)")
                selections = decodedSelections
            } catch {
                print("Error decoding selections: \(error.localizedDescription)")
            }
        }
        if selections.count > 0{
            print(selections[0].timezone_name)
            if selections[0].type == "Member"{
                teamMember.text = selections[0].member_name
                teamMember.textColor = .black
                memberId = selections[0].member_id
            }else if selections[0].type == "Watcher"{
                selectWatcher.text = selections[0].watcher_name
                watcherId = selections[0].watcher_id
            }else if selections[0].type == "Project"{
                selectProject.textColor = .black
                selectProject.text = selections[0].project_name
                location = selections[0].location
                projectId = selections[0].project_id
            }else if selections[0].type == "TimeZone"{
//                selectTimeZone.text = selections[0].timezone_name
            }else{
                
            }
            //            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("disconnectPaxiSockets"), object: nil)
        }
    }
    
    func showTextFieldAlert() {
        self.view.endEditing(true)
        // Create the UIAlertController
        let alertController = UIAlertController(title: "Add CheckList".localizeString(string: lang), message: "You can create check list for this task from hereand if you want to check/uncheck the check list item, you can do from task detail screen".localizeString(string: lang), preferredStyle: .alert)
        
        // Add a text field to the alert
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Checklist".localizeString(string: lang)
        }
        
        // Add the buttons
        let cancelButton = UIAlertAction(title: "Cancel".localizeString(string: lang), style: .cancel) { (action) in
            // Handle cancel button action
            print("Cancel button tapped")
        }
        
        let submitButton = UIAlertAction(title: "Add".localizeString(string: lang), style: .default) { (action) in
            // Get the text entered in the text field
            if let textField = alertController.textFields?.first, let enteredText = textField.text {
                // Handle submit button action with entered text
                print("Submit button tapped with text: \(enteredText)")
                self.checkLists.removeAll()
                self.checkListData.append(createCheckList.init(id: 0, title: enteredText, status: 0))
                self.view.endEditing(true)
                self.dismiss(animated: true)
                self.createTaskTV.delegate = self
                self.createTaskTV.dataSource = self
                self.createTaskTV.reloadData()
            }
        }
        
        // Add the buttons to the alert
        alertController.addAction(cancelButton)
        alertController.addAction(submitButton)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    
    
    func selectTime(set: UITextField)
    {
        
        self.topView.isHidden = false
        
        datePicker = UIDatePicker()
        // Configure date picker
        datePicker.datePickerMode = .dateAndTime
        if called == "Show" {
            if set == selectDueDate {
                datePicker.minimumDate = Date()
            }else{
                datePicker.maximumDate = Date()
            }
        }else{
            datePicker.minimumDate = Date()
        }
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        // Add date picker to container view
        topView.addSubview(datePicker)
        // Add container view to main vie
        topView.translatesAutoresizingMaskIntoConstraints = false
        // Add constraints for the date picker
        datePicker.translatesAutoresizingMaskIntoConstraints = false
//        datePicker.removeFromSuperview()
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: -20.0)
        ])
        
        
    }
    
    
    @objc func datePickerValueChanged() {
//        let selectedDate = datePicker.date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "d MMM yyyy hh:mm a"
//        let formattedDate = dateFormatter.string(from: selectedDate)
//        if tye == "selectDateTime"{
//            selectDateTime.text = formattedDate
//        }else{
//            selectDueDate.text = formattedDate
//        }
//        //        set.text = formattedDate
//        
//        let dateFormatter1 = DateFormatter()
//        dateFormatter1.dateFormat = "yyyy-MM-dd hh:mm a"
//        let formattedDate1 = dateFormatter1.string(from: selectedDate)
//        if tye == "selectDateTime"{
//            self.startDate = formattedDate1
//        }else{
//            self.dueDate = formattedDate1
//        }
        
    }
    
}
//MARK: UITextField Delegate
extension CreateTaskAdminVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == selectTimeZone{
//            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectionVC") as? SelectionVC{
//                if let presentationController = VC.presentationController as? UISheetPresentationController {
//                    presentationController.detents = [.large()]
//                }
//                VC.calledType = "TimeZone"
//                self.present(VC, animated: true)
//            }
        }else if textField == selectProject {
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectionVC") as? SelectionVC{
                if let presentationController = VC.presentationController as? UISheetPresentationController {
                    presentationController.detents = [.large()]
                }
                VC.calledType = "Project"
                self.present(VC, animated: true)
            }
            
        }else if textField == teamMember {
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectionVC") as? SelectionVC{
                if let presentationController = VC.presentationController as? UISheetPresentationController {
                    presentationController.detents = [.large()]
                }
                VC.calledType = "Member"
                self.present(VC, animated: true)
            }
        }else if textField == selectWatcher {
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectionVC") as? SelectionVC{
                if let presentationController = VC.presentationController as? UISheetPresentationController {
                    presentationController.detents = [.large()]
                }
                VC.calledType = "Watcher"
                self.present(VC, animated: true)
            }
        }else if textField == selectDateTime{
            tye = "selectDateTime"
            if topView.isHidden == true{
                selectTime(set: selectDateTime)
            }
        }else if textField == selectDueDate{
            tye = "selectDueDate"
            if topView.isHidden == true{
                selectTime(set: selectDueDate)
            }
           
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

}
//MARK: API Integartion
extension CreateTaskAdminVC {
    
    //MARK: Add Task API
    func addTask(title: String, members_id: String, task_watcher: String, start_date_time: String, due_date_time: String, time_zone: String,location: String, project_id: Int, latitude: String, longitude: String, checklist: [String])
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/add_task"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        let combinedString = checkLists.joined(separator: ", ")
        param = ["title": title, "members_id": members_id, "task_watcher": task_watcher, "start_date_time": start_date_time, "due_date_time": due_date_time, "time_zone": time_zone,"location": location, "project_id": project_id, "latitude": latitude, "longitude": longitude, "checklist": combinedString]
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
                           let _ = try? JSONDecoder().decode(AddAdminTasks.self, from: jsonData) {
                            
                            progressHUD.hide()
                            _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.success,buttonTitle:"OK".localizeString(string: lang)){ (isOtherButton) -> Void in
                                if isOtherButton == true {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                            
                            
                            //                            _ = SweetAlert().showAlert("", subTitle: (dict["message"] as? String ?? "") + "Do you want to add notes for this task ?", style:  AlertStyle.success, buttonTitle: "YES", buttonColor: UIColor.init(hexString: "004080"), otherButtonTitle: "NO", action: { isOtherButton in
                            //
                            //                                if isOtherButton {
                            //                                    // NO button tapped
                            //                                    print("NO button tapped")
                            //                                    self.navigationController?.popViewController(animated: true)
                            //                                } else {
                            //                                    // YES button tapped
                            //                                    print("YES button tapped")
                            //                                    if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNotesVC") as? AddNotesVC{
                            //                                        VC.calledType = ""
                            //                                        VC.task_id = loginResponse.task.taskId
                            //                                        self.navigationController?.pushViewController(VC, animated: true)
                            //                                    }
                            //                                }
                            //                            })
                            
                            
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
    
    //MARK: Get Task API
    func getTask()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
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
                            self.teamMember.text = loginResponse.task.memberName
                            self.teamMember.textColor = .black
                            self.selectDateTime.text = loginResponse.task.startDateTime
                            self.selectDueDate.text = loginResponse.task.dueDateTime
                            self.selectTimeZone.text = loginResponse.task.timezone
                            self.selectProject.text = loginResponse.task.projectName
                            self.selectWatcher.text = loginResponse.task.managerName
                            
                            self.memberId = loginResponse.task.memberId
                            self.watcherId = "\(loginResponse.task.managerId)"
                            self.projectId = loginResponse.task.projectId
                            self.savelat = loginResponse.task.latitude
                            self.savelng = loginResponse.task.longitude
                            self.dueDate = loginResponse.task.formateddueDateTime
                            self.startDate = loginResponse.task.formatedstartDateTime
                            self.location = loginResponse.task.location
                            //                            for i in 0..<loginResponse.task.checklist.count{
                            //                                self.checkListData.append(createCheckList.init(id: loginResponse.task.checklist[i].id, title: loginResponse.task.checklist[i].title, status: loginResponse.task.checklist[i].status))
                            //                            }
                            progressHUD.hide()
                            //                            self.createTaskTV.delegate = self
                            //                            self.createTaskTV.dataSource = self
                            //                            self.createTaskTV.reloadData()
                            
                            
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
    
    func submitCheckList(id: Int, tag: Int)
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
                            
                            self.getTask()
                            //                                print(self.checkListData[tag])
                            //                                self.checkListData.insert(createCheckList.init(id:  self.checkListData[tag].id, title:  self.checkListData[tag].title, status: 1), at: tag)
                            //                                print(self.checkListData[tag])
                            //                                self.checkListData.remove(at: tag + 1)
                            //                                self.createTaskTV.reloadData()
                            
                            
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
    
    //MARK: Edit Task API
    func editTask(title: String, members_id: String, task_watcher: String, start_date_time: String, due_date_time: String, time_zone: String,location: String, project_id: Int, latitude: String, longitude: String, checklist: [String])
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/edit_task"
        let combinedString = checkLists.joined(separator: ", ")
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["title": title, "members_id": members_id, "task_watcher": task_watcher, "start_date_time": start_date_time, "due_date_time": due_date_time, "time_zone": time_zone,"location": location, "project_id": project_id, "latitude": latitude, "longitude": longitude, "checklist": combinedString,"task_id" : taskId]
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
                            _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.success,buttonTitle:"OK".localizeString(string: lang)){ (isOtherButton) -> Void in
                                if isOtherButton == true {
                                    self.navigationController?.popViewController(animated: true)
                                }
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
                        if self.called == "Show"{
                            _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
                        }
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
    
    
    //MARK: Get Project API to create Task Admin
    func getProject()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
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
                            self.selectProject.text = loginResponse.projects[0].projectName + " - " + loginResponse.projects[0].location
                            self.selectProject.textColor = UIColor.black
                            self.projectId = loginResponse.projects[0].id
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
    
    //MARK: Get Profile API
    func getProfile()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/get_profile"
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
                           let loginResponse = try? JSONDecoder().decode(ProfileInfo.self, from: jsonData) {
                            
                            self.selectWatcher.text = loginResponse.data.fullname + "(Task Watcher)"
                            
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

//MARK: TableView Delegate
extension CreateTaskAdminVC: UITableViewDelegate, UITableViewDataSource{
    
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
        checkLists.append(checkListData[indexPath.row].title)
        if called == "Show"{
            cell.topButton.isHidden = false
        }else{
            cell.topButton.isHidden = true
        }
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
        self.checkListData.remove(at: tag)
        self.createTaskTV.reloadData()
    }
    
    @objc func selectBtnTap(_ sender: UIButton){
        let tag = sender.tag
        submitCheckList(id: checkListData[tag].id, tag: tag)
    }
}

extension CreateTaskAdminVC: UITextViewDelegate{
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print(textView)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == teamMember{
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectionVC") as? SelectionVC{
                if let presentationController = VC.presentationController as? UISheetPresentationController {
                    presentationController.detents = [.large()]
                }
                VC.calledType = "Member"
                self.present(VC, animated: true)
            }
        }else{
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectionVC") as? SelectionVC{
                if let presentationController = VC.presentationController as? UISheetPresentationController {
                    presentationController.detents = [.large()]
                }
                VC.calledType = "Project"
                self.present(VC, animated: true)
            }
        }
    }
}
