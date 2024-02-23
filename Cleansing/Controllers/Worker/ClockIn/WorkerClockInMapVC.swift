//
//  WorkerClockInMapVC.swift
//  Cleansing
//
//  Created by uis on 09/01/24.
//

import UIKit
import Alamofire
import MapKit
import CoreLocation
class WorkerClockInMapVC: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    var workID:Int = 0
    var status:Int = 0
    var destinationAnnotation: MKPointAnnotation!
    var sourceAnnotation: MKPointAnnotation!
    var currentRoute: MKRoute?
    var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        segmentControl.selectedSegmentIndex = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        firstCall()
    }

    @IBAction func segmnetTap(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            self.navigationController?.popViewController(animated: true)
        }
    }
}
extension WorkerClockInMapVC: CLLocationManagerDelegate, MKMapViewDelegate{
    
    func firstCall()
    {
    bottomView.dropShadowWithBlackColor()
        mapView = MKMapView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height * 0.1, width: UIScreen.main.bounds.width * 0.99, height: UIScreen.main.bounds.height * 0.7))
    mapView.showsUserLocation = true
    mapView.userTrackingMode = .follow
    mapView.mapType = .standard
    mapView.delegate = self
    startTime.text = ""
    endTime.text = ""
    view.addSubview(mapView)
    workerProjectDetails()
    }
    
    //MARK: Added to show a location with Pin
    func showLocationOnMap(lat: Double, lng: Double, pTitle: String, endlat:Double, endlng: Double) {
//            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
//            
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinate
//            annotation.title = pTitle//"Home Cleaning"
//            annotation.subtitle = "Service Location"
//            
//            mapView.addAnnotation(annotation)
//                mapView.showsBuildings = true
////            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
//            let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 0, pitch: 45, heading: 0)
//               // Set the camera on the map view
//               mapView.setCamera(camera, animated: true)
////            mapView.setRegion(region, animated: true)
//        
        
        let sourceCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)//Noida
        let destinationCoordinate = CLLocationCoordinate2D(latitude: endlat, longitude: endlng)//Faridabad
        
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        self.sourceAnnotation = MKPointAnnotation()
        self.sourceAnnotation.coordinate = sourceCoordinate
        self.sourceAnnotation.subtitle = "ClockIn".localizeString(string: lang)

        self.destinationAnnotation = MKPointAnnotation()
        self.destinationAnnotation.coordinate = destinationCoordinate
        self.destinationAnnotation.subtitle = "ClockOut".localizeString(string: lang)
        
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
}

//MARK: API Requests
extension WorkerClockInMapVC{
    
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
                            progressHUD.hide()
                            self.locationName.text = loginResponse.data.location
                            self.startTime.text = loginResponse.data.site_start_time
                            self.endTime.text = loginResponse.data.site_end_time
                            self.duration.text = loginResponse.data.site_duration
                            self.showLocationOnMap(lat: Double(loginResponse.data.start_latitude) ?? 0.0, lng: Double(loginResponse.data.start_longitude) ?? 0.0, pTitle: "ClockIn".localizeString(string: lang), endlat: Double(loginResponse.data.end_latitudde ?? "0.0") ?? 0.0, endlng: Double(loginResponse.data.end_longitude ?? "0.0") ?? 0.0)
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
}
