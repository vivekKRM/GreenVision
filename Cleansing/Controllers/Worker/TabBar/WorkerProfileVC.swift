//
//  WorkerProfileVC.swift
//  Cleansing
//
//  Created by United It Services on 01/09/23.
//

import UIKit
import Alamofire
class WorkerProfileVC: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var appVersion: UILabel!
    @IBOutlet weak var profileTV: UITableView!
    @IBOutlet weak var versionInfo: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    var profileData = [profile]()
    var selecteLang:String = "English"
    var status:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Profile".localizeString(string: lang)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    
}
extension WorkerProfileVC {
    
    func firstCall()
    {
        lang = UserDefaults.standard.string(forKey: "Lang") ?? "en"
        profileImage.layer.cornerRadius = 45
        profileImage.layer.masksToBounds = true
        profileLabel.text = "My Profile".localizeString(string: lang)
        appVersion.text = "Worker".localizeString(string: lang)
        workerGetProfile()
        profileData.append(profile.init(image: ["profile2","language","email2","logout2"], name: ["Edit My Profile".localizeString(string: lang),"Update Language".localizeString(string: lang),"Contact Us".localizeString(string: lang),"LogOut".localizeString(string: lang)]))//,"logout2"
        profileTV.delegate = self
        profileTV.dataSource = self
        profileTV.reloadData()
        
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            print("Current App Version: \(appVersion)")
            versionInfo.text = "App Version: ".localizeString(string: lang) + appVersion
        } else {
            print("Unable to retrieve app version.")
        }
        localizeTabBar()
    }
    
    //MARK: Change Text of TabBar
    func localizeTabBar() {
        lang = UserDefaults.standard.string(forKey: "Lang") ?? "en"
        tabBarController?.tabBar.items![0].title = "Clock".localizeString(string: lang)
        tabBarController?.tabBar.items![1].title = "Tasks".localizeString(string: lang)
        tabBarController?.tabBar.items![2].title = "Time Cards".localizeString(string: lang)
        tabBarController?.tabBar.items![3].title = "My Profile".localizeString(string: lang)
    }
}

extension WorkerProfileVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileData[section].name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pCell", for: indexPath) as! ProfileTVC
        cell.settingImage.image = UIImage(named: profileData[indexPath.section].image[indexPath.row])
        cell.settingText.text = profileData[indexPath.section].name[indexPath.row]
        cell.langugaeBtn.setTitle(selecteLang, for: .normal)
        if indexPath.row == 1{
            cell.langugaeBtn.isHidden = false
        }else{
            cell.langugaeBtn.isHidden = true
        }
        cell.langugaeBtn.addTarget(self, action: #selector(setLang(_:)), for: .touchUpInside)
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
        if indexPath.row == 0{
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WorkerEditProfileVC") as? WorkerEditProfileVC{
                VC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }else if indexPath.row == 1{
//            showLanguageAlert()
        }else if indexPath.row == 2{
            showAlert()
        }else{
            let refreshAlert = UIAlertController(title: "", message: "Do you want to Logout ?".localizeString(string: lang), preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel".localizeString(string: lang), style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                refreshAlert .dismiss(animated: true, completion: nil)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "LogOut".localizeString(string: lang), style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                self.logOut()
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Contact Us".localizeString(string: lang), message: "", preferredStyle: .alert)
        
        // Add the first button with a handler
        let firstAction = UIAlertAction(title: "(802) 829-2903", style: .default) { (action) in
            // Handle the action when the first button is tapped
            print("First Button Tapped")
            self.makePhoneCall()
        }
        
        // Add the second button with a handler
        let secondAction = UIAlertAction(title: "greenvisioncleansing@gmail.com", style: .default) { (action) in
            // Handle the action when the second button is tapped
            print("Second Button Tapped")
            self.sendEmail()
        }
        
        let dismissAction = UIAlertAction(title: "Dismiss".localizeString(string: lang), style: .cancel, handler: nil)
        
        // Set the text color of the buttons to black
        alertController.view.tintColor = .black
        dismissAction.setValue(UIColor.red, forKey: "titleTextColor")
        // Add actions to the alert controller
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(dismissAction)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
        
    }
    @objc func setLang(_ sender: UIButton){
        
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LanguageVC") as? LanguageVC{
            // Set the modal presentation style to .pageSheet or .formSheet
            VC.chnageText = true
            VC.modalPresentationStyle = .pageSheet
            // Use the present method to present the view controller
            VC.onDismiss = { data in
                        print("Received data: \(data)")
                self.selecteLang = data as String
                lang = UserDefaults.standard.string(forKey: "Lang") ?? "en"
                self.title = "My Profile".localizeString(string: lang)
                if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    print("Current App Version: \(appVersion)")
                    self.versionInfo.text = "App Version: ".localizeString(string: lang) + appVersion
                } else {
                    print("Unable to retrieve app version.")
                }
                self.profileLabel.text = "My Profile".localizeString(string: lang)
                self.appVersion.text = "Worker".localizeString(string: lang)
                self.profileData.removeAll()
                self.profileData.append(profile.init(image: ["profile2","language","email2","logout2"], name: ["Edit My Profile".localizeString(string: lang),"Update Language".localizeString(string: lang),"Contact Us".localizeString(string: lang),"LogOut".localizeString(string: lang)]))//,"logout2"
                self.workerGetProfile()
            }
            present(VC, animated: true, completion: nil)
        }
    }
    
    func showLanguageAlert() {
        let alertController = UIAlertController(title: "Select Language".localizeString(string: lang), message: "", preferredStyle: .alert)
        
        // Add the first button with a handler
        let firstAction = UIAlertAction(title: "French".localizeString(string: lang), style: .default) { (action) in
            // Handle the action when the first button is tapped
            print("First Button Tapped")
            self.selecteLang = "French".localizeString(string: lang)
//            self.updateLanguage(lang: "fr")
        }
        
        // Add the second button with a handler
        let secondAction = UIAlertAction(title: "Spanish".localizeString(string: lang), style: .default) { (action) in
            // Handle the action when the second button is tapped
            print("Second Button Tapped")
            self.selecteLang = "Spanish".localizeString(string: lang)
//            self.updateLanguage(lang: "sp")
        }
        
        // Add the first button with a handler
        let thirdAction = UIAlertAction(title: "English".localizeString(string: lang), style: .default) { (action) in
            // Handle the action when the first button is tapped
            print("Third Button Tapped")
            self.selecteLang = "English".localizeString(string: lang)
//            self.updateLanguage(lang: "eng")
        }

        
        let dismissAction = UIAlertAction(title: "Dismiss".localizeString(string: lang), style: .cancel, handler: nil)
        
        // Set the text color of the buttons to black
        alertController.view.tintColor = .black
        dismissAction.setValue(UIColor.red, forKey: "titleTextColor")
        // Add actions to the alert controller
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(thirdAction)
        alertController.addAction(dismissAction)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
        
    }
    
    func makePhoneCall() {
        if let phoneURL = URL(string: "tel://8028292903") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                print("Unable to initiate a phone call.")
            }
        }
    }
    
    func sendEmail() {
        let email = "greenvisioncleansing@gmail.com"
        let subject = "Support"
        let body = "Your email body goes here..."
        
        if let emailEncoded = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let emailURL = URL(string: "mailto:\(emailEncoded)?subject=\(subjectEncoded)&body=\(bodyEncoded)") {
                if UIApplication.shared.canOpenURL(emailURL) {
                    UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
                } else {
                    print("Unable to open the default email app.")
                }
            } else {
                print("Invalid email components for URL.")
            }
    }
    
    
    
}

//MARK: API Integartion
extension WorkerProfileVC{
    
    //MARK: Get Profile API
    func workerGetProfile()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/get_profile"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        print("Access Token: \(accessToken)")
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["Authorization": "Bearer "+accessToken+""])
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
                           let loginResponse = try? JSONDecoder().decode(ProfileInfo.self, from: jsonData) {
                            
                            self.getImageFromURL(imageView: self.profileImage, stringURL: loginResponse.url + (loginResponse.data.profile_image ?? ""))
                            self.userName.text = loginResponse.data.fullname
                            self.userEmail.text = loginResponse.data.mobile_number
                            self.selecteLang = loginResponse.lang
                            self.localizeTabBar()
                            self.profileTV.reloadData()
                            
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
    
    //MARK: Logout API
    func logOut()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/logout"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        print("Access Token: \(accessToken)")
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: ["Authorization": "Bearer "+accessToken+""])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                    
                case .success(let value):
                    let dict = value as! [String:Any]
                    self.status = dict["status"] as! Int
                    if self.status == 200
                    {
                        progressHUD.hide()
                        UserDefaults.standard.setValue(false, forKey: "signed")
                        ksceneDelegate?.logout()
                        
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
    
    //MARK: Update Language
    func updateLanguage(lang: String)
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
        let url = "\(ApiLink.HOST_URL)/update_lang"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["lang": lang]
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
                                self.profileTV.reloadData()
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
