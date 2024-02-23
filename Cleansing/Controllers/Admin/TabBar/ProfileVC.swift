//
//  ProfileVC.swift
//  surfers
//
//  Created by United It Services on 21/08/23.
//

import UIKit
import Alamofire
class ProfileVC: UIViewController {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var appVersion: UILabel!
    @IBOutlet weak var profileTV: UITableView!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    var selecteLang:String = "English".localizeString(string: lang)
    var profileData = [profile]()
    var language:[String] = []
    var langKey:[String] = []
    var status:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        lang = UserDefaults.standard.string(forKey: "Lang") ?? "en"
        self.title = "Profile".localizeString(string: lang)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    
}
extension ProfileVC {
    
    func firstCall()
    {
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 45
        getProfile()
        profileData.append(profile.init(image: ["profile2","dashboard","language","worker","logout2"], name: ["Edit My Profile".localizeString(string: lang),"My Dashboard".localizeString(string: lang),"Update Language".localizeString(string: lang),"My Invites".localizeString(string: lang),"LogOut".localizeString(string: lang)]))
        appVersion.text = "Manager".localizeString(string: lang)
        firstLabel.text = "My Profile".localizeString(string: lang)
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            print("Current App Version: \(appVersion)")
            appVersionLabel.text = "App Version: ".localizeString(string: lang) + appVersion
        } else {
            print("Unable to retrieve app version.")
        }
        
        profileTV.delegate = self
        profileTV.dataSource = self
        profileTV.reloadData()
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource
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
        if indexPath.row == 2{
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
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC{
                VC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }else if indexPath.row == 1{
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC{
                VC.hidesBottomBarWhenPushed = true
                     self.navigationController?.pushViewController(VC, animated: true)
                 }
        }else if indexPath.row == 2{
            
        }else if indexPath.row == 3{
            self.tabBarController?.selectedIndex = 4
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
        let alertController = UIAlertController(title: "", message: "Contact Us".localizeString(string: lang), preferredStyle: .alert)
        
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
//        showLanguageAlert()
        
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
                    self.appVersionLabel.text = "App Version: ".localizeString(string: lang) + appVersion
                } else {
                    print("Unable to retrieve app version.")
                }
                self.firstLabel.text = "My Profile".localizeString(string: lang)
                self.appVersion.text = "Manager".localizeString(string: lang)
                self.profileData.removeAll()
                self.profileData.append(profile.init(image: ["profile2","dashboard","language","worker","logout2"], name: ["Edit My Profile".localizeString(string: lang),"My Dashboard".localizeString(string: lang),"Update Language".localizeString(string: lang),"My Invites".localizeString(string: lang),"LogOut".localizeString(string: lang)]))
                self.getProfile()
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
            self.selecteLang = "French"
            self.profileTV.reloadData()
        }
        // Add the second button with a handler
        let secondAction = UIAlertAction(title: "Spanish".localizeString(string: lang), style: .default) { (action) in
            // Handle the action when the second button is tapped
            print("Second Button Tapped")
            self.selecteLang = "Spanish"
            self.profileTV.reloadData()
        }
        // Add the first button with a handler
        let thirdAction = UIAlertAction(title: "English".localizeString(string: lang), style: .default) { (action) in
            // Handle the action when the first button is tapped
            print("Third Button Tapped")
            self.selecteLang = "English"
            self.profileTV.reloadData()
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
extension ProfileVC{
    
    //MARK: Get Profile API
    func getProfile()
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
                        let defaults = UserDefaults.standard
                        let dictionary = defaults.dictionaryRepresentation()
                        dictionary.keys.forEach { key in
                            defaults.removeObject(forKey: key)
                        }
                        UserDefaults.standard.synchronize()
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
    
}
