//
//  WorkerProjectDetailsVC.swift
//  Cleansing
//
//  Created by United It Services on 01/09/23.
//

import UIKit
import CoreLocation
import Alamofire
class WorkerProjectDetailsVC: UIViewController {
    
    @IBOutlet weak var workerType: UILabel!
    @IBOutlet weak var projectProgress: PaddingLabel!
    @IBOutlet weak var progressTime: UILabel!
    @IBOutlet weak var projectDetailTV: UITableView!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var breakBtn: UIButton!
    @IBOutlet weak var checklistBtn: UIButton!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstSubBtn: UIButton!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var thirdsubLabel: UILabel!
    @IBOutlet weak var fourLabel: UILabel!
    @IBOutlet weak var fourSubLabel: UIButton!
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var finishLabel: UILabel!
    @IBOutlet weak var topTitleLabel: UILabel!
    
    
    @IBOutlet weak var topHeight: NSLayoutConstraint!
    
    
    let refreshControl = UIRefreshControl()
    var Projectdetails = [projectDetails]()
    var notesdetails = [showNotes]()
    var taskId: Int = 0//Inside Class
    var checkListCount:Int = 0
    var timer: Timer?
    var status:Int = 0
    var pid: Int = 0
    var workID: Int = 0
    var counter = 0;
    var breakID: Int = 0
    var selectedRow: Int = 0
    var startTimes: Date?
    var pickerView = UIPickerView()
    var timePicker: UIDatePicker!
    var timeTextField: UITextField!
    let locationManager = CLLocationManager()
    var yourTimer: Timer?
    var lat: Double = 0.0
    var lng:Double = 0.0
    var colorIndex = 0
    let colors: [UIColor] = [.green, .brown, .orange, .red]
    var servicelat: Double = 0.0
    var servicelng:Double = 0.0
    
    
    var breaks = [breakDurations]()
    override func viewDidLoad() {
        super.viewDidLoad()
        startBtn.setTitle("Start Work".localizeString(string: lang), for: .normal)
        finishBtn.setTitle("Finish Work".localizeString(string: lang), for: .normal)
        breakBtn.setTitle("See Breaks".localizeString(string: lang), for: .normal)
        checklistBtn.setTitle("See Checklists".localizeString(string: lang), for: .normal)
        firstLabel.text = "Time Details".localizeString(string: lang)
        firstSubBtn.setTitle("View Full Data".localizeString(string: lang), for: .normal)
        secondLabel.text = "Break Times & Check Lists".localizeString(string: lang)
        thirdLabel.text = "Site Details".localizeString(string: lang)
        thirdsubLabel.text = "Location".localizeString(string: lang)
        fourLabel.text = "Notes".localizeString(string: lang)
        fourSubLabel.setTitle("My Notes".localizeString(string: lang), for: .normal)
        startLabel.text = "Start Time".localizeString(string: lang)
        finishLabel.text = "Finish Time".localizeString(string: lang)
        topTitleLabel.text = "Project Details".localizeString(string: lang)
        firstCall()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        projectProgress.text = "START"
        self.navigationController?.isNavigationBarHidden = true
        workerProjectDetails(id: pid)
//        if currentLocation.text == "Location Access Denied"{
//            locationAlert()
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        yourTimer?.invalidate()
        yourTimer = nil
    }
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func startBtnTap(_ sender: UIButton) {
        if let buttonText = sender.titleLabel?.text {
            if buttonText == "Start Work".localizeString(string: lang){
                finishBtn.setTitle("Finish Work".localizeString(string: lang), for: .normal)
                sender.setTitle("Break Start".localizeString(string: lang), for: .normal)
                self.showToast(message: "Work Started".localizeString(string: lang), font: UIFont.systemFont(ofSize: 20))
                    print("Start Work")
                    yourTimer?.invalidate()
                    yourTimer = nil
                    startColorChangingTimer()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "d MMM yyyy hh:mm a"
                    // Get the current date and time
                    let currentDate = Date()
                    // Format the date as a string
                    let formattedDate = dateFormatter.string(from: currentDate)
                    workerProjectStatus(status: 1, task_id: pid, start_time: formattedDate, duration: 0, work_id: "", end_date: "")
            }else if buttonText == "Break Start".localizeString(string: lang){
                    print("Start Break")
                self.showToast(message: "Break Started".localizeString(string: lang), font: UIFont.systemFont(ofSize: 20))
                    yourTimer?.invalidate()
                    yourTimer = nil
                    startColorChangingTimer()
                    breakDurationList()
                sender.setTitle("Break End".localizeString(string: lang), for: .normal)
                    
            }else if buttonText == "Break End".localizeString(string: lang){
                    print("Start Break")
                self.showToast(message: "Break End".localizeString(string: lang), font: UIFont.systemFont(ofSize: 20))
                    yourTimer?.invalidate()
                    yourTimer = nil
                    startColorChangingTimer()
                sender.setTitle("Break Start".localizeString(string: lang), for: .normal)
                    workerProjectStatus(status: 5, task_id: pid, start_time: "", duration: 0, work_id: "\(workID)", end_date: "")
                }
            }
    }
    
    
    @IBAction func finishBtnTap(_ sender: UIButton) {
        if startBtn.titleLabel?.text != "Break End".localizeString(string: lang) {
            sender.setTitle("Work Completed".localizeString(string: lang), for: .normal)
            self.showToast(message: "Finish Time", font: UIFont.systemFont(ofSize: 20))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy hh:mm a"
            // Get the current date and time
            let currentDate = Date()
            // Format the date as a string
            let formattedDate = dateFormatter.string(from: currentDate)
            workerProjectStatus(status: 4, task_id: pid, start_time: "", duration: 0, work_id: "\(workID)", end_date: formattedDate )
        }else{
            _ = SweetAlert().showAlert("", subTitle:  "Break is in progress, you cannot mark as dayEnd/finish task.".localizeString(string: lang), style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
        }
        
    } 	
    
    @IBAction func showMapBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GooglePathVC") as? GooglePathVC{
            VC.hidesBottomBarWhenPushed = true
            VC.comingFrom = "Task"
            VC.endLat = servicelat
            VC.endLng = servicelng
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func addNotesBtnTap(_ sender: UIButton) {
//        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNotesVC") as? AddNotesVC{
//            VC.calledType = ""
//            VC.task_id = taskId
//            self.navigationController?.pushViewController(VC, animated: true)
//        }
        
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowNotesVC") as? ShowNotesVC{
            VC.hidesBottomBarWhenPushed = true
            VC.taskID = self.pid
            VC.calledFrom = "WorkerTask"
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
        
    }
    
    @IBAction func viewBreakBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BreakVC") as? BreakVC{
            VC.hidesBottomBarWhenPushed = true
            VC.modalPresentationStyle = .formSheet
            VC.taskId = pid
            self.present(VC, animated: true)
        }
    }
    
    @IBAction func viewCheckListBtnTap(_ sender: UIButton) {
        if checkListCount < 1{
            _ = SweetAlert().showAlert("", subTitle: "No checklist found".localizeString(string: lang), style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
        }else{
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TimeCardCheckListVC") as? TimeCardCheckListVC{
                VC.hidesBottomBarWhenPushed = true
                if let presentationController = VC.presentationController as? UISheetPresentationController {
                    presentationController.detents = [.large()] /// change to [.medium(), .large()] for a half *and* full screen sheet
                }
                VC.taskId = pid
                self.present(VC, animated: true)
            }
        }
    }
    
    @IBAction func viewFullBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewFullDataVC") as? ViewFullDataVC{
            VC.hidesBottomBarWhenPushed = true
            VC.task_id = "\(self.pid)"
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    
    
    
}

extension WorkerProjectDetailsVC{
    
    func firstCall()
    {
        ksceneDelegate?.popOut = false
        self.title = "Project Details".localizeString(string: lang)
        startBtn.roundedButton()
        finishBtn.roundedButton()
        projectProgress.textAlignment = .center
        projectProgress.layer.cornerRadius = 10
        projectProgress.layer.masksToBounds = true
        projectProgress.edgeInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        progressTime.text = "0H 0M"
        //        setupTimePicker()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        //Location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        checkLocationServices()
        
        // Add the pull to refresh control to your table view
        projectDetailTV.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.gray // Customize the spinner color
        
        breakBtn.layer.masksToBounds  = true
        breakBtn.layer.cornerRadius = 10
        breakBtn.layer.borderWidth = 0.5
        breakBtn.layer.borderColor = UIColor.black.cgColor
        checklistBtn.layer.masksToBounds  = true
        checklistBtn.layer.cornerRadius = 10
        checklistBtn.layer.borderWidth = 0.5
        checklistBtn.layer.borderColor = UIColor.black.cgColor
    }
    
    func startColorChangingTimer() {
        yourTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(changeLabelColor), userInfo: nil, repeats: true)
        }
        @objc func changeLabelColor() {
            UIView.animate(withDuration: 0.5) {
                self.projectProgress.backgroundColor = self.colors[self.colorIndex]
            }
            
            // Increment the colorIndex, and loop back to 0 if it exceeds the array bounds
            colorIndex = (colorIndex + 1) % colors.count
        }
    
    @objc func refreshData(_ sender: Any) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.workerProjectDetails(id: self.pid)
            print("Reload Data") // Reload your table view data if needed
        }
    }
    
    func locationAlert() {
        let customFont = UIFont(name: "Poppins-Medium", size: 17)
        
        let attributedString = NSAttributedString(
            string: "Location access denied. Please enable location services from iPhone settings".localizeString(string: lang),
            attributes: [NSAttributedString.Key.font: customFont as Any]
        )
        let alertController = UIAlertController(
            title: "",
            message: "",
            preferredStyle: .alert
        )
        alertController.setValue(attributedString, forKey: "attributedMessage")
        alertController.addAction(UIAlertAction(title: "OK".localizeString(string: lang), style: .default, handler: { (action: UIAlertAction!) in
            self.openAppSettings()
            
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    //MARK: Add Time Picker on Start Task
    func setupTimePicker() {
        timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.locale = Locale(identifier: "en_US_POSIX") // Set the locale to your preference
        timePicker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
        timeTextField = UITextField()
        timeTextField.inputView = timePicker
        view.addSubview(timeTextField)
    }
    
    @objc func timePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a" // Format the time as needed
        let selectedTime = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "d MMM yyyy" // Set the desired date format
        let currentDate = Date() // Get the current date
        let formattedDate = dateFormatter.string(from: currentDate)
        startTime.text = formattedDate + " " + selectedTime
    }
    //MARK: Update Timer of Task
    @objc func updateTimer() {
        if let startTime = startTimes {
            let currentTime = Date()
            let elapsedTime = currentTime.timeIntervalSince(startTime)
            
            let hours = Int(elapsedTime / 3600)
            let minutes = Int((elapsedTime / 60).truncatingRemainder(dividingBy: 60))
            let seconds = Int(elapsedTime.truncatingRemainder(dividingBy: 60))
            
            let hourString = String(format: "%02d", hours)
            let minuteString = String(format: "%02d", minutes)
            let secondString = String(format: "%02d", seconds)
            
            if hours > 0 {
                progressTime.text = "\(hourString)H \(minuteString)M"
            } else if minutes > 0 {
                progressTime.text = "\(minuteString)M \(secondString)S"
            } else {
                progressTime.text = "\(secondString)S"
            }
        }
    }
    
    
}
//MARK: Picker
extension WorkerProjectDetailsVC:  UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breaks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breaks[row].time
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedTimeInterval = breaks[row].time
        print("Selected Time Interval: \(selectedTimeInterval)")
//        breakDuration.text = selectedTimeInterval
        breakID = breaks[row].id
        if counter == 0{
            counter+=1
            workerProjectStatus(status: 2, task_id: pid, start_time: "", duration: breaks[row].duration, work_id: "\(workID)", end_date: "")
        }
    }
}
//MARK: Location
extension WorkerProjectDetailsVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        if let location = locations.last {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                
                // Do something with the latitude and longitude values
                print("Latitude: \(latitude), Longitude: \(longitude)")
            self.lat = latitude
            self.lng = longitude
                locationManager.stopUpdatingLocation()
                
                
            }
        
        
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                if let locality = placemark.locality, let country = placemark.country {
//                    self.currentLocation.text = "\(locality), \(country)"
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            break
        case .denied, .restricted:
            //            locationAlert()//commented for app upload
                        break;//added for app upload
//            currentLocation.text = "Location Access Denied"
        case .notDetermined:
            break // Handle the case where the user hasn't made a decision yet
        @unknown default:
            break
        }
    }
    
    func checkLocationServices() {
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            } else {
//                self.currentLocation.text = "Location Services Disabled"
            }
        }
        
    }
    
    func openAppSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
    }
    
    
}
//MARK: UITextView Delegate
extension WorkerProjectDetailsVC: UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Description".localizeString(string: lang)
            textView.textColor = UIColor.lightGray
        }
    }
}
//MARK: API Integration
extension WorkerProjectDetailsVC {
    
    //MARK: Task Detail API
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
                                self.startTime.text = loginResponse.data.start_date
                                self.endTime.text = loginResponse.data.end_date
//                                self.breakDuration.text = loginResponse.data.break ?? ""  + " Mins"
                                self.currentLocation.text = loginResponse.data.location
                                self.workerType.text = loginResponse.data.task_title
                                self.workID = loginResponse.data.work_id
                                
                                
                                if loginResponse.data.status == 0{
                                    self.projectProgress.text = "START".localizeString(string: lang)
                                }else if loginResponse.data.status == 1 {
                                    self.projectProgress.text = "WORKING".localizeString(string: lang)
                                    self.finishBtn.isEnabled = true
                                    self.yourTimer?.invalidate()
                                    self.yourTimer = nil
                                    self.startColorChangingTimer()
                                    self.startBtn.setTitle("Break Start".localizeString(string: lang), for: .normal)
                                }else if loginResponse.data.status == 2{
                                    self.projectProgress.text = "ON BREAK".localizeString(string: lang)
                                    self.yourTimer?.invalidate()
                                    self.yourTimer = nil
                                    self.startColorChangingTimer()
                                    self.startBtn.setTitle("Break End".localizeString(string: lang), for: .normal)
                                    self.startBtn.isEnabled = true
                                }else if loginResponse.data.status == 4{
                                    self.projectProgress.text = "DAY END".localizeString(string: lang)
                                    self.yourTimer?.invalidate()
                                    self.finishBtn.setTitle("Work Completed".localizeString(string: lang), for: .normal)
                                    self.yourTimer = nil
                                    self.startBtn.setTitle("Start Work".localizeString(string: lang), for: .normal)
                                    self.startBtn.isEnabled = true
                                    self.finishBtn.isEnabled = false
                                }else if loginResponse.data.status == 5{
                                    self.yourTimer?.invalidate()
                                    self.yourTimer = nil
                                    self.startColorChangingTimer()
                                    self.projectProgress.text = "WORKING".localizeString(string: lang)
                                    self.startBtn.setTitle("Break Start".localizeString(string: lang), for: .normal)
                                    self.startBtn.isEnabled = true
                                    self.finishBtn.isEnabled = true
                                }else if loginResponse.data.status == 3{
                                    self.yourTimer?.invalidate()
                                    self.yourTimer = nil
                                    self.projectProgress.text = "TASK COMPLETED".localizeString(string: lang)
                                    self.startBtn.isEnabled = false
                                    self.finishBtn.isEnabled = false
                                    self.startBtn.isHidden = true
                                    self.finishBtn.isHidden = true
                                }else{
                                    self.projectProgress.text = ""
//                                    self.startBtn.isEnabled = false
//                                    self.finishBtn.isEnabled = false
                                }
                                
                                self.progressTime.text = "\(loginResponse.data.hours)H " + "\(loginResponse.data.minute)M"
//                                + "\(loginResponse.data.hours)S"
                               
                                self.checkListCount = loginResponse.checklist.count
                                self.notesdetails.removeAll()
                                for i in 0..<loginResponse.admin_note.count{
                                    self.notesdetails.append(showNotes.init(nsdate: loginResponse.admin_note[i].date ?? "", nstime: loginResponse.admin_note[i].time ?? "", ntitle: loginResponse.admin_note[i].note_title ?? "", nid: loginResponse.admin_note[i].id ?? 0, nImageId: loginResponse.admin_note[i].image, url: loginResponse.admin_note[i].url ?? "", npimage: loginResponse.admin_note[i].uploaded_by_profile ?? "", npname: loginResponse.admin_note[i].uploaded_by ?? "", roleId: loginResponse.admin_note[i].role ?? 0))
                                }
                                progressHUD.hide()
                                DispatchQueue.main.async {
                                    self.projectDetailTV.delegate = self
                                    self.projectDetailTV.dataSource = self
                                    self.projectDetailTV.reloadData()
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
    
    //MARK: Task Start/Break/DayEnd API
    func workerProjectStatus(status: Int, task_id: Int, start_time: String, duration: Int, work_id: String, end_date: String)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
      
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/workstatus"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
//        if status == 1{
        param = ["status": status, "task_id": task_id, "start_time": start_time, "work_id": work_id, "duration": duration, "end_time": end_date,"latitude": lat, "longitude": lng]
//        }else if status == 2{
//            param = ["status": status, "work_id": work_id, "duration": duration]
//        }else{
//            param = ["status": status, "work_id": work_id, "end_date": end_date]
//        }
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
//                            if let jsonData = try? JSONSerialization.data(withJSONObject: value),
//                               let loginResponse = try? JSONDecoder().decode(TaskDetailInfo.self, from: jsonData) {
//                              
                            if status == 1{
                                self.startTime.text = start_time
                            }else if status == 4{
                                self.endTime.text = end_date
                            }
                                progressHUD.hide()
                                
                                
                                self.workerProjectDetails(id: self.pid)
//                            } else {
//                                print("Error decoding JSON")
//                                _ = SweetAlert().showAlert("", subTitle: "Error Decoding".localizeString(string: lang), style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
//                                progressHUD.hide()
//                            }
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
    
    
    //MARK: Break Duration
    
    func breakDurationList()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
      
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/break_duration_list"
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
                               let loginResponse = try? JSONDecoder().decode(BreakDuration.self, from: jsonData) {
                                
                                self.breaks.removeAll()
                                for i in 0..<loginResponse.data.count{
                                    self.breaks.append(breakDurations.init(duration: loginResponse.data[i].duration, time: loginResponse.data[i].time, id: loginResponse.data[i].id))
                                }
                               
                                progressHUD.hide()
                                
                                let alertController = UIAlertController(title: "Select an Option".localizeString(string: lang), message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
                                // Create the UIPickerView
                                self.pickerView.frame = CGRect(x: 0, y: 50, width: 270, height: 150)
                                // Add the UIPickerView to the UIAlertController
                                alertController.view.addSubview(self.pickerView)
                                // Add "Done" and "Cancel" actions
                                alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
                                    let selectedRow = self.pickerView.selectedRow(inComponent: 0)
                                    let selectedOption = "Option \(selectedRow + 1)"
                                    print("Selected option: \(selectedOption)")
                                    self.pickerView(self.pickerView, didSelectRow: selectedRow, inComponent: 0)
                                    
            //                        self.startBtn.isEnabled = false
            //                        self.startBtn.backgroundColor = UIColor.lightGray
                                }))
                                alertController.addAction(UIAlertAction(title: "Cancel".localizeString(string: lang), style: .cancel, handler: nil))
                                // Present the UIAlertController
                                self.present(alertController, animated: true, completion: nil)
                                
                                
//                                self.workerProjectDetails(id: self.pid)
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


//MARK:  TableView Delegate and DataSource
extension WorkerProjectDetailsVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesdetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sanCell", for: indexPath) as! ShowAdminNotesTVC
        cell.notesDate.text =  notesdetails[indexPath.row].nsdate + " " + notesdetails[indexPath.row].nstime
        cell.notesTitle.text =  notesdetails[indexPath.row].ntitle
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ShowAdminNotesTVC {
            cell.showNotesCV.dataSource = self
            cell.showNotesCV.delegate = self
            cell.showNotesCV.tag = indexPath.row
            selectedRow = indexPath.row
            cell.showNotesCV.reloadData()
        }
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
}

//MARK: Collection View Delegate and DataSource
extension WorkerProjectDetailsVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notesdetails[selectedRow].nImageId.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "anCell", for: indexPath) as! AddNotesCVC
        getImageFromURL(imageView: cell.notesImageView, stringURL: notesdetails[selectedRow].url  + (notesdetails[selectedRow].nImageId[indexPath.row].images ?? ""))
        cell.deleteBtn.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.scrollDirection = .horizontal
        let numberOfItemsperRow:CGFloat = 4
        let itemWidth = (collectionView.bounds.width - layout.minimumLineSpacing) / numberOfItemsperRow
        return CGSize(width: itemWidth + 30, height: itemWidth + 20  )//20.0
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
       
        }
}
