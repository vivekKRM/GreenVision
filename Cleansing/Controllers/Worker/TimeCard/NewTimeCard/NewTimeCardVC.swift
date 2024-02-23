//
//  NewTimeCardVC.swift
//  Cleansing
//
//  Created by United It Services on 25/10/23.
//

import UIKit
import Alamofire
class NewTimeCardVC: UIViewController {
    
    @IBOutlet weak var newTimeCardTV: UITableView!
    @IBOutlet weak var hourMinuteLabel: UILabel!
    @IBOutlet weak var organizationName: UIButton!
    @IBOutlet weak var timeAprover: UIButton!
    @IBOutlet weak var projectSelect: UIButton!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var finishTime: UITextField!
    @IBOutlet weak var addBreak: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var projectSV: UIStackView!
    @IBOutlet weak var startSV: UIStackView!
    @IBOutlet weak var finishSV: UIStackView!
    //Popup
    @IBOutlet weak var approverOrganizationView: UIView!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var approvOrganizTV: UITableView!

    @IBOutlet weak var orgLabel: UILabel!
    @IBOutlet weak var approverLabel: UILabel!
    @IBOutlet weak var projLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var finishLabel: UILabel!
    @IBOutlet weak var breakLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var subBtn: UIButton!
    @IBOutlet weak var canBtn: UIButton!
    
    var taskID: Int = 0
    var projectID: Int = 0
    //Date Picker
    var startype: String = ""
    var startTimes: Date?
    var finishTimes: Date?
    var managerId: String = ""
    var status:Int = 0
    var breaks = [showBreakDetails]()
    var showA = [showCADetails]()
    var selectedRow: Int?
    var datePickers = UIDatePicker()
    var breaksData = [("Break Start 1".localizeString(string: lang), "Break End 1".localizeString(string: lang))]
    override func viewDidLoad() {
        super.viewDidLoad()
        organizationName.setTitle("Green Vision Cleansing".localizeString(string: lang), for: .normal)
        timeAprover.setTitle("Time Approver".localizeString(string: lang), for: .normal)
        newTimeCardTV.tag = 100
        approvOrganizTV.tag = 101
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    
    
    @IBAction func organizationBtnTap(_ sender: UIButton) {
        
    }
    
    
    @IBAction func timeAproverBtnTap(_ sender: UIButton) {
        //        approverOrganizationView.isHidden = false
        //        selectLabel.text = "Select a time approver"
        //        showA.removeAll()
        //        getManager()
    }
    
    
    @IBAction func projectBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectProjectVC") as? SelectProjectVC{
            VC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func addBreakBtnTap(_ sender: UIButton) {
        if breaks.count < 1{
            self.breaks.append(showBreakDetails(id: 0 , startDate: "00:00", endDate: "00:00", duration: ""))
            newTimeCardTV.delegate = self
            newTimeCardTV.dataSource = self
            newTimeCardTV.reloadData()
        }else{
            let breakNumber = breaksData.count + 1
            let newBreak = ("Break Start ".localizeString(string: lang) + "\(breakNumber)", "Break End ".localizeString(string: lang) + "\(breakNumber)")
            breaksData.append(newBreak)
            // Update the table view with the new row
            newTimeCardTV.beginUpdates()
            let newIndexPath = IndexPath(row: breaksData.count - 1, section: 0)
            newTimeCardTV.insertRows(at: [newIndexPath], with: .automatic)
            newTimeCardTV.endUpdates()
            // Automatically show date picker for the new break when it is added
            showDatePicker(for: .breakStart, at: newIndexPath)
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
        print(breaksData)
        
        let formattedBreaks = breaksData.map { breakTuple in
            let inputDateFormat = DateFormatter()
            inputDateFormat.dateFormat = "d MMM yyyy hh:mm a"
            inputDateFormat.locale = Locale(identifier: "en_US_POSIX")
            
            let outputDateFormat = DateFormatter()
            outputDateFormat.dateFormat = "yyyy-MM-dd hh:mm a"

            if let breakStartDate = inputDateFormat.date(from: breakTuple.0),
               let breakEndDate = inputDateFormat.date(from: breakTuple.1) {
                let formattedBreak = "\(outputDateFormat.string(from: breakStartDate)) to \(outputDateFormat.string(from: breakEndDate))"
                return formattedBreak
            } else {
                return "Invalid Date"
            }
        }

        print(formattedBreaks)
        addTimeCard(startTime: self.startTime.text ?? "", finishTime: self.finishTime.text ?? "", project_id: projectID, task_id: taskID, breaks: formattedBreaks)
    }
    
    
    @IBAction func submitBtnsTap(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy hh:mm a"//"yyyy-MM-dd hh:mm a" // Customize the format to "Wed, 25 Oct 12:44"
        if startype == "Start"{
            startTime.text = dateFormatter.string(from: datePickers.date)
            startTimes = datePickers.date
            breaks.removeAll()
            breaksData.removeAll()
            newTimeCardTV.reloadData()
            finishSV.isHidden = false
            startTime.resignFirstResponder() // Close the date picker
        }else{
            finishTime.text = dateFormatter.string(from: datePickers.date)
            finishTimes = datePickers.date
            breaks.removeAll()
            breaksData.removeAll()
            newTimeCardTV.reloadData()
            addBtn.isHidden = false
            addBreak.isHidden = false
            finishTime.resignFirstResponder() // Close the date picker
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
extension NewTimeCardVC {
    
    func firstCall()
    {
        noteLabel.text = "Time cards can not be created with future dates or times.".localizeString(string: lang)
        addBreak.setTitle("ADD BREAK".localizeString(string: lang), for: .normal)
        dateView.dropShadowWithBlackColor()
        organizationName.titleLabel?.numberOfLines = 0
        timeAprover.titleLabel?.numberOfLines = 0
        subBtn.setTitle("Submit".localizeString(string: lang), for: .normal)
        canBtn.setTitle("Cancel".localizeString(string: lang), for: .normal)
        addBtn.setTitle("ADD".localizeString(string: lang), for: .normal)
        breakLabel.text = "BREAKS".localizeString(string: lang)
        startLabel.text = "Start".localizeString(string: lang)
        finishLabel.text = "Finish".localizeString(string: lang)
        projLabel.text = "Project".localizeString(string: lang)
        approverLabel.text = "Time Approver".localizeString(string: lang)
        projectSelect.setTitle("Select".localizeString(string: lang), for: .normal)
        orgLabel.text = "Organization".localizeString(string: lang)
        breaks.removeAll()
        approverOrganizationView.dropShadowWithBlackColor()
        approverOrganizationView.isHidden = true
        startTime.delegate = self
        finishTime.delegate = self
        if let loadedArray = UserDefaults.standard.array(forKey: "spt") as? [Any] {
            // Use the loadedArray as needed
            projectSelect.setTitle( loadedArray[2] as? String ?? "Select" , for: .normal)
            projectID  = loadedArray[0] as? Int ?? 0
            taskID  = loadedArray[1] as? Int ?? 0
            managerId = loadedArray[3] as? String ?? ""
            timeAprover.setTitle(loadedArray[4] as? String ?? "", for: .normal)
            print(loadedArray)
        }
        
        UserDefaults.standard.removeObject(forKey: "spt")
        addBtn.roundedButton()
        
        if finishTime.text == ""{
            addBtn.isHidden = true
            addBreak.isHidden = true
        }
        if startTime.text == ""{
            finishSV.isHidden = true
        }
        
    }
}


//MARK: TableView Delegate
extension NewTimeCardVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 100{
            return breaksData.count
        }else{
            return showA.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 100{
            let cell = tableView.dequeueReusableCell(withIdentifier: "nbCell", for: indexPath) as! NewBreakTVC
            let breakInfo = breaksData[indexPath.row]
            cell.startTime.setTitle(breakInfo.0, for: .normal)
            cell.endTime.setTitle(breakInfo.1, for: .normal)
            
            cell.onBreakStartTapped = { [weak self] in
                self?.showDatePicker(for: .breakStart, at: indexPath)
            }
            
            cell.onBreakEndTapped = { [weak self] in
                self?.showDatePicker(for: .breakEnd, at: indexPath)
            }
            
            cell.onDeleteButtonTapped = { [weak self] in
                self?.deleteBreak(at: indexPath)
            }
            
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
                managerId = "\(showA[selectedRow ?? 0].idCA)"
            }
            tableView.reloadData()
        }
    }
    
    func showDatePicker(for type: DatePickerType, at indexPath: IndexPath) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.maximumDate = Date()
        let alertController = UIAlertController(title: "".localizeString(string: lang), message: nil, preferredStyle: .actionSheet)
        alertController.view.addSubview(datePicker)
        
        let doneAction = UIAlertAction(title: "Done".localizeString(string: lang), style: .default) { [weak self] _ in
            self?.handleDatePickerSelection(datePicker.date, for: type, at: indexPath)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localizeString(string: lang), style: .cancel, handler: nil)
        
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func handleDatePickerSelection(_ selectedDate: Date, for type: DatePickerType, at indexPath: IndexPath) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy hh:mm a"
        let dateString = dateFormatter.string(from: selectedDate)
        if type == .breakStart {
            breaksData[indexPath.row].0 = dateString
        } else if type == .breakEnd {
            breaksData[indexPath.row].1 = dateString
        }
        if breaksData[indexPath.row].1 != "Break End ".localizeString(string: lang) + "\(indexPath.row + 1)"{
            self.getTaskTimer(startTime: self.startTime.text ?? "", finishTime: self.finishTime.text ?? "", break_start: breaksData[indexPath.row].0, break_end: breaksData[indexPath.row].1, index: indexPath)
        }else{
            self.newTimeCardTV.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    enum DatePickerType {
        case breakStart
        case breakEnd
    }
    
    func deleteBreak(at indexPath: IndexPath) {
        if breaksData.count < 1{
        }else{
            breaksData.remove(at: indexPath.row)
            newTimeCardTV.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
//MARK: API Integration
extension NewTimeCardVC {
    
    //MARK: Check Break API
    func getTaskTimer(startTime : String, finishTime: String, break_start: String, break_end: String, index: IndexPath)
    {
        var formattedDate1 = ""
        var formattedDate2 = ""
        var formattedDate3 = ""
        var formattedDate4 = ""
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
        if startTimes == nil{
            formattedDate1 = ""
        }else{
            formattedDate1 = dateFormatter1.string(from: startTimes ?? Date())
        }
        if finishTimes == nil{
            formattedDate2 = ""
        }else{
            formattedDate2 = dateFormatter1.string(from: finishTimes ?? Date())
        }
        
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        inputDateFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let inputDate = inputDateFormatter.date(from: break_start) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
            
             formattedDate3 = outputDateFormatter.string(from: inputDate)
            
            print(formattedDate3)
        } else {
            print("Error: Unable to parse the input date string.")
        }
        

        if let inputDate = inputDateFormatter.date(from: break_end) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
            
             formattedDate4 = outputDateFormatter.string(from: inputDate)
            
            print(formattedDate4)
        } else {
            print("Error: Unable to parse the input date string.")
        }
        
        
        
        print("Access Token: \(accessToken)")
        var param: Parameters = ["":""]
        
        param = ["start_time": formattedDate1, "end_time": formattedDate2, "break_start": formattedDate3, "break_end": formattedDate4]
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
                            self.hourMinuteLabel.text = "\(loginResponse.total_hours)h " + "\(loginResponse.total_minutes)m"
                            self.newTimeCardTV.reloadRows(at: [index], with: .automatic)
                            
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
    
    
    //MARK: Add Time Card
    func addTimeCard(startTime : String, finishTime: String, project_id: Int, task_id: Int, breaks: [String])
    {
        var formattedDate1 = ""
        var formattedDate2 = ""
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let url = "\(ApiLink.HOST_URL)/add_time_card"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd hh:mm a" // Customize the format to "Wed, 25 Oct 12:44"
        
        if startTimes == nil{
            formattedDate1 = ""
        }else{
            formattedDate1 = dateFormatter1.string(from: startTimes ?? Date())
        }
        if finishTimes == nil{
            formattedDate2 = ""
        }else{
            formattedDate2 = dateFormatter1.string(from: finishTimes ?? Date())
        }
        
        print("Access Token: \(accessToken)")
        let combinedString = breaks.joined(separator: ", ")
        var param: Parameters = ["":""]
        param = ["start_time": formattedDate1, "end_time": formattedDate2, "project_id": project_id, "task_id": task_id, "breaks": combinedString, "manager_id": managerId]
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
extension NewTimeCardVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if  projectSelect.titleLabel?.text != "Select".localizeString(string: lang) {
            if textField == startTime{
                startype = "Start"
            }else{
                startype = "Finish"
            }
        }else{
            _ = SweetAlert().showAlert("", subTitle:  "Please select the project first before entering start/finish date time.".localizeString(string: lang), style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if projectSelect.titleLabel?.text != "Select".localizeString(string: lang) {
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
        }else{
            _ = SweetAlert().showAlert("", subTitle:  "Please select the project first before entering start/finish date time.".localizeString(string: lang), style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
            return false
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "E, d MMM yyyy hh:mm a"//"yyyy-MM-dd hh:mm a" // Customize the format to "Wed, 25 Oct 12:44"
        //
        //        if startype == "Start"{
        //            startTime.text = dateFormatter.string(from: sender.date)
        //            startTimes = sender.date
        //        }else{
        //            finishTime.text = dateFormatter.string(from: sender.date)
        //            finishTimes = sender.date
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
            
            if hours > 0 {
                hourMinuteLabel.text = "\(hourString)H \(minuteString)M"
            } else if minutes > 0 {
                hourMinuteLabel.text = "\(minuteString)M \(secondString)S"
            } else {
                hourMinuteLabel.text = "\(secondString)S"
            }
            
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // Check if the start date is greater than the finish date
        if textField == startTime {
            if let startDate = startTimes, let finishDate = finishTimes {
                if startDate > finishDate {
                    self.showToast(message: "The finish time should be greater than start time".localizeString(string: lang), font: UIFont.systemFont(ofSize: 15))
                    self.finishTime.text = ""
                    
                }
            }
        } else if textField == finishTime {
            if let finishDate = finishTimes, let startDate = startTimes {
                if finishDate < startDate {
                    self.showToast(message: "The finish time should be greater than start time".localizeString(string: lang), font: UIFont.systemFont(ofSize: 15))
                    self.finishTime.text = ""
                    
                }
            }
        }
        return true
    }
}
