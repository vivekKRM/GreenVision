//
//  WorkerTBC.swift
//  Cleansing
//
//  Created by United It Services on 01/09/23.
//

import UIKit
import CoreLocation
import Alamofire
class WorkerTBC: UITabBarController {

    var status: Int = 0
    let locationManager = CLLocationManager()
    
       var lastUpdateTimestamp: TimeInterval = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        checkLocationServices()
        let tabBarAppearance = tabBar.standardAppearance
        tabBarAppearance.selectionIndicatorTintColor = UIColor.init(hexString: "004080")
        tabBar.standardAppearance = tabBarAppearance
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let yourView = self.viewControllers![self.selectedIndex] as! UINavigationController
        yourView.popToRootViewController(animated: false)
    }

  

}
//MARK: Location
extension WorkerTBC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        if let location = locations.last {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                // Do something with the latitude and longitude values
                print("Latitude: \(latitude), Longitude: \(longitude)")
                print("Work on TabBar Main")
                saveLatLng(latitude: latitude, longitude: longitude)
                // You can stop updating location if you only need it once
               
            }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                if let locality = placemark.locality, let country = placemark.country {
//                    self.locationLabel.text = "\(locality), \(country)"
                }
            }
        }
        
        // Update the last update timestamp
                   lastUpdateTimestamp = Date().timeIntervalSince1970
                   
                   // Stop updating location after successfully getting the location
                   locationManager.stopUpdatingLocation()
                   // Invalidate the timer to stop it
//
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
                locationUpdateTimer = Timer.scheduledTimer(timeInterval: 600, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)

            } else {
//                locationLabel.text = "Location Services Disabled"
            }
        }
    
    @objc func updateLocation() {
        print("Timer fired!")
        // Request a single location update
        locationManager.requestLocation()
    }
}
extension WorkerTBC{
    
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


//MARK: API Integartion
extension WorkerTBC{

    //MARK: Save LatLng API
    func saveLatLng(latitude: Double, longitude: Double)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
      
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/track_user"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["latitude": latitude, "longitude": longitude]
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
