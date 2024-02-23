//
//  WorkerDashVC.swift
//  Cleansing
//
//  Created by United It Services on 01/09/23.
//

import UIKit
import CoreLocation
import Alamofire
class WorkerDashVC: UIViewController {

    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var workerDashTV: UITableView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var earningLabel: UILabel!
    @IBOutlet weak var totalHrs: UILabel!
    
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var dashboardLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalHrLabel: UILabel!
    
    var count = 0
    var status:Int = 0
    let locationManager = CLLocationManager()
    var dashboardData = [dashboard]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callFirst()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden  = false
    }
    
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension WorkerDashVC {
    
    func callFirst()
    {
        lang = UserDefaults.standard.string(forKey: "Lang") ?? "en"
        self.navigationController?.isNavigationBarHidden  = true
        locationLabel.text = "Current Location".localizeString(string: lang)
        dashboardLabel.text = "Dashboard".localizeString(string: lang)
        totalLabel.text = "Total Earning".localizeString(string: lang)
        totalHrLabel.text = "Total Hrs Spent".localizeString(string: lang)
        overview.text = "Project Overview".localizeString(string: lang)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        checkLocationServices()
        firstView.dropShadowWithBlackColor()
        userImage.layer.cornerRadius = 30
        userImage.layer.masksToBounds = true
        let gesture2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userViewTapped(_:)))
        gesture2.numberOfTapsRequired = 1
        firstView?.isUserInteractionEnabled = true
        firstView?.addGestureRecognizer(gesture2)
        if locationLabel.text == "Location Access Denied".localizeString(string: lang){
//            locationAlert()//commented for app upload
        }
    }
    
    
    
    @objc func userViewTapped(_ sender: UITapGestureRecognizer)
    {
        self.tabBarController?.selectedIndex = 3
    }
   
}

extension WorkerDashVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashboardData[section].name.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dCell", for: indexPath) as! DashboardTVC
        cell.dashImage.image = UIImage(named: dashboardData[indexPath.section].image[indexPath.row])
        cell.dashCount.text = "\(dashboardData[indexPath.section].count[indexPath.row])"
        cell.dashTitle.text = dashboardData[indexPath.section].name[indexPath.row]
        
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

//        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GooglePathVC") as? GooglePathVC{
//                 self.navigationController?.pushViewController(VC, animated: true)
//             }
    }

}
//MARK: Location
extension WorkerDashVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        if let location = locations.last {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                
                // Do something with the latitude and longitude values
                print("Latitude: \(latitude), Longitude: \(longitude)")
//            if count < 1{
//                count+=1
                workerDashboard(latitude: latitude, longitude: longitude)
            
//                saveLatLng(latitude: latitude, longitude: longitude)
                
//            }
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
                if let country = placemark.country ,let locality = placemark.locality, let location = placemark.subLocality, let state = placemark.administrativeArea{
                    self.locationLabel.text = "\(location),\(locality),\(state),\(country)"
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
            locationLabel.text = "Location Access Denied".localizeString(string: lang)
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
                locationLabel.text = "Location Services Disabled".localizeString(string: lang)
            }
        }
}
//MARK: API Integration
extension WorkerDashVC {
    
    //MARK: Dashboard API
    func workerDashboard(latitude: Double, longitude: Double)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let fcmToken:String = UserDefaults.standard.string(forKey: "fcm") ?? ""
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/dashboard"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["latitude": latitude, "longitude": longitude, "fcm_token": fcmToken]
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
                               let loginResponse = try? JSONDecoder().decode(WorkDashInfo.self, from: jsonData) {
                                self.dashboardData.removeAll()
                                self.nameLabel.text = "Hello, ".localizeString(string: lang) + loginResponse.data.name
                                self.emailLabel.text = loginResponse.data.email
                                self.earningLabel.text = "$ " + "\(loginResponse.data.total_earning ?? 0.0)"
                                self.totalHrs.text = loginResponse.data.spend_time
                                self.getImageFromURL(imageView: self.userImage, stringURL:  (loginResponse.data.profile_image ?? ""))
                                self.dashboardData.append(dashboard.init(image: ["target-form", "completed","remaming-form","upcoming"], name: ["All Projects".localizeString(string: lang),"Completed Projects".localizeString(string: lang),"OnGoing Projects".localizeString(string: lang),"Upcoming Projects".localizeString(string: lang)], count: [loginResponse.data.all_projects , loginResponse.data.completed_projects , loginResponse.data.ongoing_projects , loginResponse.data.upcoming_projects]))
                                
                                
                                progressHUD.hide()
                
                                self.workerDashTV.delegate = self
                                self.workerDashTV.dataSource = self
                                self.workerDashTV.reloadData()
                                self.updateToken()
                                
                                
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
    
    //MARK: Update Token
    func updateToken()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        var appVersions:String = ""
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            print("Current App Version: \(appVersion)")
            appVersions =  appVersion
        } else {
            print("Unable to retrieve app version.")
        }
        let fcmToken:String = UserDefaults.standard.string(forKey: "fcm") ?? ""
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/update_fcm"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["device_type": "ios", "app_version": appVersions, "fcm_token": fcmToken]
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
extension WorkerDashVC{
    
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
    
    
    func openAppSettings() {
           if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
               if UIApplication.shared.canOpenURL(settingsUrl) {
                   UIApplication.shared.open(settingsUrl, completionHandler: nil)
               }
           }
       }
}
