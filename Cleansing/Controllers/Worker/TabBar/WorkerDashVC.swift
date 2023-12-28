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

    
    
    @IBOutlet weak var workerDashTV: UITableView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var earningLabel: UILabel!
    @IBOutlet weak var totalHrs: UILabel!
    
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
        if locationLabel.text == "Location Access Denied"{
            locationAlert()
        }
    }
    
}

extension WorkerDashVC {
    
    func callFirst()
    {
        self.navigationController?.isNavigationBarHidden  = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        checkLocationServices()
        UserDefaults.standard.setValue(true, forKey: "signed")
        
        firstView.dropShadowWithBlackColor()
//        firstView.backgroundColor = UIColor(hexString: "b4eeb4")
//        firstView.applyGradient(colours: [UIColor(red: 130/255, green: 223/255, blue: 72/255, alpha: 1.0),UIColor(red: 68/255, green: 198/255, blue: 92/255, alpha: 1.0)])
        
        
        userImage.layer.cornerRadius = 10
        userImage.layer.masksToBounds = true
        let gesture2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userViewTapped(_:)))
        gesture2.numberOfTapsRequired = 1
        firstView?.isUserInteractionEnabled = true
        firstView?.addGestureRecognizer(gesture2)
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
                workerDashboard(latitude: latitude, longitude: longitude, fcmToken: 1)
            
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
                if let locality = placemark.locality, let country = placemark.country {
                    self.locationLabel.text = "\(locality), \(country)"
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
                   locationLabel.text = "Location Access Denied"
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
                locationLabel.text = "Location Services Disabled"
            }
        }
}
//MARK: API Integration
extension WorkerDashVC {
    
    //MARK: Dashboard API
    func workerDashboard(latitude: Double, longitude: Double, fcmToken: Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
      
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
                               let loginResponse = try? JSONDecoder().decode(DashboardInfo.self, from: jsonData) {
                                self.dashboardData.removeAll()
                                self.nameLabel.text = loginResponse.data.name
                                self.emailLabel.text = loginResponse.data.email
                                self.earningLabel.text = "$ " + "\(loginResponse.data.total_earning)"
                                self.totalHrs.text = loginResponse.data.spend_time
                                self.getImageFromURL(imageView: self.userImage, stringURL:  (loginResponse.data.profile_image ?? ""))
                                self.dashboardData.append(dashboard.init(image: ["target-form", "completed","remaming-form","upcoming"], name: ["All Projects","Completed Projects","OnGoing Projects","Upcoming Projects"], count: [loginResponse.data.all_projects , loginResponse.data.completed_projects , loginResponse.data.ongoing_projects , loginResponse.data.upcoming_projects]))
                                
                                
                                progressHUD.hide()
                                
                                self.workerDashTV.delegate = self
                                self.workerDashTV.dataSource = self
                                self.workerDashTV.reloadData()
                                
                                
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
extension WorkerDashVC{
    
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
    
    
    func openAppSettings() {
           if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
               if UIApplication.shared.canOpenURL(settingsUrl) {
                   UIApplication.shared.open(settingsUrl, completionHandler: nil)
               }
           }
       }
}
