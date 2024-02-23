//
//  AdminTimeCardVC.swift
//  Cleansing
//
//  Created by UIS on 01/12/23.
//

import UIKit
import Alamofire
import Fastis
import CoreLocation

class AdminTimeCardVC: UIViewController {

    @IBOutlet weak var taskListTV: UITableView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var changeDateView: UIView!
    @IBOutlet weak var changeDateBtn: UIButton!
    
    
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
    var worker = ""
    var statusF = "all"
    var approver = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Time Cards".localizeString(string: lang)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        lang = UserDefaults.standard.string(forKey: "Lang") ?? "en"
        self.tabBarController?.tabBar.isHidden = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        firstCall()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    @IBAction func changeDateBtnTap(_ sender: UIButton) {
        chooseDate()
    }
    
    
    @IBAction func filterBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TimeCardFilterVC") as? TimeCardFilterVC{
            VC.hidesBottomBarWhenPushed = true
            VC.dataCompletion = { [weak self] data in
                       print("Received data:", data)
                self?.worker = data[2] == "" ? "" : data[2]
                self?.statusF = data[0] == "" ? "all" : data[0]
                self?.approver = data[1] == "" ? "" : data[1]
//                UserDefaults.standard.setValue( self?.worker, forKey: "workerT")
//                UserDefaults.standard.setValue( self?.statusF, forKey: "statusT")
//                self?.getTask(filter: "",workers:data[2] == "" ? "all" : data[2], status: data[0] == "" ? "all" : data[0])
                   }
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    
    @IBAction func segmentControlChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            workingStatu = ""
        }else if sender.selectedSegmentIndex == 1{
            workingStatu = "2"
        }else if sender.selectedSegmentIndex == 2{
            workingStatu = "1"
        }else{
            workingStatu = "3"
        }
    }
    
    
}
extension AdminTimeCardVC {
    
    func firstCall()
    {
        let customFont = UIFont(name: "Poppins-Medium", size: 14.0)
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: customFont as Any,
            NSAttributedString.Key.foregroundColor: UIColor.black // Change to your desired color
        ]
//        segmentControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: customFont as Any,
            NSAttributedString.Key.foregroundColor: UIColor.white // Change to your desired color
        ]
//        segmentControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        changeDateView.layer.masksToBounds = true
        changeDateView.layer.cornerRadius = 5
        filterBtn.setTitle("Filters".localizeString(string: lang), for: .normal)
        floatingBtn()
        projectPicker()
        
        let filters = UserDefaults.standard.string(forKey: "dfilter") ?? ""
        worker = UserDefaults.standard.string(forKey: "workerT") ?? ""
        statusF = UserDefaults.standard.string(forKey: "statusT") ?? ""
        approver = UserDefaults.standard.string(forKey: "approverT") ?? ""
        getTask(filter: filters, workers: worker, status: statusF, approver: approver)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    //MARK: Add Floating Button
    func floatingBtn(){
        let floatingButton = UIButton(type: .system)
        floatingButton.frame = CGRect(x: UIScreen.main.bounds.width * 0.8, y: UIScreen.main.bounds.height * 0.8, width: 60, height: 60)
        floatingButton.backgroundColor =  UIColor.init(hexString: "5FB8EE")
        floatingButton.layer.cornerRadius = 30 // Half of the width
        floatingButton.setTitle("+", for: .normal)
        floatingButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        floatingButton.setTitleColor(UIColor.black, for: .normal)
        // Add a tap action to the button
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        // Add the floating button to the view
        view.addSubview(floatingButton)
    }
    
    @objc func floatingButtonTapped() {
        // Handle the button tap action
        print("Floating button tapped!")
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddAdminTimeCardVC") as? AddAdminTimeCardVC{
            VC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
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
//                self?.getTask(id: self?.project_id ?? 0, filter: self?.date_selection ?? "", workingStatus: self?.workingStatu ?? "")
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
        fastisController.title = "Choose range".localizeString(string: lang)
        //        fastisController.maximumDate = Date()
        fastisController.allowToChooseNilDate = true
        fastisController.allowDateRangeChanges = true
        fastisController.shortcuts = [.today, .lastWeek]
        fastisController.doneHandler = { resultRange in
            print(resultRange)
            if resultRange != nil{
                let todata = resultRange?.toDate
                let fromdata = resultRange?.fromDate
                self.changeDate(toDate: todata!, fromDate: fromdata!)
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
        UserDefaults.standard.set(finals, forKey: "dfilter")
        worker = UserDefaults.standard.string(forKey: "workerT") ?? ""
        statusF = UserDefaults.standard.string(forKey: "statusT") ?? ""
        approver = UserDefaults.standard.string(forKey: "approverT") ?? ""
        getTask(filter: finals, workers: worker, status: statusF, approver: approver)
        
    }
    
}
extension AdminTimeCardVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tlCell", for: indexPath) as! TaskListTVC
        cell.topName.text = searchData[indexPath.row].name
        cell.topDate.text = searchData[indexPath.row].dateRange
        cell.headName.text = searchData[indexPath.row].taskTitle
        cell.startTime.text = searchData[indexPath.row].startTime
        cell.endTime.text = searchData[indexPath.row].endTime
        cell.taskName.text = searchData[indexPath.row].taskName
        cell.breakDuration.text = searchData[indexPath.row].breakTime + "m"
        cell.manualgpsBtn.setTitle(searchData[indexPath.row].type, for: .normal)
        if searchData[indexPath.row].timeCardType == 1{
            cell.unlacHeight.constant = 30
            cell.unalloc.isHidden = false
        }else{
            cell.unlacHeight.constant = 0
            cell.unalloc.isHidden = true
        }
        if searchData[indexPath.row].workingType == "0"{
            cell.checkTypeView.backgroundColor = UIColor.init(hexString: "3CDACA")
            cell.checkType.text = "CLOCKED IN".localizeString(string: lang)
            cell.hourMinuteLabel.text = "(Working from:- " + searchData[indexPath.row].hours + "h:" +  searchData[indexPath.row].minutes + "m)"
            cell.hourMinuteLabel.textColor = UIColor.init(hexString: "3CDACA")
        }else if searchData[indexPath.row].workingType == "1"{
            cell.checkTypeView.backgroundColor = UIColor.init(hexString: "004080")
            cell.checkType.text = "CLOCKED OUT".localizeString(string: lang)
            cell.hourMinuteLabel.text = "(Total time:- " + searchData[indexPath.row].hours + "h:" +  searchData[indexPath.row].minutes + "m)"
            cell.hourMinuteLabel.textColor =  UIColor.init(hexString: "004080")
        }else{
            cell.checkTypeView.backgroundColor = UIColor.init(hexString: "F37290")
            cell.checkType.text = "APPROVED".localizeString(string: lang)
            cell.hourMinuteLabel.text = "(Total time:- " + searchData[indexPath.row].hours + "h:" +  searchData[indexPath.row].minutes + "m)"
            cell.hourMinuteLabel.textColor = UIColor.init(hexString: "F37290")
        }
//        }else if cell.checkType.text == "Completed"{
//            cell.checkTypeView.backgroundColor = .systemGreen
//        }else{
//            cell.checkTypeView.backgroundColor = .systemRed
//        }
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
        
        if searchData[indexPath.row].createBy == 3{
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdminDetailTimeCardMainVC") as? AdminDetailTimeCardMainVC{
                VC.hidesBottomBarWhenPushed = true
                VC.taskID = searchData[indexPath.row].id
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }else{
            
//            if searchData[indexPath.row].workingType == "0" {
//                _ = SweetAlert().showAlert("", subTitle: "You can not view or edit your working time card!".localizeString(string: lang), style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
//            }else{
                if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AdminDetailTimeCardMainVC") as? AdminDetailTimeCardMainVC{
                    VC.hidesBottomBarWhenPushed = true
                    VC.taskID = searchData[indexPath.row].id
                    self.navigationController?.pushViewController(VC, animated: true)
                }
//            }
        }
        
    }
    
//     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//         if self.searchData[indexPath.row].workingType == "0" ||  self.searchData[indexPath.row].workingType == "2"{
//
//         }else{
//             let deleteAction = UIContextualAction(style: .destructive, title: "Delete TimeCard") { (action, view, completion) in
//                 // Handle delete action here
//
//                 let refreshAlert = UIAlertController(title: "", message: "Do you want to delete this timecard ?", preferredStyle: UIAlertController.Style.alert)
//
//                 refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//                     print("Handle Cancel Logic here")
//                     refreshAlert .dismiss(animated: true, completion: nil)
//                 }))
//
//                 refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
//                     print("Handle Ok logic here")
//                      self.deleteTimeCard(id: self.searchData[indexPath.row].id)
//                     tableView.deleteRows(at: [indexPath], with: .automatic)
//                 }))
//                 self.present(refreshAlert, animated: true, completion: nil)
//
//                 completion(true)
//             }
//             let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
//             return swipeConfiguration
//         }
//         return nil
//       }

}
extension AdminTimeCardVC: UIPickerViewDelegate, UIPickerViewDataSource {
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
extension AdminTimeCardVC: CLLocationManagerDelegate {
    
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
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.openAppSettings()
            
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
}

//MARK: API Integration
extension AdminTimeCardVC {
    

    //MARK: Get TimeCard API
    func getTask(filter: String, workers:String, status: String, approver: String)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/get_time_card"
        param = ["date_filter": filter,"workers": workers, "status": status, "approver": approver]
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
                           let loginResponse = try? JSONDecoder().decode(GetTimeCardNewInfo.self, from: jsonData) {
                            self.searchData.removeAll()
                            self.changeDateBtn.setTitle(loginResponse.filter, for: .normal)
                            for i in 0..<loginResponse.timeCards.count{
                                self.searchData.append(search.init(workingType: "\(loginResponse.timeCards[i].approve)", name: loginResponse.timeCards[i].name, taskTitle: loginResponse.timeCards[i].short_name ,dateRange: loginResponse.timeCards[i].date, startTime: loginResponse.timeCards[i].start_time, id: loginResponse.timeCards[i].id, endTime: loginResponse.timeCards[i].end_time, breakTime: "\(loginResponse.timeCards[i].break)", servicelat: loginResponse.timeCards[i].site_latitude, servicelong: loginResponse.timeCards[i].site_longitude, type: loginResponse.timeCards[i].type, timeCardType: loginResponse.timeCards[i].timecard_type, createBy: loginResponse.timeCards[i].created_by, taskName: loginResponse.timeCards[i].task_name, hours: loginResponse.timeCards[i].hours, minutes: loginResponse.timeCards[i].minutes))
                            }
                            progressHUD.hide()
                            DispatchQueue.main.async {
                                self.taskListTV.delegate = self
                                self.taskListTV.dataSource = self
                                self.taskListTV.reloadData()
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
                        self.changeDateBtn.setTitle("Change Date".localizeString(string: lang), for: .normal)
                        self.searchData.removeAll()
                        self.taskListTV.reloadData()
                        
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
                    }else if self.status == 201{
                        progressHUD.hide()
                        self.changeDateBtn.setTitle("Change Date".localizeString(string: lang), for: .normal)
                        self.searchData.removeAll()
                        self.taskListTV.reloadData()
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
                    }else{
                        progressHUD.hide()
                        self.changeDateBtn.setTitle("Change Date".localizeString(string: lang), for: .normal)
                        self.searchData.removeAll()
                        self.taskListTV.reloadData()
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
    func deleteTimeCard(id : Int)
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
                           let loginResponse = try? JSONDecoder().decode(DefaultInfo.self, from: jsonData) {
                            progressHUD.hide()
                            _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.success,buttonTitle:"OK".localizeString(string: lang)){ (isOtherButton) -> Void in
                                if isOtherButton == true {
                                    let filter = UserDefaults.standard.string(forKey: "dfilter") ?? ""
                                    self.worker = UserDefaults.standard.string(forKey: "workerT") ?? ""
                                    self.statusF = UserDefaults.standard.string(forKey: "statusT") ?? ""
                                    self.approver = UserDefaults.standard.string(forKey: "approverT") ?? ""
                                    self.getTask(filter: filter, workers: self.worker, status: self.statusF, approver: self.approver)
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
}
