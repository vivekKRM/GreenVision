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
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var calenderView: UIView!
    @IBOutlet weak var dateBtn: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    
    var maPView: MKMapView!
    var status:Int = 0
    var pickerView: UIPickerView!
    var taskId: Int = 0
    var alertController: UIAlertController!
    var underlineView = UIView()
    //Add Child Controllers
    
    //add controller
    private lazy var hour: ProjectHoursVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ProjectHoursVC") as! ProjectHoursVC
//        viewController.timecard_id = taskID
        self.add(asChildViewController: viewController)
        return viewController
    }()
//    private lazy var miles: GooglePathVC = {
//        // Load Storyboard
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        var viewController = storyboard.instantiateViewController(withIdentifier: "GooglePathVC") as! GooglePathVC
////        viewController.comingFrom = "New"
////        viewController.timecard_id = taskID
//        self.add(asChildViewController: viewController)
//        return viewController
//    }()
//    private lazy var cost: LogsVC = {
//        // Load Storyboard
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        var viewController = storyboard.instantiateViewController(withIdentifier: "LogsVC") as! LogsVC
////        viewController.timecard_id = taskID
//        self.add(asChildViewController: viewController)
//        return viewController
//    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Project Details"
//        remove(asChildViewController: miles)
//        remove(asChildViewController: cost)
        add(asChildViewController: hour)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    
    
    @IBAction func dateBtnTap(_ sender: UIButton) {
        chooseDate()
    }
    
    
    @IBAction func segmentControlTap(_ sender: UISegmentedControl) {
        let segmentWidth = segmentControl.frame.width / CGFloat(segmentControl.numberOfSegments)
            let x = segmentWidth * CGFloat(sender.selectedSegmentIndex)
            UIView.animate(withDuration: 0.3) {
                self.underlineView.frame.origin.x = x
            }
        
     
        if sender.selectedSegmentIndex == 0{
            self.title = "Project Details"
//             remove(asChildViewController: miles)
//            remove(asChildViewController: cost)
            add(asChildViewController: hour)
        }else if sender.selectedSegmentIndex == 1{
            self.title = "Miles & Travels"
//            remove(asChildViewController: notes)
//            remove(asChildViewController: time)
//            remove(asChildViewController: logs)
//            add(asChildViewController: sites)
        }else{
            self.title = "Cost"
//            remove(asChildViewController: sites)
//            remove(asChildViewController: time)
//            remove(asChildViewController: notes)
//            add(asChildViewController: logs)
        }
    }
    }
    

//MARK: First Call
extension DetailAdminProjVC : MKMapViewDelegate{
    
    func firstCall()
    {
        calenderView.dropShadowWithBlackColor()
        customSegment()
        maPView = MKMapView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 1.0, height: UIScreen.main.bounds.height * 0.33))
        //        maPView.showsUserLocation = true
        //        maPView.userTrackingMode = .follow
        maPView.delegate = self
        mapView.addSubview(maPView)
        let coordinate = CLLocationCoordinate2D(latitude: 28.4458, longitude: 77.3082)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Home Cleaning"
        maPView.mapType = .satellite
        // Add the pin to the mapView
        maPView.addAnnotation(annotation)
        //        maPView.isZoomEnabled = true
        let maxZoom = CLLocationDistance(1000) // Adjust the maximum zoom level as needed
        let minZoom = CLLocationDistance(50) // Adjust the minimum zoom level as needed
        let zoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: minZoom, maxCenterCoordinateDistance: maxZoom)
        maPView.setCameraZoomRange(zoomRange, animated: true)
        let geofence = MKCircle(center: coordinate, radius: 50) // 1000 meters radius (adjust as needed)
        geofence.title = "Geofence"
        geofence.subtitle = "This is the geofence area"
        maPView.addOverlay(geofence)
        
        // Set the initial region and zoom level
        let regionRadius: CLLocationDistance = 200  // Adjust this value for the desired zoom level
        let coordinateRegion = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        maPView.setRegion(coordinateRegion, animated: true)
        
        let label1 = UILabel(frame: CGRect(x: 15, y: 10, width: UIScreen.main.bounds.width * 0.9, height: 60))
        label1.text = "Isobel Weekly Cleaning Front and Back of Garden"
        label1.textColor = .white
        label1.lineBreakMode = .byWordWrapping
        label1.numberOfLines = 0
        label1.font = UIFont(name: "Poppins-Medium", size: 20)
        mapView.addSubview(label1)
        
        let label2 = UILabel(frame: CGRect(x: 15, y: 68, width: UIScreen.main.bounds.width * 0.9, height: 30))
        label2.numberOfLines = 1
        label2.textColor = .white
        label2.font = UIFont(name: "Poppins-Medium", size: 15)
        label2.text = "Noida sector 75, Noida, Uttar Pradesh - 2023303"
        mapView.addSubview(label2)
//        createBar()
    }
    
    //MARK: Create UINavigationBar Button
//    func createBar(){
//        if let deleteImage = UIImage(named: "trash-bin") {
//            let originalDeleteImage = deleteImage.withRenderingMode(.alwaysOriginal)
//            let deleteButton = UIBarButtonItem(
//                image: originalDeleteImage,
//                style: .plain,
//                target: self,
//                action: #selector(deleteButtonTapped)
//            )
//            navigationItem.rightBarButtonItem = deleteButton
//        }
//    }
    
//    @objc func deleteButtonTapped() {
//            let refreshAlert = UIAlertController(title: "", message: "Do you want to delete this task ?", preferredStyle: UIAlertController.Style.alert)
//            
//            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//                print("Handle Cancel Logic here")
//                refreshAlert .dismiss(animated: true, completion: nil)
//            }))
//            
//            refreshAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
//                print("Handle Ok logic here")
////                self.deleteTasks(id: self.taskId)
//            }))
//            self.present(refreshAlert, animated: true, completion: nil)
//    }
    
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
    
    
    //MARK: Configure SegmentControl
    
    func customSegment()
    {
        let selectedAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "004080")]
        let unselectedAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        segmentControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        segmentControl.setTitleTextAttributes(unselectedAttributes, for: .normal)
        underlineView.backgroundColor = UIColor(hexString: "004080")
        segmentControl.addSubview(underlineView)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        underlineView.widthAnchor.constraint(equalTo: segmentControl.widthAnchor, multiplier: 1.0 / CGFloat(segmentControl.numberOfSegments)).isActive = true
        underlineView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor).isActive = true
        underlineView.leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor).isActive = true
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        // Add Child View as Subview
        self.bottomView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = self.bottomView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
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
            let todata = resultRange?.toDate
            let fromdata = resultRange?.fromDate
            self.changeDate(toDate: todata!, fromDate: fromdata!)
            
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
        dateBtn.setTitle(finals, for: .normal)
//        date_selection = finals
//        getTask(id: self.project_id ?? 0, filter: finals, workingStatus: self.workingStatu ?? "")
        
    }
}

//MARK: API Integration
extension DetailAdminProjVC {
    
   
}
