//
//  AddAdminProjVC.swift
//  Cleansing
//
//  Created by UIS on 03/11/23.
//

import UIKit
import Alamofire
class AddAdminProjVC: UIViewController {

    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var projectName: UITextField!
    @IBOutlet weak var selectCustomer: UITextField!
    @IBOutlet weak var enterLocation: UITextField!
    @IBOutlet weak var selectManager: UITextField!
    @IBOutlet weak var streetTV: UITextView!
    @IBOutlet weak var textviewheight: NSLayoutConstraint!
    var status: Int = 0
    var managerId: String = ""
    var customerId: String = ""
    var otherProj: Int = 0
    var savelat:String = ""
    var savelng:String = ""
    var projId: Int = 0
    var type: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == "Edit"{
            self.title = "Edit Project"
        }else{
            self.title = "Add Project"
        }
        streetTV.text = "Enter Street"
        streetTV.textColor = UIColor.lightGray
        streetTV.delegate = self
        self.textviewheight.isActive = true
        streetTV.layer.borderColor = UIColor.lightGray.cgColor
        streetTV.layer.borderWidth = 1.0
        streetTV.layer.cornerRadius = 10.0
        streetTV.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.removeObject(forKey: "cm")
        UserDefaults.standard.removeObject(forKey: "sm")
        UserDefaults.standard.removeObject(forKey: "ci")
        UserDefaults.standard.removeObject(forKey: "si")
        UserDefaults.standard.synchronize()
       
    }
    @IBAction func createBtnTap(_ sender: UIButton) {
        self.view.endEditing(true)
        print(UserDefaults.standard.dictionary(forKey: "Map")  ?? [:])
//        let map = UserDefaults.standard.dictionary(forKey: "Map")  ?? [:]
        if checkAll(){
            addProject(project_name: projectName.text ?? "", customer_id: customerId, manager_id: managerId, location: enterLocation.text ?? "", latitude: savelat, longitude:  savelng, street: streetTV.text ?? "")
        }
    }
    
}
//MARK: First Call
extension AddAdminProjVC {
    
    func firstCall()
    {
        createBtn.roundedButton()
        selectManager.inputView = UIView()
        selectManager.inputAccessoryView = UIView()
        selectManager.tintColor = .white
        selectCustomer.inputView = UIView()
        selectCustomer.inputAccessoryView = UIView()
        selectCustomer.tintColor = .white
        enterLocation.inputView = UIView()
        enterLocation.inputAccessoryView = UIView()
        enterLocation.tintColor = .white
       
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectPaxiSocket(_:)), name: Notification.Name(rawValue: "disconnectPaxiSockets"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectPaxiSocket(_:)), name: Notification.Name(rawValue: "disconnectPaxiSocket"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectPaxiSocketLocation(_:)), name: Notification.Name(rawValue: "disconnectPaxiSocketss"), object: nil)
        if type == "Edit"{
            getProjectDetails()
            
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
    }
    @objc func disconnectPaxiSocket(_ notification: Notification) {
        selectCustomer.text = UserDefaults.standard.string(forKey: "cn")
       customerId = UserDefaults.standard.string(forKey: "ci") ?? ""
        
        if let retrievedStringArray = UserDefaults.standard.array(forKey: "sm") as? [String] {
            print(retrievedStringArray)
            selectManager.text = retrievedStringArray.joined(separator: ", ")
        }
        if let retrievedIntArray = UserDefaults.standard.array(forKey: "si") as? [String] {
            print(retrievedIntArray)
            managerId = retrievedIntArray.joined(separator: ",")
        }
    }
    
    @objc func disconnectPaxiSocketLocation(_ notification: Notification) {
        enterLocation.text = UserDefaults.standard.string(forKey: "PlaceName")
        print(UserDefaults.standard.dictionary(forKey: "Map")  ?? [:])
        let map = UserDefaults.standard.dictionary(forKey: "Map")  ?? [:]
        savelat = map["lat"] as? String ?? "0.0"
        savelng =  map["long"] as? String ?? "0.0"
    }
    
    
    @objc func deleteButtonTapped() {
            let refreshAlert = UIAlertController(title: "Delete Project", message: "Deleting project will delete all your tasks,time cards data, related to this project", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                refreshAlert .dismiss(animated: true, completion: nil)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                self.deleteProject(id: self.projId)
            }))
            self.present(refreshAlert, animated: true, completion: nil)
           
        }
    
    func checkAll() -> Bool{
        if projectName.text == "" || projectName.text?.count ?? 0 < 3{
            _ = SweetAlert().showAlert("", subTitle:  "Please enter project name", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if selectCustomer.text == "" || selectCustomer.text?.count ?? 0 < 3{
            _ = SweetAlert().showAlert("", subTitle:  "Please choose workers", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if streetTV.text == "Select Street" || streetTV.text == ""{
            _ = SweetAlert().showAlert("", subTitle:  "Please enter notes description", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if enterLocation.text == "" || enterLocation.text?.count ?? 0 < 3{
            _ = SweetAlert().showAlert("", subTitle:  "Please choose location of project", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if selectManager.text == "" || selectManager.text?.count ?? 0 < 3{
            _ = SweetAlert().showAlert("", subTitle:  "Please choose manager for project", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else{
            return true
        }
    }
    
    
    
}

extension AddAdminProjVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == selectCustomer {
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CheckListVC") as? CheckListVC{
                if let presentationController = VC.presentationController as? UISheetPresentationController {
                    presentationController.detents = [.medium(), .large()] /// change to [.medium(), .large()] for a half *and* full screen sheet
                }
                VC.calledType = "AdminProj"
                self.present(VC, animated: true)
            }
            
        }else if  textField == selectManager{
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CheckListVC") as? CheckListVC{
                if let presentationController = VC.presentationController as? UISheetPresentationController {
                    presentationController.detents = [.medium(), .large()] /// change to [.medium(), .large()] for a half *and* full screen sheet
                }
                VC.calledType = "AdminProjS"
                self.present(VC, animated: true)
            }
            
        }else if textField == enterLocation{
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationVC") as? LocationVC{
                if let presentationController = VC.presentationController as? UISheetPresentationController {
                    presentationController.detents = [.large()] 
                }
                self.present(VC, animated: true)
            }
        }
    }
    
}

//MARK: API Integartion
extension AddAdminProjVC {
    
    //MARK: Add Project API
    func addProject(project_name: String, customer_id: String, manager_id: String, location: String, latitude: String, longitude: String, street: String)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
      
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/add_project"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["project_name": project_name,"customer_id": customer_id, "manager_id": manager_id,"location": location, "latitude": latitude , "longitude": longitude, "street": street ]
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
                                _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.success,buttonTitle:"OK"){ (isOtherButton) -> Void in
                                    if isOtherButton == true {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                               
                                
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
    
    //MARK: Get Project Details API
    func getProjectDetails()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
      
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/get_project_detail"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["project_id": otherProj]
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
                               let loginResponse = try? JSONDecoder().decode(ProjectResponseAdmin.self, from: jsonData) {
                               
                                self.projId = loginResponse.project.id
                                self.projectName.text = loginResponse.project.projectName
                                self.selectCustomer.text = loginResponse.project.customerName
                                self.enterLocation.text = loginResponse.project.location
                                self.selectManager.text = loginResponse.project.managerName
                                self.streetTV.text = loginResponse.project.street
                                self.streetTV.textColor = .black
                                self.savelat = loginResponse.project.latitude
                                self.savelng = loginResponse.project.longitude
                                self.createBtn.setTitle("Save Project", for: .normal)
            
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
    
    
    //MARK: Delete TimeCard
    func deleteProject(id : Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let url = "\(ApiLink.HOST_URL)/delete_project"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        
        print("Access Token: \(accessToken)")
        var param: Parameters = ["":""]
        param = ["project_id": id]
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
                            _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.success,buttonTitle:"OK"){ (isOtherButton) -> Void in
                                if isOtherButton == true {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                            
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
extension AddAdminProjVC: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Street"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.adjustTextViewHeight()
    }
    func adjustTextViewHeight() {
        let fixedWidth = streetTV.frame.size.width
        let newSize = streetTV.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        self.textviewheight.constant = newSize.height
        self.view.layoutIfNeeded()
    }
}
