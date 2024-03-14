//
//  ShowTaskListVC.swift
//  Cleansing
//
//  Created by United It Services on 27/10/23.
//

import UIKit
import Alamofire
class ShowTaskListVC: UIViewController {
    
    @IBOutlet weak var showTaskCardTV: UITableView!
    //    @IBOutlet weak var hourMinuteLabel: UILabel!
    @IBOutlet weak var organizationName: UIButton!
    @IBOutlet weak var timeAprover: UIButton!
    @IBOutlet weak var projectSelect: UIButton!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var finishTime: UITextField!
    @IBOutlet weak var addBreak: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var projectSV: UIStackView!
    @IBOutlet weak var startSV: UIStackView!
    @IBOutlet weak var finishSV: UIStackView!
    
    //Popup
    @IBOutlet weak var approverOrganizationView: UIView!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var approvOrganizTV: UITableView!
    
    @IBOutlet weak var orgLabel: UILabel!
    @IBOutlet weak var approverLabel: UILabel!
    @IBOutlet weak var projLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var finishLabel: UILabel!
    @IBOutlet weak var breakLabel: UILabel!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var subBtn: UIButton!
    @IBOutlet weak var canBtn: UIButton!
    
    var status:Int = 0
    var breaks = [showBreakDetails]()
    var showA = [showCADetails]()
    var selectedRow: Int?
    var breakss: [String] = []
    var taskID: Int = 0
    var timecard_id:Int = 0
    var projectID: Int = 0
    //Date Picker
    let datePicker: UIDatePicker? = UIDatePicker()
    var startype: String = ""
    var startTimes: Date?
    var finishTimes: Date?
    var coun: Bool = false
    var breakStart: String = ""
    var breakEnd: String = ""
    var cbreakStart: String = "00:00"
    var cbreakEnd: String = "00:00"
    var manager_id: String = ""
    var projectType: Int = 0
    var timecard_type:Int = 0
    var datePickers = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        showTaskCardTV.tag = 100
        approvOrganizTV.tag = 101
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    
    
    @IBAction func organizationBtnTap(_ sender: UIButton) {
        
    }
    
    
    @IBAction func timeAproverBtnTap(_ sender: UIButton) {
        if projectType == 2{
            _ = SweetAlert().showAlert("", subTitle:  "Approved time cards cannot be edited".localizeString(string: lang), style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
        }else{
//            approverOrganizationView.isHidden = false
//            selectLabel.text = "Select a time approver"
//            showA.removeAll()
//            getManager()
        }
    }
    
    
    @IBAction func projectBtnTap(_ sender: UIButton) {
        if projectType == 2{
            _ = SweetAlert().showAlert("", subTitle:  "Approved time cards cannot be edited".localizeString(string: lang), style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
            
        }else{
            //            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectProjectVC") as? SelectProjectVC{
            //                self.navigationController?.pushViewController(VC, animated: true)
            //            }
            _ = SweetAlert().showAlert("", subTitle:  "Please contact admin to update your project/task.".localizeString(string: lang), style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
            
        }
    }
    
    @IBAction func addBreakBtnTap(_ sender: UIButton) {
        if projectType == 2{
            _ = SweetAlert().showAlert("", subTitle:  "Approved time cards cannot be edited".localizeString(string: lang), style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
        }else{
            if breaks.count < 1{
                self.breaks.append(showBreakDetails(id: 0 , startDate: "00:00", endDate: "00:00", duration: ""))
                showTaskCardTV.reloadData()
            }else{
                if breakStart != "" && breakEnd != "" {
                    breakStart = ""
                    breakEnd = ""
                    self.breaks.append(showBreakDetails(id: 0 , startDate: "00:00", endDate: "00:00", duration: ""))
                    showTaskCardTV.reloadData()
                }
            }
        }
            
    }
    
    
    @IBAction func cancelBtnTap(_ sender: UIButton) {
        timeAprover.setTitle("Select Approver".localizeString(string: lang), for: .normal)
        approverOrganizationView.isHidden = true
    }
    
    @IBAction func selectBtnTap(_ sender: UIButton) {
        approverOrganizationView.isHidden = true
    }
    
    @IBAction func addBtnTap(_ sender: UIButton) {
        if projectType == 2{
            sender.isUserInteractionEnabled = false
        }else{
            saveTimeCard(startTime: self.startTime.text ?? "", finishTime: self.finishTime.text ?? "", project_id: projectID, task_id: taskID, breaks: [""], timecard_id: timecard_id)
        }
    }
    
    
    @IBAction func submitBtnsTap(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy hh:mm a"//"yyyy-MM-dd hh:mm a" // Customize the format to "Wed, 25 Oct 12:44"
        if startype == "Start"{
            startTime.text = dateFormatter.string(from: datePickers.date)
            startTimes = datePickers.date
        }else{
            finishTime.text = dateFormatter.string(from: datePickers.date)
            finishTimes = datePickers.date
            
        }
        self.dateView.isHidden = true
        self.datePickers.removeFromSuperview()
        updateTimer()
    }
    
    @IBAction func cancelBtnsTap(_ sender: UIButton) {
        self.datePickers.removeFromSuperview()
        self.dateView.isHidden = true
    }
    
    
    
}
extension ShowTaskListVC {
    
    func firstCall()
    {
        addBreak.setTitle("ADD BREAK".localizeString(string: lang), for: .normal)
        saveBtn.setTitle("Save Changes".localizeString(string: lang), for: .normal)
        organizationName.setTitle("Green Vision Cleansing".localizeString(string: lang), for: .normal)
        breakLabel.text = "BREAKS".localizeString(string: lang)
        startLabel.text = "Start".localizeString(string: lang)
        finishLabel.text = "Finish".localizeString(string: lang)
        projLabel.text = "Project".localizeString(string: lang)
        approverLabel.text = "Time Approver".localizeString(string: lang)
        projectSelect.setTitle("Select".localizeString(string: lang), for: .normal)
        orgLabel.text = "Organization".localizeString(string: lang)
        dateView.dropShadowWithBlackColor()
        subBtn.setTitle("Submit".localizeString(string: lang), for: .normal)
        canBtn.setTitle("Cancel".localizeString(string: lang), for: .normal)
        breaks.removeAll()
        breakss.removeAll()
        organizationName.setTitle("Green Vision Cleansing".localizeString(string: lang), for: .normal)
        timeAprover.setTitle("Select Approver".localizeString(string: lang), for: .normal)
        approverOrganizationView.dropShadowWithBlackColor()
        approverOrganizationView.isHidden = true
        startTime.delegate = self
        finishTime.delegate = self
        if let loadedArray = UserDefaults.standard.array(forKey: "spt") as? [Any] {
            // Use the loadedArray as needed
            projectSelect.setTitle( loadedArray[2] as? String ?? "Select".localizeString(string: lang) , for: .normal)
            projectID  = loadedArray[0] as? Int ?? 0
            taskID  = loadedArray[1] as? Int ?? 0
            print(loadedArray)
        }
        
        UserDefaults.standard.removeObject(forKey: "spt")
        saveBtn.roundedButton()
        
        //        if finishTime.text == ""{
        //            saveBtn.isHidden = true
        //            addBreak.isHidden = true
        //        }
        //        if startTime.text == ""{
        //            finishSV.isHidden = true
        //            projectSV.isHidden = true
        //        }
        getTimeCard(id: timecard_id)
    }
}


//MARK: TableView Delegate
extension ShowTaskListVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 100{
            return breaks.count
        }else{
            return showA.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 100{
            let cell = tableView.dequeueReusableCell(withIdentifier: "nbCell", for: indexPath) as! NewBreakTVC
            cell.startTime.setTitle(breaks[indexPath.row].startDate, for: .normal)
            cell.endTime.setTitle(breaks[indexPath.row].endDate, for: .normal)
            cell.startTime.tag = indexPath.row
            cell.endTime.tag = indexPath.row
            cell.deleteBtn.tag = indexPath.row
            cell.startTime.addTarget(self, action: #selector(startBtnTap(_:)), for: .touchUpInside)
            cell.endTime.addTarget(self, action: #selector(finishBtnTap(_:)), for: .touchUpInside)
            cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTap(_:)), for: .touchUpInside)
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "aoCell", for: indexPath) as! AproverOrganizationTVC
            cell.radioName.text = showA[indexPath.row].nameCA
            if indexPath.row == selectedRow {
                cell.radioBtn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            } else {
                cell.radioBtn.setImage(UIImage(systemName: "square"), for: .normal)
            }
            return cell
        }
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
        print(indexPath.row)
        if tableView.tag == 101{
            if indexPath.row == selectedRow {
                selectedRow = nil
            } else {
                selectedRow = indexPath.row
                timeAprover.setTitle(showA[selectedRow ?? 0].nameCA, for: .normal)
            }
            tableView.reloadData()
        }
        
        
    }
    @objc func deleteBtnTap(_ sender: UIButton)
    {
        //delete Break API
        if projectType == 2{
            _ = SweetAlert().showAlert("", subTitle:  "Approved time cards cannot be edited".localizeString(string: lang), style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
        }else{
            deleteBreak(id: breaks[sender.tag].id)
            breaks.remove(at: sender.tag)
        }
    }
    @objc func startBtnTap(_ sender: UIButton)
    {
        if projectType == 2{
            _ = SweetAlert().showAlert("", subTitle:  "Approved time cards cannot be edited".localizeString(string: lang), style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
        }else{
            let alertController = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
            
            // Create a date picker
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .dateAndTime
            datePicker.maximumDate = Date()
            
            // Add the date picker to the alert controller
            alertController.view.addSubview(datePicker)
            
            // Create a "Done" button
            let doneAction = UIAlertAction(title: "Done".localizeString(string: lang), style: .default) { (action) in
                let selectedDate = datePicker.date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMM yyyy hh:mm a"
                let formattedDate = dateFormatter.string(from: selectedDate)
                //                   sender.setTitle(formattedDate, for: .normal)
                self.breakStart = formattedDate
                
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "yyyy-MM-dd hh:mm a"
                let formattedDate1 = dateFormatter1.string(from: selectedDate)
                self.cbreakStart = formattedDate1
                self.breakCheck(startTime: self.startTime.text ?? "", finishTime: self.finishTime.text ?? "", break_start:  self.cbreakStart, break_end: self.cbreakEnd)
                
                //                   self.addBreakTime(breaks: self.breakss, timecard_id: self.taskID, startTime: self.startTime.text ?? "", finishTime: self.finishTime.text ?? "", break_start: self.cbreakStart, break_end: self.cbreakEnd)
                
            }
            
            // Add the "Done" button to the alert controller
            alertController.addAction(doneAction)
            
            // Create a "Cancel" button
            let cancelAction = UIAlertAction(title: "Cancel".localizeString(string: lang), style: .cancel, handler: nil)
            
            // Add the "Cancel" button to the alert controller
            alertController.addAction(cancelAction)
            
            // Present the alert controller
            present(alertController, animated: true, completion: nil)
        }
    }
    @objc func finishBtnTap(_ sender: UIButton)
    {
        if projectType == 2{
            _ = SweetAlert().showAlert("", subTitle:  "Approved time cards cannot be edited".localizeString(string: lang), style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
        }else{
            let alertController = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
            
            // Create a date picker
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .dateAndTime
            datePicker.maximumDate = Date()
            
            // Add the date picker to the alert controller
            alertController.view.addSubview(datePicker)
            
            // Create a "Done" button
            let doneAction = UIAlertAction(title: "Done".localizeString(string: lang), style: .default) { (action) in
                let selectedDate = datePicker.date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMM yyyy hh:mm a"
                let formattedDate = dateFormatter.string(from: selectedDate)
                self.breakEnd = formattedDate
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "yyyy-MM-dd hh:mm a"
                let formattedDate1 = dateFormatter1.string(from: selectedDate)
                self.cbreakEnd = formattedDate1
                //                   sender.setTitle(formattedDate, for: .normal)
                //                   self.getTaskTimer(startTime: self.startTime.text ?? "", finishTime: self.finishTime.text ?? "", break_start: self.breakStart, break_end: formattedDate1)
                self.breakCheck(startTime: self.startTime.text ?? "", finishTime: self.finishTime.text ?? "", break_start:  self.cbreakStart, break_end: self.cbreakEnd)
                
                //                   self.addBreakTime(breaks: filteredArray, timecard_id: self.taskID, startTime: self.startTime.text ?? "", finishTime: self.finishTime.text ?? "", break_start: self.cbreakStart, break_end: self.cbreakEnd)
                self.cbreakEnd = "00:00"
            }
            
            // Add the "Done" button to the alert controller
            alertController.addAction(doneAction)
            
            // Create a "Cancel" button
            let cancelAction = UIAlertAction(title: "Cancel".localizeString(string: lang), style: .cancel, handler: nil)
            
            // Add the "Cancel" button to the alert controller
            alertController.addAction(cancelAction)
            
            // Present the alert controller
            present(alertController, animated: true, completion: nil)
        }
    }
}
//MARK: API Integration
extension ShowTaskListVC {
    
    //MARK: Break Check API
    func breakCheck(startTime : String, finishTime: String, break_start: String, break_end: String)
    {
        var breaking: String = ""
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let url = "\(ApiLink.HOST_URL)/timecard_break_check"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd hh:mm a" // Customize the format to "Wed, 25 Oct 12:44"
        let formattedDate1 = dateFormatter1.string(from: startTimes ?? Date())
        let formattedDate2 = dateFormatter1.string(from: finishTimes ?? Date())
        
        print("Access Token: \(accessToken)")
        var param: Parameters = ["":""]
        if break_end == "00:00"{
            breaking = ""
        }else{
            breaking = break_end
        }
        param = ["start_time": formattedDate1, "end_time": formattedDate2, "break_start": break_start, "break_end": breaking]
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
                           let loginResponse = try? JSONDecoder().decode(GetTotalTaskInfo.self, from: jsonData) {
                            
                            if break_end != "" && break_end != "00:00"{
                                self.breaks.removeLast()
                                //                                let bs = self.addLineBreaks(text: break_start)
                                //                                let be = self.addLineBreaks(text: break_end)
                                self.coun = true
                                self.breaks.append(showBreakDetails(id: 0 , startDate: self.breakStart, endDate: self.breakEnd, duration: ""))
                                self.breakss.append(break_start + " to " + break_end)
                                self.addBreakTime(breaks: self.breakss, timecard_id: self.timecard_id)
                                
                            }else if break_start != ""{
                                if(self.breaks.count > 0){
                                    self.breaks.removeLast()
                                }
                                let bs = self.addLineBreaks(text: break_start)
                                self.breaks.append(showBreakDetails(id: 0 , startDate: bs, endDate: "00:00", duration: ""))
                                self.showTaskCardTV.reloadData()
                                
                            }
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
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
                    }else if self.status == 201{
                        progressHUD.hide()
                        
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
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
    
    
    //MARK: Save Time Card Changes
    func saveTimeCard(startTime : String, finishTime: String, project_id: Int, task_id: Int, breaks: [String], timecard_id: Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let url = "\(ApiLink.HOST_URL)/edit_time_card"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd hh:mm a" // Customize the format to "Wed, 25 Oct 12:44"
        let formattedDate1 = dateFormatter1.string(from: startTimes ?? Date())
        let formattedDate2 = dateFormatter1.string(from: finishTimes ?? Date())
        
        print("Access Token: \(accessToken)")
        var param: Parameters = ["":""]
        param = ["start_time": formattedDate1, "end_time": formattedDate2, "project_id": project_id, "task_id": task_id, "breaks": "", "work_id": timecard_id]
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
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
                    }else if self.status == 201{
                        progressHUD.hide()
                        
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
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
    
    
    //MARK: Get Time Card
    func getTimeCard(id : Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let url = "\(ApiLink.HOST_URL)/timecard_detail"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        
        print("Access Token: \(accessToken)")
        var param: Parameters = ["":""]
        param = ["timecard_id": id]
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
                           let loginResponse = try? JSONDecoder().decode(TimeCardDetailsInfo.self, from: jsonData) {
                            self.coun = false
                            self.projectSelect.setTitle(loginResponse.timeCards[0].task_name, for: .normal)
                            self.startTime.text = loginResponse.timeCards[0].start_time
                            self.finishTime.text = loginResponse.timeCards[0].end_time
                            self.projectType = loginResponse.timeCards[0].approve
                            self.timecard_type = loginResponse.timeCards[0].timecard_type
                            if loginResponse.timeCards[0].timecard_type == 1 && loginResponse.timeCards[0].approve == 0{
                                self.saveBtn.isHidden = true
                            }
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "E, d MMM yyyy hh:mm a"
                            if let date = dateFormatter.date(from: self.startTime.text ?? "") {
                                print(date)
                                self.startTimes = date
                            } else {
                                print("Date parsing failed")
                            }
                            if let date = dateFormatter.date(from: self.finishTime.text ?? "") {
                                print(date)
                                self.finishTimes = date
                            } else {
                                print("Date parsing failed")
                            }
                            if self.projectType == 2{
                                self.saveBtn.isHidden = true
                            }
                            self.timeAprover.setTitle(loginResponse.timeCards[0].manager_name, for: .normal)
                            self.manager_id = "\(loginResponse.timeCards[0].manager_id)"
                            self.breakss.removeAll()
                            self.breaks.removeAll()
                            for i in 0..<loginResponse.timeCards[0].break.count{
                                self.breaks.append(showBreakDetails(id: loginResponse.timeCards[0].break[i].id , startDate: loginResponse.timeCards[0].break[i].start_date_time, endDate: loginResponse.timeCards[0].break[i].end_date_time, duration: ""))
                                //                                self.breakss.append(loginResponse.timeCards[0].break[i].start_date_time + " to " + loginResponse.timeCards[0].break[i].end_date_time)
                                self.breakStart = loginResponse.timeCards[0].break[i].start_date_time
                                self.breakEnd = loginResponse.timeCards[0].break[i].end_date_time
                                self.taskID = loginResponse.timeCards[0].task_id
                                self.projectID = loginResponse.timeCards[0].project_id
                            }
                            
                            self.showTaskCardTV.delegate = self
                            self.showTaskCardTV.dataSource = self
                            self.showTaskCardTV.reloadData()
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
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
                    }else if self.status == 201{
                        progressHUD.hide()
                        
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
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
    
    //MARK: Delete Break
    func deleteBreak(id : Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let url = "\(ApiLink.HOST_URL)/delete_timecard_break"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        
        print("Access Token: \(accessToken)")
        var param: Parameters = ["":""]
        param = ["break_id": id]
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
                            self.getTimeCard(id: self.timecard_id)
                            
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
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
                    }else if self.status == 201{
                        progressHUD.hide()
                        
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
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
    
    //MARK: Add Break Time
    func addBreakTime(breaks : [String], timecard_id: Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let url = "\(ApiLink.HOST_URL)/add_timecard_break"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        
        print("Access Token: \(accessToken)")
        var param: Parameters = ["":""]
        let combinedString = breaks.joined(separator: ", ")
        param = ["breaks": combinedString, "timecard_id": timecard_id]
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
                           let loginResponse = try? JSONDecoder().decode(BreakResponse.self, from: jsonData) {
                            
                            progressHUD.hide()
                            self.getTimeCard(id: timecard_id)
                            //                            self.showTaskCardTV.reloadData()
                            //                            self.projectSelect.setTitle(loginResponse.timeCards[0].task_name, for: .normal)
                            //                            self.startTime.text = loginResponse.timeCards[0].start_time
                            //                            self.finishTime.text = loginResponse.timeCards[0].end_time
                            //                            let dateFormatter = DateFormatter()
                            //                            dateFormatter.dateFormat = "E, d MMM yyyy hh:mm a"
                            //                            if let date = dateFormatter.date(from: self.startTime.text ?? "") {
                            //                                print(date)
                            //                                self.startTimes = date
                            //                            } else {
                            //                                print("Date parsing failed")
                            //                            }
                            //                            if let date = dateFormatter.date(from: self.finishTime.text ?? "") {
                            //                                print(date)
                            //                                self.finishTimes = date
                            //                            } else {
                            //                                print("Date parsing failed")
                            //                            }
                            //                            self.breaks.removeAll()
                            //                            for i in 0..<loginResponse.timeCards[0].break.count{
                            //                                self.breaks.append(showBreakDetails(id: loginResponse.timeCards[0].break[i].id , startDate: loginResponse.timeCards[0].break[i].start_date_time, endDate: loginResponse.timeCards[0].break[i].end_date_time, duration: ""))
                            //                            }
                            //                            self.showTaskCardTV.delegate = self
                            //                            self.showTaskCardTV.dataSource = self
                            //                            self.showTaskCardTV.reloadData()
                            //                            progressHUD.hide()
                            
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
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
                    }else if self.status == 201{
                        progressHUD.hide()
                        
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
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
    
    //MARK: Get Manager API to create TimeCard Admin
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
                            
                            progressHUD.hide()
                            self.showA.removeAll()
                            for i in 0..<loginResponse.manager.count{
                                self.showA.append(showCADetails.init(isSelected: false, nameCA: loginResponse.manager[i].fullname, idCA: loginResponse.manager[i].id))
                            }
                            self.approvOrganizTV.delegate = self
                            self.approvOrganizTV.dataSource = self
                            self.approvOrganizTV.reloadData()
                            
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
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
                    }else if self.status == 201{
                        progressHUD.hide()
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
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
    
    
    func addLineBreaks(text: String) -> String {
        var result = ""
        var currentLineLength = 0
        
        for (index, character) in text.enumerated() {
            result.append(character)
            currentLineLength += 1
            if currentLineLength >= 11 && character == " " {
                result.append("\n")
                currentLineLength = 0
            }
        }
        return result
    }
}
extension ShowTaskListVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == startTime{
            startype = "Start"
        }else{
            startype = "Finish"
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if projectType == 2{
                 _ = SweetAlert().showAlert("", subTitle:  "Approved time cards cannot be edited".localizeString(string: lang), style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
        }else{
            // Create and configure the date picker
            if dateView.isHidden == true{
                textField.inputView = UIView()
                textField.tintColor = UIColor.white
                self.dateView.isHidden = false
                self.dateView.isHidden = false
                datePickers = UIDatePicker()
                // Configure date picker
                datePickers.datePickerMode = .dateAndTime
                datePickers.maximumDate = Date()
                datePickers.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
                dateView.addSubview(datePickers)
                dateView.translatesAutoresizingMaskIntoConstraints = false
                datePickers.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    datePickers.centerXAnchor.constraint(equalTo: dateView.centerXAnchor),
                    datePickers.centerYAnchor.constraint(equalTo: dateView.centerYAnchor, constant: -20.0)
                ])
            }
            return true
        }
        return false
    }
@objc func datePickerValueChanged(_ sender: UIDatePicker) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "E, d MMM yyyy hh:mm a"//"yyyy-MM-dd hh:mm a" // Customize the format to "Wed, 25 Oct 12:44"
//        if startype == "Start"{
//            startTime.text = dateFormatter.string(from: sender.date)
//            startTimes = sender.date
//        }else{
//            finishTime.text = dateFormatter.string(from: sender.date)
//            finishTimes = sender.date
//
//        }
}
    
    
    @objc func doneButtonTapped() {
        if startype == "Start"{
            startTime.resignFirstResponder() // Close the date picker
        }else{
            finishTime.resignFirstResponder() // Close the date picker
        }
        updateTimer()
    }
    
    //MARK: Update Timer of Task
    func updateTimer() {
        if let startTime = startTimes, let finishTime = finishTimes {
            
            let elapsedTime = finishTime.timeIntervalSince(startTime)
            
            let hours = Int(elapsedTime / 3600)
            let minutes = Int((elapsedTime / 60).truncatingRemainder(dividingBy: 60))
            let seconds = Int(elapsedTime.truncatingRemainder(dividingBy: 60))
            
            let hourString = String(format: "%02d", hours)
            let minuteString = String(format: "%02d", minutes)
            let secondString = String(format: "%02d", seconds)
            
            //            if hours > 0 {
            //                hourMinuteLabel.text = "\(hourString)H \(minuteString)M"
            //            } else if minutes > 0 {
            //                hourMinuteLabel.text = "\(minuteString)M \(secondString)S"
            //            } else {
            //                hourMinuteLabel.text = "\(secondString)S"
            //            }
            
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // Check if the start date is greater than the finish date
        if textField == startTime {
            if let startDate = startTimes, let finishDate = finishTimes {
                if startDate > finishDate {
                    _ = SweetAlert().showAlert("", subTitle: "The finish time should be greater than start time".localizeString(string: lang), style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
                    self.finishTime.text = ""
                    
                }
            }
        } else if textField == finishTime {
            if let finishDate = finishTimes, let startDate = startTimes {
                if finishDate < startDate {
                    _ = SweetAlert().showAlert("", subTitle: "The finish time should be greater than start time".localizeString(string: lang), style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
                    self.finishTime.text = ""
                    
                }
            }
        }
        return true
    }
}
