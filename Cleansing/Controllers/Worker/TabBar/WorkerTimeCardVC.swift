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
class WorkerTimeCardVC: UIViewController {
    @IBOutlet weak var timeCardTV: UITableView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var changeDateView: UIView!
    @IBOutlet weak var changeDateBtn: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
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
//    var data = ["Home Cleaning", "Deep Cleaning", "Post-Construction", "Pre-Construction"]
    var searchData = [search]()
    var showData = [showProject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tasks"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        checkLocationServices()
        firstCall()
        
    }
    
    
    
    @IBAction func changeDateBtnTap(_ sender: UIButton) {
//        if lat > 0.0{
            chooseDate()
//        }else{
//            locationAlert()
//        }
    }
    
    
    @IBAction func filterBtnTap(_ sender: UIButton) {
        present(alertController, animated: true)
    }
    
    
    @IBAction func segmentControlChange(_ sender: UISegmentedControl) {
//        if lat > 0.0{
            if sender.selectedSegmentIndex == 0 {
                workingStatu = ""
                getTask(id: self.project_id, filter: date_selection, workingStatus: "")
                //            searchData.removeAll()
                //            searchData.append(search.init(clockType: ["COMPLETED", "ONGOING","UPCOMING"], name: ["House Cleaning","Bathroom Cleaning","Bedroom Cleaning"], dateRange: ["10 Aug - 25 Aug", "3 Sep - 12 Sep","22 Oct - 30 Oct"], startTime: ["12:05 PM","02:32 PM", "__:__ "], id: ["1","2","3"], amount: ["$ 100","$ 50","$75"], endTime: ["5:00 PM","__:__ ","__:__ "], breakTime: ["15 Min","30 Min","__ Min"]))
                //            timeCardTV.reloadData()
            }else if sender.selectedSegmentIndex == 1{
                workingStatu = "2"
                getTask(id: self.project_id, filter: date_selection, workingStatus: "2")
                //            searchData.removeAll()
                //            searchData.append(search.init(clockType: ["UPCOMING", "ONGOING","COMPLETED"], name: ["Bedroom Cleaning","Bathroom Cleaning","House Cleaning"], dateRange: ["22 Oct - 30 Oct", "3 Sep - 12 Sep","10 Aug - 25 Aug"], startTime: [ "__:__ ","02:32 PM","12:05 PM"], id: ["1","2","3"], amount: ["$ 75","$ 50","$ 100"], endTime: ["__:__ ","__:__ ","5:00 PM"], breakTime: ["__ Min","30 Min","15 Min"]))
                //            timeCardTV.reloadData()
            }else if sender.selectedSegmentIndex == 2{
                workingStatu = "1"
                getTask(id: self.project_id, filter: date_selection, workingStatus: "1")
                //            searchData.removeAll()
                //            searchData.append(search.init(clockType: ["UPCOMING", "ONGOING","COMPLETED"], name: ["Bedroom Cleaning","Bathroom Cleaning","House Cleaning"], dateRange: ["22 Oct - 30 Oct", "3 Sep - 12 Sep","10 Aug - 25 Aug"], startTime: [ "__:__ ","02:32 PM","12:05 PM"], id: ["1","2","3"], amount: ["$ 75","$ 50","$ 100"], endTime: ["__:__ ","__:__ ","5:00 PM"], breakTime: ["__ Min","30 Min","15 Min"]))
                //            timeCardTV.reloadData()
            }else{
                workingStatu = "3"
                getTask(id: self.project_id, filter: date_selection, workingStatus: "3")
                //            searchData.removeAll()
                //            searchData.append(search.init(clockType: ["COMPLETED", "ONGOING","UPCOMING"], name: ["House Cleaning","Bathroom Cleaning","Bedroom Cleaning"], dateRange: ["10 Aug - 25 Aug", "3 Sep - 12 Sep","22 Oct - 30 Oct"], startTime: ["12:05 PM","02:32 PM", "__:__ "], id: ["1","2","3"], amount: ["$ 100","$ 50","$75"], endTime: ["5:00 PM","__:__ ","__:__ "], breakTime: ["15 Min","30 Min","__ Min"]))
                //            timeCardTV.reloadData()
            }
//        }else{
//            locationAlert()
//        }
    }
    
    
}
extension WorkerTimeCardVC {
    
    func firstCall()
    {
        let customFont = UIFont(name: "Poppins-Medium", size: 14.0)
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: customFont as Any,
            NSAttributedString.Key.foregroundColor: UIColor.black // Change to your desired color
        ]
        segmentControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: customFont as Any,
            NSAttributedString.Key.foregroundColor: UIColor.white // Change to your desired color
        ]
        segmentControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        changeDateView.layer.masksToBounds = true
        changeDateView.layer.cornerRadius = 5
//        if lat > 0.0{
            getProject()//API
            projectPicker()//Picker
//        }else{
//            locationAlert()
//        }
        
       
    }
    //MARK: Project Picker
    func projectPicker()
    {
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        // Create a UIAlertController with a UIPickerView
        alertController = UIAlertController(title: "Select an Option", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        // Add the UIPickerView to the UIAlertController
        alertController.view.addSubview(pickerView)
        
        // Define actions for the UIAlertController
        //                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let selectAction = UIAlertAction(title: "Submit", style: .default) { [weak self] (action) in
            if let selectedRow = self?.pickerView.selectedRow(inComponent: 0) {
                let selectedOption = self?.showData[selectedRow].name ?? ""
                self?.filterBtn.setTitle(selectedOption, for: .normal)
                print(selectedOption ?? "" + "Hello")
                self?.project_id = self?.showData[selectedRow].id ?? 0
                self?.getTask(id: self?.project_id ?? 0, filter: self?.date_selection ?? "", workingStatus: self?.workingStatu ?? "")
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
        let fastisController = FastisController(mode: .range)
        fastisController.title = "Choose range"
//        fastisController.maximumDate = Date()
        fastisController.allowToChooseNilDate = true
        fastisController.allowDateRangeChanges = true
        fastisController.shortcuts = [.today, .lastWeek]
        fastisController.doneHandler = { resultRange in
        print(resultRange)
            if let todata = resultRange?.toDate, let fromdata = resultRange?.fromDate{
                self.changeDate(toDate: todata, fromDate: fromdata)
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
        getTask(id: self.project_id ?? 0, filter: finals, workingStatus: self.workingStatu ?? "")
        
    }
    
}
extension WorkerTimeCardVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tcCell", for: indexPath) as! TimeCardTVC
        cell.topName.text = searchData[indexPath.row].taskTitle
        cell.topDate.text = searchData[indexPath.row].dateRange
        cell.startTime.text = searchData[indexPath.row].startTime
        cell.endTime.text = searchData[indexPath.row].endTime
        cell.carLabel.text = searchData[indexPath.row].type
        cell.checkType.text = searchData[indexPath.row].workingType
        cell.detailsBtn.addTarget(self, action: #selector(detailsBtnTap(_:)), for: .touchUpInside)
        cell.detailsBtn.tag = indexPath.row
        cell.routeBtn.addTarget(self, action: #selector(routeBtnTap(_:)), for: .touchUpInside)
        cell.routeBtn.tag = indexPath.row
        if cell.checkType.text == "Ongoing"{
            cell.checkType.textColor = .systemYellow
        }else if cell.checkType.text == "Upcoming"{
            cell.checkType.textColor = .systemOrange
        }else if cell.checkType.text == "Completed"{
            cell.checkType.textColor = .systemGreen
        }else{
            cell.checkType.textColor = .systemRed
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
    
    @objc func routeBtnTap(_ sender: UIButton){
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WorkerRouteVC") as? WorkerRouteVC{
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
                locationAlert()
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
            string: "Location access denied. Please enable location services from iPhone settings",
            attributes: [NSAttributedString.Key.font: customFont as Any]
        )
        let alertController = UIAlertController(
            title: "",
            message: "",
            preferredStyle: .alert
        )
        alertController.setValue(attributedString, forKey: "attributedMessage")
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
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
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
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
                            self.filterBtn.setTitle(loginResponse.data[0].project_name, for: .normal)
                            for i in 0..<loginResponse.data.count{
                                self.showData.append(showProject.init(id: loginResponse.data[i].id, name: loginResponse.data[i].project_name))
                            }
                            self.project_id = self.showData[0].id
                            self.getTask(id: self.showData[0].id, filter: "", workingStatus: self.workingStatu ?? "")
                            progressHUD.hide()
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
                        self.filterBtn.setTitle("", for: .normal)
                        self.searchData.removeAll()
                        self.timeCardTV.reloadData()
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
    
    
    //MARK: Get Task API
    func getTask(id: Int, filter: String, workingStatus: String)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/tasktfetch"
        param = ["project": String(id), "date_filter": filter, "working_status": workingStatus]
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
                            for i in 0..<loginResponse.data.count{
                                self.searchData.append(search.init(workingType: loginResponse.data[i].status, name: "", taskTitle: loginResponse.data[i].task_title, dateRange: loginResponse.data[i].start_date + " - " + loginResponse.data[i].end_date, startTime: loginResponse.data[i].start_time, id: loginResponse.data[i].id, endTime: loginResponse.data[i].end_time, breakTime: loginResponse.data[i].break, servicelat: loginResponse.data[i].site_latitude, servicelong: loginResponse.data[i].site_longitude, type: loginResponse.data[i].note_message))
                            }
                            progressHUD.hide()
                            DispatchQueue.main.async {
                                self.timeCardTV.delegate = self
                                self.timeCardTV.dataSource = self
                                self.timeCardTV.reloadData()
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
                        self.searchData.removeAll()
                        self.timeCardTV.reloadData()
                        
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK")
                    }else if self.status == 201{
                        progressHUD.hide()
                        self.searchData.removeAll()
                        self.changeDateBtn.setTitle( dict["filter"] as? String, for: .normal)
                        self.timeCardTV.reloadData()
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.warning,buttonTitle:"OK")
                    }else{
                        progressHUD.hide()
                        self.searchData.removeAll()
                        self.timeCardTV.reloadData()
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
    
    //MARK: Check Details Button Tap Status API
    func checkDetails(latitude: Double, longitude: Double, task_id: Int , tag: Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
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
                                VC.pid = task_id
                                VC.servicelat = Double(self.searchData[tag].servicelat) ?? 0.0
                                VC.servicelng = Double(self.searchData[tag].servicelong) ?? 0.0
                                self.navigationController?.pushViewController(VC, animated: true)
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
    
}
