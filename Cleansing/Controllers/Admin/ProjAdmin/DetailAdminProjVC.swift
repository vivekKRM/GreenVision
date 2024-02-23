//
//  DetailAdminProjVC.swift
//  Cleansing
//
//  Created by UIS on 07/11/23.
//

import UIKit
import CoreLocation
import Alamofire
import Fastis
import MapKit
class DetailAdminProjVC: UIViewController {
    
    @IBOutlet weak var detailProjTV: UITableView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var selectDate: UIButton!
    @IBOutlet weak var personTotal: UIButton!
    
    @IBOutlet weak var milesView: UIView!
    @IBOutlet weak var milesValue: UILabel!
    
    @IBOutlet weak var travelView: UIView!
    @IBOutlet weak var travelValue: UILabel!
    
    @IBOutlet weak var spentView: UIView!
    @IBOutlet weak var spentValue: UILabel!
    
    @IBOutlet weak var costView: UIView!
    @IBOutlet weak var costValue: UILabel!
    
    @IBOutlet weak var employeListing: UIButton!
    @IBOutlet weak var projectDetailTV: UITableView!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var personView: UIView!
    @IBOutlet weak var employeeView: UIView!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourLabel: UILabel!
    
    
    
    
    
    var buttonText: String = "Total".localizeString(string: lang)
    var maPView: MKMapView!
    var status:Int = 0
    var pickerView: UIPickerView!
    var taskId: Int = 0
    var geofenceCircle: MKCircle?
    var date_selection:String = ""
    var alertController: UIAlertController!
    var underlineView = UIView()
    var searchData = [projectDetailAdmin]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Project Details".localizeString(string: lang)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    
    
    @IBAction func dateBtnTap(_ sender: UIButton) {
        chooseDate()
    }
    
    
    @IBAction func personSelection(_ sender: UIButton) {
        showAlert()
    }
    
}
    

//MARK: First Call
extension DetailAdminProjVC : MKMapViewDelegate{
    
    func firstCall()
    {
        firstLabel.text = "Total Miles".localizeString(string: lang)
        secondLabel.text = "Travel Time".localizeString(string: lang)
        thirdLabel.text = "Spent Time".localizeString(string: lang)
        fourLabel.text = "Total Cost".localizeString(string: lang)
        employeListing.setTitle("Employee Listing".localizeString(string: lang), for: .normal)
        maPView = MKMapView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 1.0, height: UIScreen.main.bounds.height * 0.35))
        //        maPView.showsUserLocation = true
        //        maPView.userTrackingMode = .follow
        maPView.delegate = self
        mapView.addSubview(maPView)
        milesView.dropShadowWithBlackColor()
        travelView.dropShadowWithBlackColor()
        spentView.dropShadowWithBlackColor()
        costView.dropShadowWithBlackColor()
        dateView.dropShadowWithBlackColor()
        personView.dropShadowWithBlackColor()
        employeeView.dropShadowWithBlackColor()
        personTotal.setTitle(buttonText, for: .normal)
        projectDetail(filter: "", filterBy: buttonText)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.3)
            circleRenderer.strokeColor = UIColor.blue
            circleRenderer.lineWidth = 1
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
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
        selectDate.setTitle(finals, for: .normal)
        date_selection = finals
        projectDetail(filter: finals, filterBy: buttonText)
    }
    
     func showAlert() {
           // Create an alert controller
         let alertController = UIAlertController(title: "Choose Option".localizeString(string: lang), message: "", preferredStyle: .alert)
           
           // Create three buttons with different actions
         let button1 = UIAlertAction(title: "Total".localizeString(string: lang), style: .default) { (action) in
               // Code to be executed when Button 1 is tapped
               print("Button 1 tapped")
             self.buttonText = "Total".localizeString(string: lang)
               self.personTotal.setTitle( self.buttonText, for: .normal)
               self.projectDetail(filter: self.date_selection, filterBy: "Total")           }
           
         let button2 = UIAlertAction(title: "Person & Total".localizeString(string: lang), style: .default) { (action) in
               // Code to be executed when Button 2 is tapped
               print("Button 2 tapped")
             self.buttonText = "Person & Total".localizeString(string: lang)
               self.personTotal.setTitle( self.buttonText, for: .normal)
               self.projectDetail(filter: self.date_selection, filterBy: "person")
           }
         let dismissAction = UIAlertAction(title: "Dismiss".localizeString(string: lang), style: .cancel, handler: nil)
         // Set the text color of the buttons to black
         alertController.view.tintColor = .black
         dismissAction.setValue(UIColor.red, forKey: "titleTextColor")
           
           // Add the buttons to the alert controller
           alertController.addAction(button1)
           alertController.addAction(button2)
         alertController.addAction(dismissAction)
           
           // Present the alert controller
           present(alertController, animated: true, completion: nil)
       }
}


//MARK: TableView Delegate
extension DetailAdminProjVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "daCell", for: indexPath) as! ProjectHourTVC
        cell.nameLabel?.text = searchData[indexPath.row].name
            cell.milesLabel?.text = searchData[indexPath.row].total_miles
            cell.hourLabel?.text = searchData[indexPath.row].total_spendtime
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

//MARK: API Integration
extension DetailAdminProjVC {
    
    //MARK: Get ProjectDetail API
    func projectDetail(filter: String, filterBy: String)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/project_admin_details"
        param = ["project_id": taskId, "date_filter":filter,"filter_by":filterBy]
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
                           let loginResponse = try? JSONDecoder().decode(ProjectDetails.self, from: jsonData) {
                           
                            self.selectDate.setTitle(loginResponse.dateFilter, for: .normal)
                            self.milesValue.text = loginResponse.totalMiles
                            self.travelValue.text = loginResponse.totalTravelTime
                            self.spentValue.text = loginResponse.totalSpendTime
                            self.costValue.text = loginResponse.totalCost
                            
                           
                            if let existingGeofence = self.geofenceCircle {
                                self.maPView.removeOverlay(existingGeofence)
                            }
                            
                            let coordinate = CLLocationCoordinate2D(latitude: Double(loginResponse.latitude) ?? 28.4458, longitude: Double(loginResponse.longitude) ?? 77.3082)
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = coordinate
                            annotation.title = "Service Location".localizeString(string: lang)
                            self.maPView.mapType = .satellite
                            // Add the pin to the mapView
                            self.maPView.addAnnotation(annotation)
                            //        maPView.isZoomEnabled = true
                            let maxZoom = CLLocationDistance(1000) // Adjust the maximum zoom level as needed
                            let minZoom = CLLocationDistance(50) // Adjust the minimum zoom level as needed
                            let zoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: minZoom, maxCenterCoordinateDistance: maxZoom)
                            self.maPView.setCameraZoomRange(zoomRange, animated: true)
                            let geofence = MKCircle(center: coordinate, radius: 50) // 1000 meters radius (adjust as needed)
                            geofence.title = "Geofence".localizeString(string: lang)
                            geofence.subtitle = "This is the geofence area".localizeString(string: lang)
                            self.maPView.addOverlay(geofence)
                            self.geofenceCircle = geofence
                            
                            // Set the initial region and zoom level
                            let regionRadius: CLLocationDistance = 200  // Adjust this value for the desired zoom level
                            let coordinateRegion = MKCoordinateRegion(
                                center: coordinate,
                                latitudinalMeters: regionRadius,
                                longitudinalMeters: regionRadius)
                            self.maPView.setRegion(coordinateRegion, animated: true)
                            let label1 = UILabel(frame: CGRect(x: 15, y: 10, width: UIScreen.main.bounds.width * 0.9, height: 60))
                            label1.text = loginResponse.location
                            label1.textColor = .white
                            label1.lineBreakMode = .byWordWrapping
                            label1.numberOfLines = 0
                            label1.font = UIFont(name: "Poppins-Medium", size: 16)
                            self.mapView.addSubview(label1)
                            
                            
                            progressHUD.hide()
                            
                            self.searchData.removeAll()
                            for i in 0..<loginResponse.data.count{
                                self.searchData.append(projectDetailAdmin.init(total_miles: loginResponse.data[i].total_miles, name: loginResponse.data[i].name, total_travel_time: loginResponse.data[i].total_travel_time, total_spendtime: loginResponse.data[i].total_spendtime, total_cost: loginResponse.data[i].total_cost))
                            }
                            
                            
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
                        self.searchData.removeAll()
                        self.projectDetailTV.reloadData()
                        
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
                    }else if self.status == 201{
                        progressHUD.hide()
                        self.searchData.removeAll()
//                        self.changeDateBtn.setTitle( dict["filter"] as? String, for: .normal)
                        self.projectDetailTV.reloadData()
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
                    }else{
                        progressHUD.hide()
                        self.searchData.removeAll()
                        self.projectDetailTV.reloadData()
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
