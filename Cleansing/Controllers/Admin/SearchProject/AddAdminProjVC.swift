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
    @IBOutlet weak var enterLocation: UITextView!
    @IBOutlet weak var selectManager: UITextField!
    @IBOutlet weak var streetTV: UITextView!
    @IBOutlet weak var textviewheight: NSLayoutConstraint!
    @IBOutlet weak var topName: UILabel!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    
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
            topName.text = "Edit Project".localizeString(string: lang)
        }else{
            topName.text = "Create Project".localizeString(string: lang)
        }
        streetTV.text = "Enter Street No.".localizeString(string: lang)
        streetTV.textColor = UIColor.lightGray
        streetTV.tintColor = UIColor.init(hexString: "528E4A")
        projectName.tintColor = UIColor.init(hexString: "528E4A")
        selectCustomer.tintColor = UIColor.init(hexString: "528E4A")
        selectManager.tintColor = UIColor.init(hexString: "528E4A")
        createBtn.setTitle("Create Project".localizeString(string: lang), for: .normal)
        streetTV.delegate = self
        self.textviewheight.isActive = true
        streetTV.layer.borderColor = UIColor.lightGray.cgColor
        streetTV.layer.borderWidth = 1.0
        streetTV.layer.cornerRadius = 10.0
        streetTV.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden  = true
        firstCall()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden  = false
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
            if type == "Edit"{
                if streetTV.text == "Enter Street No.".localizeString(string: lang){
                    streetTV.text = ""
                }
                if enterLocation.text == "Choose a project location".localizeString(string: lang){
                    enterLocation.text = ""
                }
                editProject(project_name: projectName.text ?? "", customer_id: customerId, manager_id: managerId, location: enterLocation.text ?? "", latitude: savelat, longitude:  savelng, street: streetTV.text ?? "")
            }else{
                if streetTV.text == "Enter Street No.".localizeString(string: lang){
                    streetTV.text = ""
                }
                if enterLocation.text == "Choose a project location".localizeString(string: lang){
                    enterLocation.text = ""
                }
                addProject(project_name: projectName.text ?? "", customer_id: customerId, manager_id: managerId, location: enterLocation.text ?? "", latitude: savelat, longitude:  savelng, street: streetTV.text ?? "")
            }
        }
    }
    
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: First Call
extension AddAdminProjVC {
    
    func firstCall()
    {
        
        firstLabel.text = "PROJECT DETAILS".localizeString(string: lang)
        secondLabel.text = "PROJECT LOCATION".localizeString(string: lang)
        thirdLabel.text = "ASSIGN MANAGERS".localizeString(string: lang)
        projectName.placeholder = "Enter a project name".localizeString(string: lang)
        selectCustomer.text = "Select customer name".localizeString(string: lang)
        enterLocation.text = "Choose a project location".localizeString(string: lang)
        enterLocation.textColor = .lightGray
        enterLocation.layer.cornerRadius = 5
        enterLocation.layer.masksToBounds = true
        enterLocation.layer.borderColor = UIColor.black.cgColor
        enterLocation.layer.borderWidth = 0.5
        selectManager.text = "Select manager name".localizeString(string: lang)
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
            self.view.endEditing(true)
        }
        if let retrievedIntArray = UserDefaults.standard.array(forKey: "si") as? [String] {
            print(retrievedIntArray)
            managerId = retrievedIntArray.joined(separator: ",")
            self.view.endEditing(true)
        }
    }
    
    @objc func disconnectPaxiSocketLocation(_ notification: Notification) {
        enterLocation.text = UserDefaults.standard.string(forKey: "PlaceName")
        enterLocation.textColor = .black
        print(UserDefaults.standard.dictionary(forKey: "Map")  ?? [:])
        let map = UserDefaults.standard.dictionary(forKey: "Map")  ?? [:]
        savelat = map["lat"] as? String ?? "0.0"
        savelng =  map["long"] as? String ?? "0.0"
        self.view.endEditing(true)
    }
    
    
    @objc func deleteButtonTapped() {
        let refreshAlert = UIAlertController(title: "Delete Project".localizeString(string: lang), message: "Deleting project will delete all your tasks,time cards data, related to this project".localizeString(string: lang), preferredStyle: UIAlertController.Style.alert)
            
        refreshAlert.addAction(UIAlertAction(title: "Cancel".localizeString(string: lang), style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                refreshAlert .dismiss(animated: true, completion: nil)
            }))
            
        refreshAlert.addAction(UIAlertAction(title: "Delete".localizeString(string: lang), style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                self.deleteProject(id: self.projId)
            }))
            self.present(refreshAlert, animated: true, completion: nil)
           
        }
    
    func checkAll() -> Bool{
        if projectName.text == "" || projectName.text?.count ?? 0 < 3{
            _ = SweetAlert().showAlert("", subTitle:  "Please enter project name".localizeString(string: lang), style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return false
        }else if selectCustomer.text == "" || selectCustomer.text?.count ?? 0 < 3{
            _ = SweetAlert().showAlert("", subTitle:  "Please choose workers".localizeString(string: lang), style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return false
        }else if streetTV.text == "Select Street".localizeString(string: lang) || streetTV.text == ""{
            _ = SweetAlert().showAlert("", subTitle:  "Please enter street".localizeString(string: lang), style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return false
        }else if enterLocation.text == "Choose a project location".localizeString(string: lang) || enterLocation.text?.count ?? 0 < 3{
            _ = SweetAlert().showAlert("", subTitle:  "Please choose location of project".localizeString(string: lang), style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return false
        }else if selectManager.text == "" || selectManager.text?.count ?? 0 < 3{
            _ = SweetAlert().showAlert("", subTitle:  "Please choose manager for project".localizeString(string: lang), style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
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
                    presentationController.detents = [.large()] /// change to [.medium(), .large()] for a half *and* full screen sheet
                }
                VC.calledType = "AdminProj"
                self.present(VC, animated: true)
            }
            
        }else if  textField == selectManager{
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CheckListVC") as? CheckListVC{
                if let presentationController = VC.presentationController as? UISheetPresentationController {
                    presentationController.detents = [ .large()] /// change to [.medium(), .large()] for a half *and* full screen sheet
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
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
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
    
    //MARK: Get Project Details API
    func getProjectDetails()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
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
                                self.enterLocation.textColor = .black
                                self.selectManager.text = loginResponse.project.managerName
                                self.streetTV.text = loginResponse.project.street
                                self.streetTV.textColor = .black
                                self.savelat = loginResponse.project.latitude
                                self.savelng = loginResponse.project.longitude
                                self.createBtn.setTitle("Save Project".localizeString(string: lang), for: .normal)
                                self.customerId = "\(loginResponse.project.customerID)"
                                self.managerId = loginResponse.project.managerID
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
    func deleteProject(id : Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
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
    
    //MARK: Edit Project API
    func editProject(project_name: String, customer_id: String, manager_id: String, location: String, latitude: String, longitude: String, street: String)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
      
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/edit_project"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["project_name": project_name,"customer_id": customer_id, "manager_id": manager_id,"location": location, "latitude": latitude , "longitude": longitude, "street": street, "project_id":  otherProj]
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
extension AddAdminProjVC: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView != enterLocation{
            if textView.text.isEmpty {
                textView.text = "Enter Street No.".localizeString(string: lang)
                textView.textColor = UIColor.lightGray
            }
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == enterLocation{
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationVC") as? LocationVC{
                if let presentationController = VC.presentationController as? UISheetPresentationController {
                    presentationController.detents = [.large()]
                }
                self.present(VC, animated: true)
            }
        }
        return true
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
