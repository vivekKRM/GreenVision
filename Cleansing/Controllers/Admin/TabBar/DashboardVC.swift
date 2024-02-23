//
//  DashboardVC.swift
//  surfers
//
//  Created by United It Services on 21/08/23.
//

import UIKit
import CoreLocation
import Alamofire
class DashboardVC: UIViewController {
    
    @IBOutlet weak var dashboardTV: UITableView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var InactiveWorker: UIView!
    @IBOutlet weak var activeWorker: UIView!
    @IBOutlet weak var activeCount: UILabel!
    @IBOutlet weak var inactiveCount: UILabel!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var inactiveLabel: UILabel!
    @IBOutlet weak var activeLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var dashboardData = [dashboard]()
    var status:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callFirst()
//        if locationLabel.text == "Location Access Denied"{
//            locationAlert()
//        }
    }
    
}

//MARK: First Call
extension DashboardVC {
    
    func callFirst()
    {
        self.navigationController?.isNavigationBarHidden  = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
//        checkLocationServices()//Commented on 30 Nov
        userImage.layer.cornerRadius = 10//30
        userImage.layer.masksToBounds = true
        activeWorker.dropShadowWithBlackColor()
        InactiveWorker.dropShadowWithBlackColor()
        self.title = "My Dashboard".localizeString(string: lang)
        let gesture2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userViewTapped(_:)))
        gesture2.numberOfTapsRequired = 1
        userView?.isUserInteractionEnabled = true
        userView?.addGestureRecognizer(gesture2)
        topLabel.text = "Here are your project/task overview".localizeString(string: lang)
        bottomLabel.text = "Here are your employee overview".localizeString(string: lang)
        activeLabel.text = "Active".localizeString(string: lang)
        inactiveLabel.text = "InActive".localizeString(string: lang)
        
        bellIconNavi()
        
    }
    
    func bellIconNavi()
    {
        let bellButton = UIButton(type: .system)
        bellButton.setImage(UIImage(systemName: "bell"), for: .normal)
        bellButton.addTarget(self, action: #selector(bellButtonTapped), for: .touchUpInside)
        bellButton.tintColor = UIColor.black
        let bellBarButtonItem = UIBarButtonItem(customView: bellButton)
        navigationItem.rightBarButtonItem = bellBarButtonItem
    }
    @objc func bellButtonTapped() {
        // Handle the bell button tap event
        print("Bell button tapped")
    }
    
    @objc func userViewTapped(_ sender: UITapGestureRecognizer)
    {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC{
            VC.hidesBottomBarWhenPushed = true
                 self.navigationController?.pushViewController(VC, animated: true)
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

extension DashboardVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dCell", for: indexPath) as! AdminDashTVC
        let leftIndex = indexPath.row * 2
            let rightIndex = leftIndex + 1
            
            // Make sure the indices are within the bounds of your data array
            if leftIndex < dashboardData[indexPath.section].name.count {
                cell.leftTitle.text = dashboardData[indexPath.section].name[leftIndex]
                cell.leftValue.text = "\(dashboardData[indexPath.section].count[leftIndex])"
            } else {
                // Handle the case where the index is out of bounds (optional)
                cell.leftTitle.text = ""
                cell.leftValue.text = ""
            }

            if rightIndex < dashboardData[indexPath.section].name.count {
                cell.rightTitle.text = dashboardData[indexPath.section].name[rightIndex]
                cell.rightValue.text = "\(dashboardData[indexPath.section].count[rightIndex])"
            } else {
                // Handle the case where the index is out of bounds (optional)
                cell.rightTitle.text = ""
                cell.rightValue.text = ""
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

}
//MARK: Location
extension DashboardVC: CLLocationManagerDelegate {
    
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
//                    self.locationLabel.text = "\(location),\(locality),\(state),\(country)"
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
    
//    func checkLocationServices() {
//           if CLLocationManager.locationServicesEnabled() {
//               locationManager.requestWhenInUseAuthorization()
//           } else {
//               locationLabel.text = "Location Services Disabled"
//           }
//       }
    
    func openAppSettings() {
           if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
               if UIApplication.shared.canOpenURL(settingsUrl) {
                   UIApplication.shared.open(settingsUrl, completionHandler: nil)
               }
           }
       }
    
    
}

//MARK: API Integartion
extension DashboardVC{
    
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
        let url = "\(ApiLink.HOST_URL)/manager_dashboard"
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
                            
                            self.userName.text =   "Hello, ".localizeString(string: lang) + loginResponse.data.name
                            self.userEmail.text = loginResponse.data.email
                            self.activeCount.text = "\(loginResponse.data.active_users)"
                            self.inactiveCount.text = "\(loginResponse.data.inactive_users)"
                            self.dashboardData.removeAll()
                            self.getImageFromURL(imageView: self.userImage, stringURL:  (loginResponse.data.profile_image ?? ""))
                            self.dashboardData.append(dashboard.init(image: ["target-form", "completed","remaming-form","upcoming"], name: ["All".localizeString(string: lang),"Completed".localizeString(string: lang),"OnGoing".localizeString(string: lang),"Upcoming".localizeString(string: lang)], count: [loginResponse.data.all_projects , loginResponse.data.completed_projects , loginResponse.data.ongoing_projects , loginResponse.data.upcoming_projects]))
                            
                            progressHUD.hide()
                            
                            self.dashboardTV.delegate = self
                            self.dashboardTV.dataSource = self
                            self.dashboardTV.reloadData()
                            
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
