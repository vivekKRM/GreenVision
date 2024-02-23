//
//  ForgotPasswordVC.swift
//  surfers
//
//  Created by United It Services on 18/08/23.
//

import UIKit
import Alamofire
class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    var email: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    
    @IBAction func submitBtnTap(_ sender: UIButton) {
        if checkAll(){
            workerForgetPassword(email: emailTF.text ?? "")
        }
    }
    
}
//MARK: All Functionality
extension ForgotPasswordVC: UITextFieldDelegate
{
    func firstCall()
    {
        submitBtn.roundedButton()
        self.title = "Forgot Password".localizeString(string: lang)
        emailTF.placeholder = "Enter Email Address".localizeString(string: lang)
        submitBtn.setTitle("Request Now".localizeString(string: lang), for: .normal)
        infoLabel.text = "Please enter registered Email Id and click the 'Request Now' button below to contact the Admin for password reset request.".localizeString(string: lang)
        addBlackBorder(to: emailTF)
        emailTF.text = email
    }
    func checkAll() -> Bool{
        self.view.endEditing(true)
        if emailTF.text == "" || isValidEmailAddress(emailAddressString: emailTF.text ?? "") == false{
            _ = SweetAlert().showAlert("", subTitle:  "Please enter valid E-mail address".localizeString(string: lang), style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return false
        }else{
            return true
        }
    }
}
//MARK: API Integration
extension ForgotPasswordVC {
    
    //MARK: Forgot Password API
    func workerForgetPassword(email: String)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/forget_password"
        param = ["email": email]
        print(param)
        AF.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                    
                case .success(let value):
                    let dict = value as! [String:Any]
                    if let jsonData = try? JSONSerialization.data(withJSONObject: value),
                       let loginResponse = try? JSONDecoder().decode(DefaultInfo.self, from: jsonData) {
                        
                        if loginResponse.status == 200
                        {
                                progressHUD.hide()
                            self.navigationController?.popViewController(animated: true)
                            
                        }else if loginResponse.status == 403{
                            progressHUD.hide()
                            if let appDomain = Bundle.main.bundleIdentifier {
                                UserDefaults.standard.removePersistentDomain(forName: appDomain)
                            }
                            NotificationCenter.default.removeObserver(self)
                            _ = SweetAlert().showAlert("", subTitle:  loginResponse.message, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang)){ (isOtherButton) -> Void in
                                if isOtherButton == true {
                                    ksceneDelegate?.logout()
                                }
                            }
                        }else if loginResponse.status == 202{
                            progressHUD.hide()
                            _ = SweetAlert().showAlert("", subTitle:  loginResponse.message, style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
                        }else if loginResponse.status == 201{
                            progressHUD.hide()
                            _ = SweetAlert().showAlert("", subTitle:  loginResponse.message, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
                        }else{
                            _ = SweetAlert().showAlert("", subTitle:  loginResponse.message, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
                        }
                            
                        } else {
                            print("Error decoding JSON")
                            _ = SweetAlert().showAlert("", subTitle: "Error Decoding".localizeString(string: lang), style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
                            progressHUD.hide()
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
