//
//  AdminClockInVC.swift
//  Cleansing
//
//  Created by uis on 29/12/23.
//

import UIKit
import CoreLocation
import Alamofire
class AdminClockInVC: UIViewController {

    
    @IBOutlet weak var workerType: UISegmentedControl!
    @IBOutlet weak var projectProgress: PaddingLabel!
    @IBOutlet weak var progressTime: UILabel!
    @IBOutlet weak var projectDetailTV: UITableView!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var finishTime: UILabel!
    @IBOutlet weak var topShowView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    
    
    let refreshControl = UIRefreshControl()
    var Projectdetails = [projectDetails]()
    var notesdetails = [showNotes]()
    var taskId: Int = 0//Inside Class
    var status:Int = 0
    var pid: Int = 0
    var workID: Int = 0
    var counter = 0;
//    var breakID: Int = 0
    var selectedRow: Int = 0
    var breaksData:[(String, String)] = [("Break Start 1", "Break End 1")]
    var startTimes: Date?
    var pickerView = UIPickerView()
    var timePicker: UIDatePicker!
    var timeTextField: UITextField!
    let locationManager = CLLocationManager()
    var breakID:[Int] = []
    var breakStart:[String] = []
    var breakEnd: [String] = []
    var lat: Double = 0.0
    var lng:Double = 0.0
    var yourTimer: Timer?
    var servicelat: Double = 0.0
    var servicelng:Double = 0.0
    var colorIndex = 0
    let colors: [UIColor] = [.green, .brown, .orange, .red]
    var breaks = [breakDurations]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        finishBtn.setTitle("Finish Time".localizeString(string: lang), for: .normal)
        UserDefaults.standard.setValue(true, forKey: "signed")
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
        //        projectProgress.text = "START"
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
    
    @IBAction func startBtnTap(_ sender: UIButton) {
        if let buttonText = sender.titleLabel?.text {
            if buttonText == "Start Time".localizeString(string: lang){
                sender.setTitle("Start Break".localizeString(string: lang), for: .normal)
                    print("Start Time")
                    startColorChangingTimer()
                    self.finishBtn.isHidden = false
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "d MMM yyyy hh:mm a"
                    // Get the current date and time
                    let currentDate = Date()
                    // Format the date as a string
                    let formattedDate = dateFormatter.string(from: currentDate)
                    workerProjectStatus(status: 1, task_id: 0, start_time: formattedDate, duration: 0, work_id: "", end_date: "")
            }else if buttonText == "Start Break".localizeString(string: lang){
                    self.finishBtn.isHidden = false
                    print("Start Break")
                sender.setTitle("End Break".localizeString(string: lang), for: .normal)
                    workerProjectStatus(status: 2, task_id: 0, start_time: getCurrentFormattedDate(), duration: 0, work_id: "\(self.workID)", end_date: "")
            }else if buttonText == "End Break".localizeString(string: lang){
                    self.finishBtn.isHidden = false
                    print("Start Break")
                sender.setTitle("Break".localizeString(string: lang), for: .normal)
                    workerProjectStatus(status: 5, task_id: 0, start_time: "", duration: 0, work_id: "\(workID)", end_date: getCurrentFormattedDate())
                }
            }
    }
    
    
    @IBAction func finishBtnTap(_ sender: UIButton) {
        if startBtn.titleLabel?.text != "End Break".localizeString(string: lang) {
            let dateFormatter = DateFormatter()
            self.yourTimer?.invalidate()
            self.yourTimer = nil
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
    
    
    @IBAction func switchSegment(_ sender: UISegmentedControl) {
        if workID != 0{
            if sender.selectedSegmentIndex == 1{
                if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WorkerClockInMapVC") as? WorkerClockInMapVC{
                    VC.hidesBottomBarWhenPushed = true
                    VC.workID = self.workID
                    self.navigationController?.pushViewController(VC, animated: true)
                }
            }
        }
    }
    
    @IBAction func deleteBtnTap(_ sender: UIButton) {
        showAlert()
    }
    
    
    
}

extension AdminClockInVC{
    
    func firstCall()
    {
        lang = UserDefaults.standard.string(forKey: "Lang") ?? "en"
        self.title = "Clock".localizeString(string: lang)
        self.noDataLabel.text = "Click start time button to see data here..".localizeString(string: lang)
        finishBtn.setTitle("Finish Time".localizeString(string: lang), for: .normal)
        startBtn.setTitle("Start Time".localizeString(string: lang), for: .normal)
        projectProgress.text = "START".localizeString(string: lang)
        firstLabel.text = "Start Time:".localizeString(string: lang)
        secondLabel.text = "Finish Time:".localizeString(string: lang)
        thirdLabel.text = "Breaks".localizeString(string: lang)
        workerType.setTitle("Time".localizeString(string: lang), forSegmentAt: 0)
        workerType.setTitle("Sites".localizeString(string: lang), forSegmentAt: 1)
        UserDefaults.standard.set("", forKey: "dfilter")
        UserDefaults.standard.setValue( "", forKey: "workerT")
        UserDefaults.standard.setValue( "all", forKey: "statusT")
        UserDefaults.standard.setValue("", forKey: "workerV")
        UserDefaults.standard.setValue("", forKey: "statusV")
        UserDefaults.standard.setValue("", forKey: "approverV")
        UserDefaults.standard.setValue("", forKey: "approverT")
        self.navigationController?.isNavigationBarHidden = true
        startBtn.roundedButton()
        finishBtn.roundedButton()
        projectProgress.textAlignment = .center
        projectProgress.layer.cornerRadius = 10
        projectProgress.layer.masksToBounds = true
        projectProgress.edgeInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        self.finishBtn.isHidden = true
        progressTime.text = "0H 0M"
        //        setupTimePicker()
        workerType.selectedSegmentIndex = 0
//        pickerView.dataSource = self
//        pickerView.delegate = self
        //Location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        checkLocationServices()
        self.deleteBtn.isHidden = true
        // Add the pull to refresh control to your table view
        projectDetailTV.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.gray // Customize the spinner color
        workID =  UserDefaults.standard.integer(forKey: "AW") ?? 0
        workerProjectDetails()
        floatingView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        personImage.isUserInteractionEnabled = true
        personImage.addGestureRecognizer(tapGesture)
        localizeTabBar()
    }
    
    //MARK: Change Text of TabBar
    func localizeTabBar() {
        lang = UserDefaults.standard.string(forKey: "Lang") ?? "en"
        tabBarController?.tabBar.items![0].title = "Clock".localizeString(string: lang)
        tabBarController?.tabBar.items![1].title = "Time Cards".localizeString(string: lang)
        tabBarController?.tabBar.items![2].title = "Tasks".localizeString(string: lang)
        tabBarController?.tabBar.items![3].title = "Projects".localizeString(string: lang)
        tabBarController?.tabBar.items![4].title = "Crew".localizeString(string: lang)
    }
    
    
    
    func showAlert() {
        let alertController = UIAlertController(
            title: "Delete clock in".localizeString(string: lang),
            message: "Deleting your clock in will remove your live timecard.".localizeString(string: lang),
            preferredStyle: .alert
        )

        // Add buttons to the alert
        let cancelButton = UIAlertAction(title: "Cancel".localizeString(string: lang), style: .cancel) { _ in
            // Handle cancel button action
            print("Cancel button tapped")
        }
        
        let okButton = UIAlertAction(title: "Delete".localizeString(string: lang), style: .default) { _ in
            // Handle OK button action
            print("OK button tapped")
            self.deleteTimeCard()
        }

        alertController.addAction(cancelButton)
        alertController.addAction(okButton)

        // Present the alert
        present(alertController, animated: true, completion: nil)
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
    
    @objc func imageTapped() {
           print("Image tapped!")
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC{
            VC.hidesBottomBarWhenPushed = true
                 self.navigationController?.pushViewController(VC, animated: true)
             }
      
    }
    
    
    func floatingView()
    {
        // Create a container view for the floating button
               let floatingButtonContainer = UIView()
               floatingButtonContainer.translatesAutoresizingMaskIntoConstraints = false
               view.addSubview(floatingButtonContainer)

               // Add constraints to position the container view
               NSLayoutConstraint.activate([
                   floatingButtonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                   floatingButtonContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
               ])

               // Create a floating button
               let floatingButton = UIButton(type: .custom)
               floatingButton.translatesAutoresizingMaskIntoConstraints = false
                floatingButton.backgroundColor = UIColor.init(hexString: "5fb8ee")
               floatingButton.layer.cornerRadius = 25 // Adjust the corner radius as needed
                floatingButton.setTitle("DASHBOARD".localizeString(string: lang), for: .normal)
                floatingButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
                floatingButton.setTitleColor(UIColor.black, for: .normal)
               floatingButton.setImage(UIImage(systemName: "square.split.2x2.fill"), for: .normal)
                floatingButton.tintColor = UIColor.black
               floatingButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0) // Adjust the inset as needed
               floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)

               // Add the button to the container view
               floatingButtonContainer.addSubview(floatingButton)

               // Add constraints to position the button inside the container view
               NSLayoutConstraint.activate([
                   floatingButton.leadingAnchor.constraint(equalTo: floatingButtonContainer.leadingAnchor),
                   floatingButton.trailingAnchor.constraint(equalTo: floatingButtonContainer.trailingAnchor),
                   floatingButton.topAnchor.constraint(equalTo: floatingButtonContainer.topAnchor),
                   floatingButton.bottomAnchor.constraint(equalTo: floatingButtonContainer.bottomAnchor),
                   floatingButton.widthAnchor.constraint(equalToConstant: 180), // Adjust the width as needed
                   floatingButton.heightAnchor.constraint(equalToConstant: 50)   // Adjust the height as needed
               ])
    }
    
    @objc func floatingButtonTapped() {
            // Handle button tap action
            print("Floating button tapped!")
                if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC{
                    VC.hidesBottomBarWhenPushed = true
                         self.navigationController?.pushViewController(VC, animated: true)
                     }
        }
    
    func getCurrentFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Set the locale if needed
        
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        
        return formattedDate
    }

    
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
//        addChild(viewController)
//        // Add Child View as Subview
//        self.bottomView.addSubview(viewController.view)
//
//        // Configure Child View
//        viewController.view.frame = self.bottomView.bounds
//        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        // Notify Child View Controller
//        viewController.didMove(toParent: self)
    }
    
    
    @objc func refreshData(_ sender: Any) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.workerProjectDetails()
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
//        startTime.text = formattedDate + " " + selectedTime//2 Jan
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
//extension WorkerClockInVC:  UIPickerViewDelegate, UIPickerViewDataSource {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return breaks.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return breaks[row].time
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let selectedTimeInterval = breaks[row].time
//        print("Selected Time Interval: \(selectedTimeInterval)")
////        breakDuration.text = selectedTimeInterval
//        breakID = breaks[row].id
//        if counter == 0{
//            counter+=1
//            workerProjectStatus(status: 2, task_id: pid, start_time: "", duration: breaks[row].duration, work_id: "\(workID)", end_date: "")
//        }
//    }
//}
//MARK: Location
extension AdminClockInVC: CLLocationManagerDelegate {
    
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
extension AdminClockInVC: UITextViewDelegate
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
extension AdminClockInVC {
    
    //MARK: Task Detail API//run every 1 minute
    func workerProjectDetails()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/untag_work_details"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["id": self.workID]//Work ID
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
                           let loginResponse = try? JSONDecoder().decode(ApiRespons.self, from: jsonData) {
                                                            self.startTime.text = loginResponse.data.start_time//2 Jan
                                                            self.finishTime.text = loginResponse.data.end_time//2 Jan
                            //                                self.breakDuration.text = loginResponse.data.break ?? ""  + " Mins"
                            //                                self.currentLocation.text = loginResponse.data.location
                            //                                self.workerType.text = loginResponse.data.task_title
                            self.workID = loginResponse.data.work_id
                            self.topShowView.isHidden = true
                            if loginResponse.data.status == 0{
                                self.projectProgress.text = "START".localizeString(string: lang)
                            }else if loginResponse.data.status == 1 {
                                self.deleteBtn.isHidden = false
                                self.projectProgress.text = "WORKING".localizeString(string: lang)
                                self.yourTimer?.invalidate()
                                self.yourTimer = nil
                                self.startColorChangingTimer()
                                self.finishBtn.isHidden = false
                                self.startBtn.setTitle("Start Break".localizeString(string: lang), for: .normal)
                            }else if loginResponse.data.status == 2{
                                self.projectProgress.text = "ON BREAK".localizeString(string: lang)
                                self.finishBtn.isHidden = false
                                self.yourTimer?.invalidate()
                                self.yourTimer = nil
                                self.startColorChangingTimer()
                                self.deleteBtn.isHidden = false
                                self.startBtn.setTitle("End Break".localizeString(string: lang), for: .normal)
                                self.startBtn.isEnabled = true
                            }else if loginResponse.data.status == 4{
                                self.projectProgress.text = "DAY END".localizeString(string: lang)
                                self.finishBtn.isHidden = false
                                self.deleteBtn.isHidden = false
                                self.startBtn.setTitle("Start Time".localizeString(string: lang), for: .normal)
                                self.startBtn.isEnabled = true
                                self.deleteBtn.isHidden = false
                                self.finishBtn.isEnabled = false
                            }else if loginResponse.data.status == 5{
                                self.finishBtn.isHidden = false
                                self.projectProgress.text = "WORKING".localizeString(string: lang)
                                self.yourTimer?.invalidate()
                                self.yourTimer = nil
                                self.startColorChangingTimer()
                                self.startBtn.setTitle("Break".localizeString(string: lang), for: .normal)
                                self.startBtn.isEnabled = true
                                self.deleteBtn.isHidden = false
                                self.finishBtn.isEnabled = true
                            }else if loginResponse.data.status == 3{
                                self.projectProgress.text = "FINISHED".localizeString(string: lang)
                                self.startBtn.isEnabled = false
                                self.finishBtn.isEnabled = false
                                self.deleteBtn.isHidden = false
                            }else{
                                self.projectProgress.text = ""
                                //                                    self.startBtn.isEnabled = false
                                //                                    self.finishBtn.isEnabled = false
                            }
                            
                            self.progressTime.text = "\(loginResponse.data.hours)H " + "\(loginResponse.data.minute)M"
                            //                                + "\(loginResponse.data.hours)S"
                            
                            
//                            self.breaksData.removeAll()
                            self.breakID.removeAll()
                            self.breakStart.removeAll()
                            self.breakEnd.removeAll()
                            for i in 0..<(loginResponse.breakTimes?.count ?? 0){
                                self.breakID.append(loginResponse.breakTimes?[i].id ?? 0)
                                self.breakStart.append(loginResponse.breakTimes?[i].start_time ?? "")
                                self.breakEnd.append(loginResponse.breakTimes?[i].end_time ?? "")
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
                        //                            _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
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
        let url = "\(ApiLink.HOST_URL)/create_untag_timecard"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        //        if status == 1{
        param = ["status": status, "task_id": 0, "start_time": start_time, "work_id": self.workID, "duration": duration, "end_time": end_date,"latitude": lat, "longitude": lng]
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
                        if let jsonData = try? JSONSerialization.data(withJSONObject: value),
                           let loginResponse = try? JSONDecoder().decode(WorkRespons.self, from: jsonData) {
                            //
                            if loginResponse.data.status == 1{
                                self.deleteBtn.isHidden = false
                                self.startTime.text = loginResponse.data.startTime
                            }else if loginResponse.data.status == 4{
                                self.finishTime.text = loginResponse.data.endTime
                            }
                            progressHUD.hide()
                            if status == 4{
                                self.breakID.removeAll()
                                self.breakStart.removeAll()
                                self.breakEnd.removeAll()
                                self.startTime.text = ""
                                self.topShowView.isHidden = false
                                self.finishTime.text = ""
                                self.projectProgress.text = "Start".localizeString(string: lang)
                                self.projectProgress.backgroundColor = UIColor.init(hexString: "334E7C")
                                self.deleteBtn.isHidden = true
                                self.progressTime.text = "0H 0M"
                                self.startBtn.setTitle("Start Time".localizeString(string: lang), for: .normal)
                                self.finishBtn.isHidden = true
                                UserDefaults.standard.removeObject(forKey: "AW")
                                    DispatchQueue.main.async {
                                        self.projectDetailTV.delegate = self
                                        self.projectDetailTV.dataSource = self
                                        self.projectDetailTV.reloadData()
                                    }
                              
                            }else{
                                
                                self.workID = loginResponse.data.workId
                                UserDefaults.standard.setValue(self.workID, forKey: "AW")
                                self.workerProjectDetails()
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
    
    //MARK: Delete TimeCard
    func deleteTimeCard()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let url = "\(ApiLink.HOST_URL)/delete_timecard"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        
        print("Access Token: \(accessToken)")
        var param: Parameters = ["":""]
        param = ["timecard_id": workID]
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
                                    self.yourTimer?.invalidate()
                                    self.yourTimer = nil
                                    self.breakID.removeAll()
                                    self.breakStart.removeAll()
                                    self.breakEnd.removeAll()
                                    self.projectProgress.backgroundColor = UIColor.init(hexString: "334E7C")
                                    self.topShowView.isHidden = false
                                    self.startTime.text = ""
                                    self.deleteBtn.isHidden = true
                                    self.finishTime.text = ""
                                    UserDefaults.standard.removeObject(forKey: "AW")
                                    self.projectProgress.text = "Start".localizeString(string: lang)
                                    self.startBtn.setTitle("Start Time".localizeString(string: lang), for: .normal)
                                    self.progressTime.text = "0H 0M"
                                    self.finishBtn.isHidden = true
                                        DispatchQueue.main.async {
                                            self.projectDetailTV.delegate = self
                                            self.projectDetailTV.dataSource = self
                                            self.projectDetailTV.reloadData()
                                        }
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
//                        if let jsonData = try? JSONSerialization.data(withJSONObject: value),
//                           let loginResponse = try? JSONDecoder().decode(DefaultInfo.self, from: jsonData) {
                            progressHUD.hide()
                            self.yourTimer?.invalidate()
                            self.yourTimer = nil
                            self.workerProjectDetails()
                            
//                        } else {
//                            print("Error decoding JSON")
//                            _ = SweetAlert().showAlert("", subTitle: "Error Decoding".localizeString(string: lang), style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
//                            progressHUD.hide()
//                        }
                        
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
    

}

//MARK: TableView Delegate
extension AdminClockInVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breakStart.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "nbCell", for: indexPath) as! NewBreakTVC
        cell.startTime.setTitle(breakStart[indexPath.row], for: .normal)
            cell.endTime.setTitle(breakEnd[indexPath.row], for: .normal)
            
//            cell.onBreakStartTapped = { [weak self] in
//                self?.showDatePicker(for: .breakStart, at: indexPath)
//            }
//
//            cell.onBreakEndTapped = { [weak self] in
//                self?.showDatePicker(for: .breakEnd, at: indexPath)
//            }
            
            cell.onDeleteButtonTapped = { [weak self] in
                self?.deleteBreak(at: indexPath)
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
    
    
    enum DatePickerType {
        case breakStart
        case breakEnd
    }
    
    func deleteBreak(at indexPath: IndexPath) {
        if breakEnd.count < 1{
        }else{
//            breaksData.remove(at: indexPath.row)
//            projectDetailTV.deleteRows(at: [indexPath], with: .automatic)
            deleteBreak(id: breakID[indexPath.row])
            
        }
    }
    
}
