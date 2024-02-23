//
//  AdminDetailTimeCardMainVC.swift
//  Cleansing
//
//  Created by uis on 07/12/23.
//

import UIKit
import Alamofire

class AdminDetailTimeCardMainVC: UIViewController {

    @IBOutlet weak var clockType: PaddingLabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var timeHeight: NSLayoutConstraint!
    var taskID: Int = 0
    var status:Int = 0
    var site_latitude: Double = 0.0
    var site_longitude: Double = 0.0
    var underlineView = UIView()
    var approve: Int = 0
    //Add Child Controllers
    
    //add controller
    private lazy var time: AdminDetailTimeCardVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "AdminDetailTimeCardVC") as! AdminDetailTimeCardVC
        viewController.timecard_id = taskID
        viewController.hidesBottomBarWhenPushed = true
        self.add(asChildViewController: viewController)
        return viewController
    }()
    private lazy var sites: GooglePathVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "GooglePathVC") as! GooglePathVC
        viewController.comingFrom = "New"
        viewController.hidesBottomBarWhenPushed = true
        viewController.timecard_id = taskID
        self.add(asChildViewController: viewController)
        return viewController
    }()
    private lazy var notes: ShowNotesAdminVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ShowNotesAdminVC") as! ShowNotesAdminVC
        viewController.calledFrom = "TimeCard"
        viewController.hidesBottomBarWhenPushed = true
        viewController.taskID = taskID
        self.add(asChildViewController: viewController)
        return viewController
    }()
    
    private lazy var logs: LogsVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "LogsVC") as! LogsVC
//        viewController.timecard_id = taskID
        viewController.hidesBottomBarWhenPushed = true
        self.add(asChildViewController: viewController)
        return viewController
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        customSegment()
        self.title = "Edit TimeCard".localizeString(string: lang)
        remove(asChildViewController: notes)
        remove(asChildViewController: sites)
        remove(asChildViewController: logs)
        add(asChildViewController: time)
        
        if let deleteImage = UIImage(named: "trash-bin") {
            let originalDeleteImage = deleteImage.withRenderingMode(.alwaysOriginal)
            let deleteButton = UIBarButtonItem(
                image: originalDeleteImage,
                style: .plain,
                target: self,
                action: #selector(deleteButtonTapped)
            )
            navigationItem.rightBarButtonItem = deleteButton
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    @objc func deleteButtonTapped() {
        if approve == 2{
            _ = SweetAlert().showAlert("", subTitle: "Approved timecard cannot be deleted".localizeString(string: lang), style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
        }else{
            let refreshAlert = UIAlertController(title: "", message: "Do you want to delete this timecard ?".localizeString(string: lang), preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel".localizeString(string: lang), style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                refreshAlert .dismiss(animated: true, completion: nil)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Delete".localizeString(string: lang), style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                self.deleteTimeCard(id: self.taskID)
            }))
            self.present(refreshAlert, animated: true, completion: nil)
           
        }
    }
    

    @IBAction func segmentContolTap(_ sender: UISegmentedControl) {
        let segmentWidth = segmentControl.frame.width / CGFloat(segmentControl.numberOfSegments)
            let x = segmentWidth * CGFloat(sender.selectedSegmentIndex)
            UIView.animate(withDuration: 0.3) {
                self.underlineView.frame.origin.x = x
            }
        
        if sender.selectedSegmentIndex == 0{
            timeHeight.constant = 130
            clockType.isHidden = false
        }else{
            timeHeight.constant = 0
            clockType.isHidden = true
        }
        if sender.selectedSegmentIndex == 0{
            self.title = "Time Card".localizeString(string: lang)
            remove(asChildViewController: notes)
            remove(asChildViewController: sites)
            remove(asChildViewController: logs)
            add(asChildViewController: time)
        }else if sender.selectedSegmentIndex == 1{
            self.title = "Sites".localizeString(string: lang)
            remove(asChildViewController: notes)
            remove(asChildViewController: time)
            remove(asChildViewController: logs)
            add(asChildViewController: sites)
        }else if sender.selectedSegmentIndex == 2{
            self.title = "View Notes".localizeString(string: lang)
            remove(asChildViewController: sites)
            remove(asChildViewController: time)
            remove(asChildViewController: logs)
            add(asChildViewController: notes)
        }else{
            remove(asChildViewController: sites)
            remove(asChildViewController: time)
            remove(asChildViewController: notes)
            add(asChildViewController: logs)
        }
    }
}
extension AdminDetailTimeCardMainVC{
    
    func firstCall()
    {
        print(taskID)
//        customSegment()
        getTimeCard(id: "\(taskID)")
        self.clockType.edgeInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.clockType.layer.masksToBounds = true
        self.clockType.layer.cornerRadius = 5
        segmentControl.setTitle("Time".localizeString(string: lang), forSegmentAt: 0)
        segmentControl.setTitle("Sites".localizeString(string: lang), forSegmentAt: 1)
        segmentControl.setTitle("Notes".localizeString(string: lang), forSegmentAt: 2)
        segmentControl.setTitle("Logs".localizeString(string: lang), forSegmentAt: 3)
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
    
    //MARK: Get Time Card
    func getTimeCard(id : String)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
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
                                self.site_latitude = doubleValue
                            } else {
                                print("Invalid input: \(loginResponse.timeCards[0].site_latitude) is not a valid double.")
                            }
                            
                            if let doubleValue1 = Double(loginResponse.timeCards[0].site_longitude) {
                                print("Double value1: \(doubleValue1)")
                                self.site_longitude = doubleValue1
                            } else {
                                print("Invalid input: \(loginResponse.timeCards[0].site_longitude) is not a valid double.")
                            }
                            
                            self.timerLabel.text = loginResponse.timeCards[0].hours + "h " + loginResponse.timeCards[0].minutes + "m"
                            self.approve = loginResponse.timeCards[0].approve
                            if loginResponse.timeCards[0].approve == 0{
                                self.clockType.text = "CLOCKED IN".localizeString(string: lang)
                                self.clockType.backgroundColor = UIColor.init(hexString: "3CDACA")
                            }else if loginResponse.timeCards[0].approve == 1{
                                self.clockType.text = "CLOCKED OUT".localizeString(string: lang)
                                self.clockType.backgroundColor = UIColor.init(hexString: "004080")
                            }else{
                                self.clockType.text = "APPROVED".localizeString(string: lang)
                                self.clockType.backgroundColor = UIColor.init(hexString: "F37290")
                            }
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
                                    self.navigationController?.popViewController(animated: true)
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

