//
//  AddInviteVC.swift
//  Cleansing
//
//  Created by UIS on 16/11/23.
//

import UIKit
import Alamofire

class AddInviteVC: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var approverBtn: UIButton!
    @IBOutlet weak var overtimeBtn: UIButton!
    @IBOutlet weak var breakBtn: UIButton!
    @IBOutlet weak var sendInviteBtn: UIButton!
    @IBOutlet weak var `break`: UIView!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fiveLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    
    
    
    var selections = [selectionDetails]()
    var status:Int = 0
    var overtimeId:String = ""
    var mealpolict:String = ""
    var managerId:String = ""
    var selected: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selected == 0{
            topLabel.text = "Invite Worker".localizeString(string: lang)
        }else if selected == 1{
            topLabel.text = "Invite Manager".localizeString(string: lang)
        }else{
            topLabel.text = "Invite Administrator".localizeString(string: lang)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        firstCall()
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectPaxiSocket(_:)), name: Notification.Name(rawValue: "disconnectPaxiSocket"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectPaxiSockets(_:)), name: Notification.Name(rawValue: "disconnectPaxiSockets"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func approverBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CheckListVC") as? CheckListVC{
            if let presentationController = VC.presentationController as? UISheetPresentationController {
                presentationController.detents = [.large()]
            }
            VC.calledType = "Invite"
            self.present(VC, animated: true)
        }
    }
    
    @objc func disconnectPaxiSockets(_ notification: Notification) {
        if let savedData = UserDefaults.standard.data(forKey: "selections") {
            do {
                let decodedSelections = try JSONDecoder().decode([selectionDetails].self, from: savedData)
                print("Retrieved selections: \(decodedSelections)")
                selections = decodedSelections
            } catch {
                print("Error decoding selections: \(error.localizedDescription)")
            }
        }
        if selections.count > 0{
            if selections[0].type == "Break"{
                breakBtn.setTitle(selections[0].watcher_name, for: .normal)
                mealpolict = selections[0].watcher_id
            }else if selections[0].type == "Exempt"{
                overtimeBtn.setTitle(selections[0].watcher_name, for: .normal)
                overtimeId = selections[0].watcher_id
            }
//            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("disconnectPaxiSockets"), object: nil)
        }
    }
    @objc func disconnectPaxiSocket(_ notification: Notification) {
        approverBtn.setTitle(UserDefaults.standard.string(forKey: "cn"), for: .normal)
        managerId = UserDefaults.standard.string(forKey: "ci") ?? ""
    }
    
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func overtimeBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectionVC") as? SelectionVC{
            if let presentationController = VC.presentationController as? UISheetPresentationController {
                presentationController.detents = [.large()]
            }
            VC.calledType = "Exempt"
            self.present(VC, animated: true)
        }
    }
    
    
    @IBAction func breakBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectionVC") as? SelectionVC{
            if let presentationController = VC.presentationController as? UISheetPresentationController {
                presentationController.detents = [.large()]
            }
            VC.calledType = "Break"
            self.present(VC, animated: true)
        }
    }
    
    @IBAction func sendInviteBtnTap(_ sender: UIButton) {
        if checkAll(){
            sendInvite(role: selected == 0 ? "3" : selected == 1 ? "2" : "1", name: nameTF.text ?? "", email: emailTF.text ?? "", mobile: mobileTF.text ?? "", time_tracking: false, time_approver: approverBtn.titleLabel?.text ?? "", overtime_status: overtimeBtn.titleLabel?.text ?? "", overtime_policy: "", mealbreak_policy: breakBtn.titleLabel?.text ?? "")
        }
    }

}
//MARK: FirstCall
extension AddInviteVC {
    
    func firstCall()
    {
        sendInviteBtn.roundedButton()
        
        
        firstLabel.text = "Personal Details".localizeString(string: lang)
        secondLabel.text = "Time Settings".localizeString(string: lang)
        thirdLabel.text = "Time approver".localizeString(string: lang)
        fourthLabel.text = "Overtime exempt status".localizeString(string: lang)
        fiveLabel.text = "Meal break policy".localizeString(string: lang)
        sendInviteBtn.setTitle("SEND INVITE".localizeString(string: lang), for: .normal)
        nameTF.placeholder = "Name".localizeString(string: lang)
        emailTF.placeholder = "Email".localizeString(string: lang)
        mobileTF.placeholder = "Mobile Number".localizeString(string: lang)
        nameTF.tintColor = UIColor.init(hexString: "528E4A")
        emailTF.tintColor = UIColor.init(hexString: "528E4A")
        mobileTF.tintColor = UIColor.init(hexString: "528E4A")
    }
}

//MARK: TextField Delegate
extension AddInviteVC: UITextFieldDelegate{
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileTF{
            let currentText = textField.text ?? ""
            // Calculate the new text after the user's input
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            // Check if the new text has 10 or fewer characters
            if newText.count <= 13 {
                // Allow the change
                return true
            } else {
                // Reject the change
                return false
            }
        }else{
            return true
        }
    }
    
    func checkAll() -> Bool{
        self.view.endEditing(true)
        if nameTF.text == "" || nameTF.text == " "{
            _ = SweetAlert().showAlert("", subTitle:  "Name field cannot be empty".localizeString(string: lang), style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return false
        }else if emailTF.text == "" || isValidEmailAddress(emailAddressString: emailTF.text ?? "") == false{
            _ = SweetAlert().showAlert("", subTitle:  "Please enter valid E-mail address".localizeString(string: lang), style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return false
        }else if mobileTF.text == "" || mobileTF.text == " " ||  mobileTF.text?.count ?? 0 < 10{
            _ = SweetAlert().showAlert("", subTitle:  "Please enter a mobile number with 10 or more characters".localizeString(string: lang), style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return false
        }else{
            return true
        }
       
    }
}
//MARK: API Call
extension AddInviteVC {
    
    //MARK: Send Ivite
    func sendInvite(role: String, name: String, email: String, mobile: String, time_tracking: Bool, time_approver: String,overtime_status: String, overtime_policy: String, mealbreak_policy: String)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/invite"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["role": role, "name": name, "email": email, "mobile": mobile, "time_tracking": "yes", "time_approver": managerId,"overtime_status": overtimeId, "overtime_policy": "", "mealbreak_policy": mealpolict]
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
