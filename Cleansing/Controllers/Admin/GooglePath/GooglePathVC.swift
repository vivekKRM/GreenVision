//
//  GooglePathVC.swift
//  Cleansing
//
//  Created by United It Services on 30/08/23.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
class GooglePathVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var journeySV: UIStackView!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var endView: UIView!
    
    //Prompt View
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var traveldistance: UILabel!
    @IBOutlet weak var traveltime: UILabel!
    @IBOutlet weak var okBtn: UIButton!
    
    
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var status:Int = 0
    var reachStatus:Int = 0
    var count = 0
    var taskID: Int = 0
    var destinationAnnotation: MKPointAnnotation!
    var sourceAnnotation: MKPointAnnotation!
    var currentRoute: MKRoute?
    var startLat = 0.0
    var startLng = 0.0
    var endLat = 0.0
    var endLng = 0.0
    var timecard_id: Int = 0
    var comingFrom: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()//added on 30 Nov
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    
    
    @IBAction func mapBtnTap(_ sender: UIButton) {
        let latitude = endLat // Replace with your desired latitude
            let longitude = endLng // Replace with your desired longitude

            if let url = URL(string: "comgooglemaps://?q=\(latitude),\(longitude)&directionsmode=driving") {
                if UIApplication.shared.canOpenURL(url) {
                    // Open Google Maps app if available
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Open Google Maps in Safari if the app is not installed
                    let webUrl = URL(string: "https://maps.google.com/maps?q=\(latitude),\(longitude)&directionsmode=driving")
                    UIApplication.shared.open(webUrl!, options: [:], completionHandler: nil)
                }
            }
        
//        showRouteOnAppleMaps(startLat: 28.5355, startLong: 77.3910, endLat: 28.4089, endLong: 77.3178)
        
    }
    
    @objc func startviewTapped() {
//        removeRoute()
        locationManager.startUpdatingLocation()//added on 30 Nov
        checkDetails(latitude: startLat, longitude: startLng, status: 1)
    }
    @objc func endviewTapped() {
        locationManager.stopUpdatingLocation()//added on 30 Nov
        self.topView.isHidden = false
        checkDetails(latitude: startLat, longitude: startLng, status: 2)
    }
    
    
    @IBAction func okBtnTap(_ sender: UIButton) {
        locationManager.stopUpdatingLocation()
        removeRoute()
        topView.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    

}
extension GooglePathVC: MKMapViewDelegate {
    
    func firstCall()
    {
        self.title = "Path Route"
        
        okBtn.roundedButton()
        topView.dropShadowWithBlackColor()
        startView.dropShadowWithBlackColor()
        endView.dropShadowWithBlackColor()
        self.distance.text = ""
        self.time.text = ""
        if comingFrom == "New"{
            journeySV.isHidden = true
            mapView = MKMapView(frame: CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width * 0.99, height: UIScreen.main.bounds.height * 0.7))
        }else if comingFrom == "Task"{
            journeySV.isHidden = true
            mapView = MKMapView(frame: CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width * 0.99, height: UIScreen.main.bounds.height * 0.75))
        }else{
            self.tabBarController?.tabBar.isHidden = true
            mapView = MKMapView(frame: CGRect(x: 0, y: 60, width: UIScreen.main.bounds.width * 0.99, height: UIScreen.main.bounds.height * 0.75))
        }
        removeRoute()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
        view.addSubview(mapView)
//        // Call a function to show route between two points
//        showRouteOnMap()
        // Call a function to show pin on a point
        if comingFrom == "New"{
           getTimeCard(id: timecard_id)
        }
        if comingFrom == "Task"{
            showLocationOnMap(lat: endLat, lng: endLng, pTitle: "Current Service")
        }

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(startviewTapped))
        startView.addGestureRecognizer(tapGesture)
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(endviewTapped))
        endView.addGestureRecognizer(tapGesture1)
       
    }
    
    //MARK: Calculate Distance
    
    func calculateDistanceAndTime(startCoordinate: CLLocationCoordinate2D, endCoordinate: CLLocationCoordinate2D, speedKmph: Double) -> (distance: Double, timeHours: Double) {
        let startLocation = CLLocation(latitude: startCoordinate.latitude, longitude: startCoordinate.longitude)
        let endLocation = CLLocation(latitude: endCoordinate.latitude, longitude: endCoordinate.longitude)
        
        // Calculate distance in meters
        let distanceInMeters = startLocation.distance(from: endLocation)
        
        // Calculate time in hours (time = distance / speed)
        let speedMps = speedKmph * 1000 / 3600  // Convert speed from km/h to m/s
        let timeInSeconds = distanceInMeters / speedMps
        let timeInHours = timeInSeconds / 3600
        
        return (distance: distanceInMeters, timeHours: timeInHours)
    }
    //MARK: Remove Route
    func removeRoute() {
           if let currentRouteOverlay = currentRoute?.polyline {
               mapView.removeOverlay(currentRouteOverlay)
           }
       }
    
    //MARK: Calculate travel time
    
    func calculateTravelTime(
        from sourceCoordinate: (latitude: Double, longitude: Double),
        to destinationCoordinate: (latitude: Double, longitude: Double),
        averageSpeedInKMH: Double
    ) -> (hours: Int, minutes: Int)? {
        // Radius of the Earth in kilometers
        let earthRadiusKilometers = 6371.0
        
        // Convert average speed from kilometers per hour to kilometers per minute
        let speedInKilometersPerMinute = averageSpeedInKMH / 60.0
        
        // Convert coordinates from degrees to radians
        let sourceLatRad = sourceCoordinate.latitude * .pi / 180.0
        let destLatRad = destinationCoordinate.latitude * .pi / 180.0
        let deltaLonRad = (destinationCoordinate.longitude - sourceCoordinate.longitude) * .pi / 180.0
        
        // Haversine formula to calculate the distance
        let a = sin((destLatRad - sourceLatRad) / 2.0) * sin((destLatRad - sourceLatRad) / 2.0) +
                cos(sourceLatRad) * cos(destLatRad) *
                sin(deltaLonRad / 2.0) * sin(deltaLonRad / 2.0)
        
        let c = 2.0 * atan2(sqrt(a), sqrt(1.0 - a))
        let distance = earthRadiusKilometers * c
        
        // Calculate time (hours and minutes)
        let timeInMinutes = distance / speedInKilometersPerMinute
        let hours = Int(timeInMinutes / 60.0)
        let minutes = Int(timeInMinutes) % 60
        
        return (hours, minutes)
    }
    
    //MARK: Show Route on Map
    func showRouteOnMap(stalat: Double, stalng: Double, endlat: Double, endlng: Double) {
            let sourceCoordinate = CLLocationCoordinate2D(latitude: stalat, longitude: stalng)//Noida
            let destinationCoordinate = CLLocationCoordinate2D(latitude: endlat, longitude: endlng)//Faridabad
            
            let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
            let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        getLocationNameFromCoordinates(latitude: startLat, longitude: startLng) { locationName in
            if let name = locationName {
                print("Location Name: \(name)")
                self.sourceAnnotation.title = name
            } else {
                print("Location name not found.")
            }
        }
        
        getLocationNameFromCoordinates(latitude: endLat, longitude: endLng) { locationName in
            if let name = locationName {
                print("Location Name: \(name)")
                self.destinationAnnotation.title = name
            } else {
                print("Location name not found.")
            }
        }
        
        self.sourceAnnotation = MKPointAnnotation()
        self.sourceAnnotation.coordinate = sourceCoordinate
        self.sourceAnnotation.subtitle = "Start"

        self.destinationAnnotation = MKPointAnnotation()
        self.destinationAnnotation.coordinate = destinationCoordinate
        self.destinationAnnotation.subtitle = "End"
        
            mapView.addAnnotations([sourceAnnotation, destinationAnnotation])
            
            let sourceItem = MKMapItem(placemark: sourcePlacemark)
            let destinationItem = MKMapItem(placemark: destinationPlacemark)
            
            let request = MKDirections.Request()
            request.source = sourceItem
            request.destination = destinationItem
            request.transportType = .automobile // You can change this to .walking or .transit
            
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                guard let route = response?.routes.first else {
                    return
                }
                self.currentRoute = route
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKPolyline {
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.strokeColor = UIColor.blue
                renderer.lineWidth = 4.0
                return renderer
            }
            return MKOverlayRenderer()
        }
    //MARK: GetLocationFromCoordinates
    func getLocationNameFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                completion(nil)
            } else if let placemark = placemarks?.first {
                // You can extract the location name from the placemark
                if let name = placemark.name {
                    completion(name)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: Added to show a location with Pin
    func showLocationOnMap(lat: Double, lng: Double, pTitle: String) {
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = pTitle//"Home Cleaning"
            annotation.subtitle = "Service Location"
            
            mapView.addAnnotation(annotation)
            
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                if let annotation = annotation as? CustomAnnotation {
                       let identifier = "CustomPin"
                       var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
                       if annotationView == nil {
                           annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                           annotationView?.canShowCallout = true
                       } else {
                           annotationView?.annotation = annotation
                       }
        
                       // Set your custom pin image here
                       annotationView?.image = UIImage(named: "location")
        
                       return annotationView
                   }
        
                   return nil
    }
    //MARK: Alert on info icon on Map
        
//        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//            if let annotation = view.annotation {
//                let alertController = UIAlertController(title: annotation.title ?? "",
//                                                        message: annotation.subtitle ?? "",
//                                                        preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alertController.addAction(okAction)
//                present(alertController, animated: true, completion: nil)
//            }
//        }
    //MARK: Get Current Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            // Do something with the latitude and longitude values
            print("Latitude: \(latitude), Longitude: \(longitude)")
            startLat = latitude
            startLng = longitude
            if comingFrom != "New" && comingFrom != "Task"{
               
                if count == 0{
                    locationManager.stopUpdatingLocation()//added on 30 Nov
                    getLocation(latitude: startLat, longitude: startLng)
                    count+=1
                }
              
//                checkDetails(latitude: startLat, longitude: startLng)//tap on button
            }
//            let startCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)  // Noida
//            let endCoordinate = CLLocationCoordinate2D(latitude: 28.4089, longitude: 77.3178)  // Faribad
//            let speedKmph = 70.0  // Speed in kilometers per hour
//            let sourceCoordinate = (latitude: latitude, longitude: longitude) // Noida
//            let destinationCoordinate = (latitude: 28.4089, longitude: 77.3178) // Faridabad
//            let result = calculateDistanceAndTime(startCoordinate: startCoordinate, endCoordinate: endCoordinate, speedKmph: speedKmph)
//            print("Distance: \(result.distance) meters")
//            let distanceInKilometers = metersToKilometers(result.distance)
//            print("Time: \(result.timeHours) hours")
//            let distances = String(format: "%.2f", distanceInKilometers)
//            distance.text = distances + " KM"
//
//            //Claculate time take
//            if let travelTime = calculateTravelTime(
//                from: sourceCoordinate,
//                to: destinationCoordinate,
//                averageSpeedInKMH: speedKmph
//            ) {
//                print("Estimated travel time: \(travelTime.hours) hours \(travelTime.minutes) minutes")
//                time.text = "\(travelTime.hours) Hour \(travelTime.minutes) Minutes"
//            } else {
//                print("Invalid input coordinates or speed.")
//            }
            // You can stop updating location if you only need it once
          
        }
    }
    
    func showRouteOnAppleMaps(startLat: Double, startLong: Double, endLat: Double, endLong: Double) {
        let startCoordinate = CLLocationCoordinate2D(latitude: startLat, longitude: startLong)
        let endCoordinate = CLLocationCoordinate2D(latitude: endLat, longitude: endLong)

        let startPlacemark = MKPlacemark(coordinate: startCoordinate, addressDictionary: nil)
        let endPlacemark = MKPlacemark(coordinate: endCoordinate, addressDictionary: nil)

        let startItem = MKMapItem(placemark: startPlacemark)
        let endItem = MKMapItem(placemark: endPlacemark)

        let mapItems = [startItem, endItem]
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]

        // You can also use .walking or .transit for different travel modes

        MKMapItem.openMaps(with: mapItems, launchOptions: launchOptions)
    }
}
//MARK: API Implemetation
extension GooglePathVC {
    
    //MARK: First Come Location
    func getLocation(latitude: Double, longitude: Double )
        {
            if reachability.isConnectedToNetwork() == false{
                _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
                return
            }
            let progressHUD = ProgressHUD()
            self.view.addSubview(progressHUD)
            progressHUD.show()
            var param: Parameters = ["":""]
            let url = "\(ApiLink.HOST_URL)/get_location_tracking"
            param = ["latitude": latitude, "longitude": longitude, "task_id": taskID]
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
                               let loginResponse = try? JSONDecoder().decode(RouteData.self, from: jsonData) {
                                self.distance.text = "\(loginResponse.data.distanceInMiles) Miles"
                                self.time.text = loginResponse.data.duration == "" || loginResponse.data.duration == "0" ? "0 Min" : loginResponse.data.duration
                                self.reachStatus = loginResponse.data.status
                                if loginResponse.data.status == 1{
                                    self.startView.isHidden = true
                                }else if  loginResponse.data.status == 2{
                                    self.mapView.removeFromSuperview()
                                    self.journeySV.isHidden = true
                                    self.topView.isHidden = false
                                    self.traveldistance.text = "Travel Distance Covered is: " + "\(loginResponse.data.distanceInMiles) Miles"
                                    self.traveltime.text = "Travel time is: " +  (self.time.text ?? "")
                                }
                                progressHUD.hide()
                                self.showRouteOnMap(stalat: latitude, stalng: longitude, endlat: self.endLat, endlng: self.endLng)
                                
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
                            _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.warning,buttonTitle:"OK"){ (isOtherButton) -> Void in
                                if isOtherButton == true {
                                    self.startView.isHidden = true
                                    self.endView.isHidden = true
//                                    self.navigationController?.popViewController(animated: true)
                                    self.showLocationOnMap(lat: self.endLat, lng: self.endLng, pTitle: "")
                                    self.dismiss(animated: true)
                                }
                            }
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
//MARK: Check Route Status API
    func checkDetails(latitude: Double, longitude: Double, status: Int )
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/location_tracking"
        param = ["latitude": latitude, "longitude": longitude, "task_id": taskID, "status": status]
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
                           let loginResponse = try? JSONDecoder().decode(RouteData.self, from: jsonData) {
                                                       
                            self.distance.text = "\(loginResponse.data.distanceInMiles) Miles"
                            self.time.text = loginResponse.data.duration
                            self.reachStatus = loginResponse.data.status
                            if loginResponse.data.status == 1{
                                self.startView.isHidden = true
                            }else if loginResponse.data.status == 2{
                                self.journeySV.isHidden = true
                                self.locationManager.stopUpdatingLocation()
                            }
                            
                            self.traveldistance.text = "Travel Distance Covered is: " + "\(loginResponse.data.distanceInMiles) Miles"
                            self.traveltime.text = "Travel time is: " +  (self.time.text ?? "")

                            progressHUD.hide()
                            self.showRouteOnMap(stalat: latitude, stalng: longitude, endlat: self.endLat, endlng: self.endLng)
                
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
    
    //MARK: Get Time Card
    func getTimeCard(id : Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let url = "\(ApiLink.HOST_URL)/timecard_detail"
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
                           let loginResponse = try? JSONDecoder().decode(TimeCardDetailsInfo.self, from: jsonData) {
                            if let doubleValue = Double(loginResponse.timeCards[0].site_latitude) {
                                print("Double value: \(doubleValue)")
                                self.endLat = doubleValue
                            } else {
                                print("Invalid input: \(loginResponse.timeCards[0].site_latitude) is not a valid double.")
                            }
                            
                            if let doubleValue1 = Double(loginResponse.timeCards[0].site_longitude) {
                                print("Double value1: \(doubleValue1)")
                                self.endLng = doubleValue1
                            } else {
                                print("Invalid input: \(loginResponse.timeCards[0].site_longitude) is not a valid double.")
                            }
                            
                            self.showLocationOnMap(lat: self.endLat, lng: self.endLng, pTitle: loginResponse.timeCards[0].task_name)
                            
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
