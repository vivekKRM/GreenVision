//
//  WorkerTimeCardVC.swift
//  Cleansing
//
//  Created by United It Services on 01/09/23.
//

import UIKit
import Alamofire
import Fastis
import CoreLocation
class WorkerTimeCardVC: UIViewController{
    @IBOutlet weak var timeCardTV: UITableView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var changeDateView: UIView!
    @IBOutlet weak var changeDateBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var allTasks: UIButton!
    @IBOutlet weak var taskBtn: UIButton!
    
    
    var pickerView: UIPickerView!
    var status:Int = 0
    var count = 0
    let locationManager = CLLocationManager()
    var lat: Double = 0.0
    var long: Double = 0.0
    var servicelat: Double = 0.0
    var servicelong: Double = 0.0
    var date_selection: String = ""
    var workingStatu: String = ""
    var project_id: Int = 0
    var alertController: UIAlertController!
    var searchData = [search]()
    var showData = [showProject]()
    var filteredData: [search] = [] // Filtered results
    var isSearching: Bool {
        return !searchBar.text!.isEmpty
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tasks".localizeString(string: lang)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        checkLocationServices()
        firstCall()
//        tabBarController?.delegate = self
        
    }
    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        // Check if the selected view controller is your desired view controller
//        if viewController is WorkerTimeCardVC {
//            // Perform the refresh action here
//            // For example, reload data, update UI, etc.
//            firstCall()
//        }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    
    @IBAction func changeDateBtnTap(_ sender: UIButton) {
        //        if lat > 0.0{
        chooseDate()
        //        }else{
        //            locationAlert()
        //        }
    }
    
    
    @IBAction func filterBtnTap(_ sender: UIButton) {
        ksceneDelegate?.popOut = false
        present(alertController, animated: true)
    }
    
    
    @IBAction func taskBtnTap(_ sender: UIButton) {
        showAlert()
    }
    
}
extension WorkerTimeCardVC {
    
    func firstCall()
    {
        allTasks.setTitle("All Tasks".localizeString(string: lang), for: .normal)
        taskBtn.layer.masksToBounds = true
        taskBtn.layer.cornerRadius = 10
        changeDateView.layer.masksToBounds = true
        changeDateView.layer.cornerRadius = 5
        //        if lat > 0.0{
        getProject()//API
        projectPicker()//Picker
        //        }else{
        //            locationAlert()
        //        }
        filterBtn.layer.borderWidth = 0.5
        filterBtn.layer.borderColor = UIColor.white.cgColor
        filterBtn.layer.cornerRadius  = 10
        filterBtn.layer.masksToBounds = true
        self.timeCardTV.keyboardDismissMode = .onDrag
    }
    
    func showAlert() {
        // Create an alert controller
        let alertController = UIAlertController(title: "Filter Task".localizeString(string: lang), message: "", preferredStyle: .alert)
        
        // Create three buttons with different actions
        let button1 = UIAlertAction(title: "All Tasks".localizeString(string: lang), style: .default) { (action) in
            // Code to be executed when Button 1 is tapped
            print("Button 1 tapped")
            self.taskBtn.setTitle("All Tasks".localizeString(string: lang), for: .normal)
            self.workingStatu = ""
            self.getTask(id: "\(self.project_id)", filter: self.date_selection, workingStatus: "")
        }
        
        let button2 = UIAlertAction(title: "Completed".localizeString(string: lang), style: .default) { (action) in
            // Code to be executed when Button 2 is tapped
            print("Button 2 tapped")
            self.taskBtn.setTitle("Completed".localizeString(string: lang), for: .normal)
            self.workingStatu = "3"
            self.getTask(id: "\(self.project_id)", filter: self.date_selection, workingStatus: "3")
        }
        
        let button3 = UIAlertAction(title: "Ongoing".localizeString(string: lang), style: .default) { (action) in
            // Code to be executed when Button 3 is tapped
            print("Button 3 tapped")
            self.taskBtn.setTitle("Ongoing".localizeString(string: lang), for: .normal)
            self.workingStatu = "2"
            self.getTask(id: "\(self.project_id)", filter: self.date_selection, workingStatus: "2")
        }
        
        let button4 = UIAlertAction(title: "Upcoming".localizeString(string: lang), style: .default) { (action) in
            // Code to be executed when Button 3 is tapped
            print("Button 3 tapped")
            self.taskBtn.setTitle("Upcoming".localizeString(string: lang), for: .normal)
            self.workingStatu = "1"
            self.getTask(id: "\(self.project_id)", filter: self.date_selection, workingStatus: "1")
        }
        
        let dismissAction = UIAlertAction(title: "Dismiss".localizeString(string: lang), style: .cancel, handler: nil)
        // Set the text color of the buttons to black
        alertController.view.tintColor = .black
        dismissAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        // Add the buttons to the alert controller
        alertController.addAction(button1)
        alertController.addAction(button2)
        alertController.addAction(button3)
        alertController.addAction(button4)
        alertController.addAction(dismissAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    //MARK: Project Picker
    func projectPicker()
    {
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        // Create a UIAlertController with a UIPickerView
        alertController = UIAlertController(title: "Select an Option".localizeString(string: lang), message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        // Add the UIPickerView to the UIAlertController
        alertController.view.addSubview(pickerView)
        
        // Define actions for the UIAlertController
        //                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let selectAction = UIAlertAction(title: "Submit".localizeString(string: lang), style: .default) { [weak self] (action) in
            if let selectedRow = self?.pickerView.selectedRow(inComponent: 0) {
                let selectedOption = self?.showData[selectedRow].name ?? ""
                self?.filterBtn.setTitle(selectedOption, for: .normal)
                print(selectedOption ?? "" + "Hello".localizeString(string: lang))
                self?.project_id = self?.showData[selectedRow].id ?? 0
                self?.getTask(id: "\(self?.project_id ?? 0)", filter: self?.date_selection ?? "", workingStatus: self?.workingStatu ?? "")
            }
        }
        // Add actions to the UIAlertController
        //                alertController.addAction(cancelAction)
        alertController.addAction(selectAction)
        // Configure the UIPickerView
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -40).isActive = true
        pickerView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 10).isActive = true
    }
    
    //MARK: Choose Date
    func chooseDate() {
        ksceneDelegate?.popOut = false
        let fastisController = FastisController(mode: .range)
        fastisController.title = "Choose range".localizeString(string: lang)
        //        fastisController.maximumDate = Date()
        fastisController.allowToChooseNilDate = true
        fastisController.allowDateRangeChanges = true
        fastisController.shortcuts = [.today, .lastWeek]
        fastisController.doneHandler = { resultRange in
            print(resultRange)
            if resultRange != nil{
                if let todata = resultRange?.toDate, let fromdata = resultRange?.fromDate{
                    self.changeDate(toDate: todata, fromDate: fromdata)
                }
            }
        }
        fastisController.present(above: self)
    }
    
    func changeDate(toDate: Date , fromDate: Date)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"//"E d MMM"
        let tostring = dateFormatter.string(from: toDate)
        print(tostring)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "d MMM"//"E d MMM"
        let fromstring = dateFormatter1.string(from: fromDate)
        print(fromstring)
        let finals = fromstring + " - " + tostring
        changeDateBtn.setTitle(finals, for: .normal)
        date_selection = finals
        getTask(id: "\(self.project_id ?? 0)", filter: finals, workingStatus: self.workingStatu ?? "")
        
    }
    
}
extension WorkerTimeCardVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tcCell", for: indexPath) as! TimeCardTVC
        let searchItem = filteredData[indexPath.row]
        cell.detailsBtn.addTarget(self, action: #selector(detailsBtnTap(_:)), for: .touchUpInside)
        cell.detailsBtn.tag = indexPath.row
        cell.routeBtn.addTarget(self, action: #selector(routeBtnTap(_:)), for: .touchUpInside)
        cell.routeBtn.tag = indexPath.row
        configureCell(cell, with: searchItem)
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func routeBtnTap(_ sender: UIButton){
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WorkerRouteVC") as? WorkerRouteVC{
            VC.hidesBottomBarWhenPushed = true
            VC.taskID = searchData[sender.tag].id
            VC.endLat = Double(searchData[sender.tag].servicelat) ?? 0.0
            VC.endLng = Double(searchData[sender.tag].servicelong) ?? 0.0
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @objc func detailsBtnTap(_ sender: UIButton){
        checkDetails(latitude: lat, longitude: long, task_id: searchData[sender.tag].id, tag: sender.tag)
        
    }
}
extension WorkerTimeCardVC: UIPickerViewDelegate, UIPickerViewDataSource {
    // UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return showData.count
    }
    
    // UIPickerViewDelegate methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return showData[row].name
    }
}

//MARK: Location
extension WorkerTimeCardVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            // Do something with the latitude and longitude values
            print("Latitude: \(latitude), Longitude: \(longitude)")
            
            lat  = latitude
            long = longitude
            // You can stop updating location if you only need it once
            //            saveLatLng(latitude: latitude, longitude: longitude)
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
                    //get location
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
        case .notDetermined:
            break // Handle the case where the user hasn't made a decision yet
        @unknown default:
            break
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            //                locationLabel.text = "Location Services Disabled"
        }
    }
    
    func openAppSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
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
    
    
}

//MARK: API Integration
extension WorkerTimeCardVC {
    
    //MARK: Get Project API
    func getProject()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let url = "\(ApiLink.HOST_URL)/assignproject"
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
                           let loginResponse = try? JSONDecoder().decode(GetProjectInfo.self, from: jsonData) {
                            self.showData.removeAll()
                            self.showData.append(showProject.init(id: 0, name: "All Projects"))
                            self.filterBtn.setTitle("All Projects", for: .normal)
                            for i in 0..<loginResponse.data.count{
                                self.showData.append(showProject.init(id: loginResponse.data[i].id, name: loginResponse.data[i].project_name))
                            }
                            self.project_id = self.showData[0].id
                            self.getTask(id: "\(self.project_id)", filter: "", workingStatus: self.workingStatu ?? "")
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
                        self.filterBtn.setTitle("", for: .normal)
                        self.searchData.removeAll()
                        self.timeCardTV.reloadData()
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
    func getTask(id: String, filter: String, workingStatus: String)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        var ids:String = ""
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/tasktfetch"
        if(id == "0"){
            ids = "all"
        }else{
            ids = id
        }
        param = ["project": ids, "date_filter": filter, "working_status": workingStatus]
        print(param)
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
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
                           let loginResponse = try? JSONDecoder().decode(GetTaskInfo.self, from: jsonData) {
                            self.searchData.removeAll()
                            self.changeDateBtn.setTitle(loginResponse.filter, for: .normal)
                            self.date_selection = loginResponse.filter
                            if loginResponse.data.count < 1{
                                _ = SweetAlert().showAlert("", subTitle: "No task data found for selected date range.".localizeString(string: lang), style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
                            }
                            for i in 0..<loginResponse.data.count{
                                self.searchData.append(search.init(workingType: loginResponse.data[i].status, name: "", taskTitle: loginResponse.data[i].task_title, dateRange: loginResponse.data[i].start_date + " - " + loginResponse.data[i].end_date, startTime: loginResponse.data[i].start_time, id: loginResponse.data[i].id, endTime: loginResponse.data[i].end_time, breakTime: loginResponse.data[i].break, servicelat: loginResponse.data[i].site_latitude, servicelong: loginResponse.data[i].site_longitude, type: loginResponse.data[i].note_message, timeCardType: 0, createBy: 0, taskName: "", hours: "", minutes: ""))
                            }
                            
                            self.filteredData = self.searchData
                            progressHUD.hide()
                            //                            if ksceneDelegate?.popOut == false{
                            DispatchQueue.main.async {
                                self.timeCardTV.delegate = self
                                self.timeCardTV.dataSource = self
                                self.timeCardTV.reloadData()
                            }
                            //                            }
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
                        self.searchData.removeAll()
                        self.timeCardTV.reloadData()
                        self.filteredData.removeAll()
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
                    }else if self.status == 201{
                        progressHUD.hide()
                        self.searchData.removeAll()
                        self.filteredData.removeAll()
                        self.changeDateBtn.setTitle( dict["filter"] as? String, for: .normal)
                        self.timeCardTV.reloadData()
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
                    }else{
                        progressHUD.hide()
                        self.searchData.removeAll()
                        self.filteredData.removeAll()
                        self.timeCardTV.reloadData()
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
                    }
                    
                    
                case .failure(_):
                    progressHUD.hide()
                    self.searchData.removeAll()
                    self.filteredData.removeAll()
                    self.timeCardTV.reloadData()
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
    
    //MARK: Check Details Button Tap Status API
    func checkDetails(latitude: Double, longitude: Double, task_id: Int , tag: Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/check_distance"
        param = ["latitude": latitude, "longitude": longitude, "task_id": task_id]
        print(param)
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
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
                            
                            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WorkerProjectDetailsVC") as? WorkerProjectDetailsVC{
                                VC.hidesBottomBarWhenPushed = true
                                VC.pid = task_id
                                VC.servicelat = Double(self.searchData[tag].servicelat) ?? 0.0
                                VC.servicelng = Double(self.searchData[tag].servicelong) ?? 0.0
                                self.navigationController?.pushViewController(VC, animated: true)
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
    
}


extension WorkerTimeCardVC: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
        timeCardTV.reloadData()
    }
    
    // MARK: - Helper Methods
    
    func configureCell(_ cell: TimeCardTVC, with searchItem: search) {
        // Configure cell with search item details
        cell.topName.text = searchItem.taskTitle
        cell.topDate.text = searchItem.dateRange
        cell.startTime.text = searchItem.startTime
        cell.endTime.text = searchItem.endTime
        cell.carLabel.text = searchItem.type
        cell.checkType.text = searchItem.workingType
        cell.detailsBtn.setTitle("Details".localizeString(string: lang), for: .normal)
        cell.routeBtn.setTitle("Route".localizeString(string: lang), for: .normal)
        cell.startLabel.text = "Start Work".localizeString(string: lang)
        cell.finishLabel.text = "Finish Work".localizeString(string: lang)
        if cell.checkType.text == "Ongoing".localizeString(string: lang){
            //            cell.checkType.textColor = .systemYellow
        }else if cell.checkType.text == "Upcoming".localizeString(string: lang){
            //            cell.checkType.textColor = .systemOrange
        }else if cell.checkType.text == "Completed".localizeString(string: lang){
            //            cell.checkType.textColor = .systemGreen
        }else{
            //            cell.checkType.textColor = .systemRed
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredData = searchData.filter { searchItem in
            return searchItem.taskTitle.lowercased().contains(searchText.lowercased())
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.endEditing(true)
    }
}
