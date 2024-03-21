//
//  LoginVC.swift
//  surfers
//
//  Created by United It Services on 18/08/23.
//

import UIKit
import Alamofire

class LoginVC: UIViewController {
    
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var forgotBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var eyeBtn: UIButton!
    @IBOutlet weak var loginNow: UILabel!
    @IBOutlet weak var enterCredentials: UILabel!
    
    var status:Int = 0
    var langer:String = ""
    var message: String = ""
    var hide:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        signInBtn.roundedButton()
        iconImage.layer.masksToBounds = true
        iconImage.layer.cornerRadius = iconImage.frame.height / 2
        addBlackBorder(to: mobileTF)
        addBlackBorder(to: passwordTF)
        passwordTF.setRightPaddingPoints(60)
        passwordTF.tintColor = UIColor.init(hexString: "528E4A")
        mobileTF.tintColor = UIColor.init(hexString: "528E4A")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lang = UserDefaults.standard.string(forKey: "Lang") ?? "en"
        forgotBtn.setTitle("Forgot Password ?".localizeString(string: lang), for: .normal)
        registerBtn.setTitle("Don't have an account? Register".localizeString(string: lang), for: .normal)
        signInBtn.setTitle("Login".localizeString(string: lang), for: .normal)
        loginNow.text = "Login Now".localizeString(string: lang)
        enterCredentials.text = "Please enter your credentials to continue.".localizeString(string: lang)
        mobileTF.placeholder = "Enter Email Address".localizeString(string: lang)
        passwordTF.placeholder = "Enter Your Password".localizeString(string: lang)
        self.navigationController?.isNavigationBarHidden = false
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
        }
        hideRegister()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func forgotBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordVC") as? ForgotPasswordVC{
            VC.email = mobileTF.text ?? ""
            self.navigationController?.pushViewController(VC, animated: true)
        }
//        presentBottomDrawer()
    }
    
    @IBAction func termsBtnTap(_ sender: UIButton) {
        //        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserTypeVC") as? UserTypeVC{
        //            self.navigationController?.pushViewController(VC, animated: true)
        //        }
    }
 
    @IBAction func signInBtnTap(_ sender: UIButton) {
        if checkAll(){
            workerLogin(email: mobileTF.text ?? "", password: passwordTF.text ?? "")
        }
    }
    
    @IBAction func createBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC{
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func eyeBtnTap(_ sender: UIButton) {
        passwordTF.isSecureTextEntry.toggle()
        let imageName = passwordTF.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        eyeBtn.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    
}
//MARK: API Handles and Process
extension LoginVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
  
    func checkAll() -> Bool{
        self.view.endEditing(true)
        if mobileTF.text == "" || isValidEmailAddress(emailAddressString: mobileTF.text ?? "") == false{
            _ = SweetAlert().showAlert("", subTitle:  "Please enter valid E-mail address".localizeString(string: lang), style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return false
        }else if passwordTF.text == "" || passwordTF.text == " "  {
            _ = SweetAlert().showAlert("", subTitle:  "Password field cannot be empty".localizeString(string: lang), style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return false
        }else{
            return true
        }
    }
    
    func openDeviceSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        }
    }
    
    func presentBottomDrawer() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "BottomDrawerVC") as! BottomDrawerVC
                
                if let presentationController = viewController.presentationController as? UISheetPresentationController {
                    presentationController.detents = [ .large()]
                    presentationController.preferredCornerRadius = 40
                }
        self.present(viewController, animated: true)
        }
    
}
//MARK: API Integration
extension LoginVC {
    
    //MARK: Login API
    func workerLogin(email: String, password: String)
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
        let url = "\(ApiLink.HOST_URL)/login"
        param = ["email": email, "password": password ,"fcm_token": fcmToken, "device_type": "ios", "lang": self.langer]
        print(param)
        AF.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil)
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
                           let loginResponse = try? JSONDecoder().decode(LoginInfo.self, from: jsonData) {
                            // Now you can access the properties of loginResponse, such as loginResponse.status, loginResponse.token, etc.
                            print(loginResponse.user.fullname)
                            UserDefaults.standard.set(loginResponse.user.id, forKey: "userId")
                            UserDefaults.standard.set(loginResponse.token, forKey: "token")
                            progressHUD.hide()
                            if loginResponse.user.role == 1{
                                //1. Admin
                                UserDefaults.standard.setValue("Admin", forKey: "userType")
                                let obj = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "CleansingTBC") as! CleansingTBC
                                ksceneDelegate!.window?.rootViewController = obj
                                ksceneDelegate!.window?.makeKeyAndVisible()
                            }else if loginResponse.user.role == 2{
                                //2. Manager
                                UserDefaults.standard.setValue("Admin", forKey: "userType")
                                let obj = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "CleansingTBC") as! CleansingTBC
                                ksceneDelegate!.window?.rootViewController = obj
                                ksceneDelegate!.window?.makeKeyAndVisible()
                            }else{
                                //3.Worker
                                UserDefaults.standard.setValue("Worker", forKey: "userType")
                                let obj = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "WorkerTBC") as! WorkerTBC
                                ksceneDelegate!.window?.rootViewController = obj
                                ksceneDelegate!.window?.makeKeyAndVisible()
                            }
                        } else {
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
                            _ = SweetAlert().showAlert("Oops..".localizeString(string: lang), subTitle:  "Something went wrong".localizeString(string: lang), style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
                        }
                    }
                }
            }
    }
    
    
    //MARK: Hide/Unhide API
    func hideRegister()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let url = "\(ApiLink.HOST_URL)/show-registration"
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
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
                            if dict["hide"] as! String == "1"{
                                self.registerBtn.isHidden = false
                            }else{
                                self.registerBtn.isHidden = true
                            }
                        } else {
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
                            _ = SweetAlert().showAlert("Oops..".localizeString(string: lang), subTitle:  "Something went wrong".localizeString(string: lang), style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
                        }
                    }
                }
            }
    }
}
