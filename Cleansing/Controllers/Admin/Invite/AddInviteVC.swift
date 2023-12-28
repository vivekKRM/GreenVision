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
    @IBOutlet weak var trackingSwitch: UISwitch!
    @IBOutlet weak var approverBtn: UIButton!
    @IBOutlet weak var overtimeBtn: UIButton!
    @IBOutlet weak var breakBtn: UIButton!
    @IBOutlet weak var sendInviteBtn: UIButton!
    @IBOutlet weak var overtimePolicyBtn: UIButton!
    @IBOutlet weak var overtimepolicy: UIView!
    @IBOutlet weak var `break`: UIView!
    var selections = [selectionDetails]()
    var status:Int = 0
    var timeTracking:Bool = false
    var selected: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Send Invite"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectPaxiSocket(_:)), name: Notification.Name(rawValue: "disconnectPaxiSocket"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectPaxiSockets(_:)), name: Notification.Name(rawValue: "disconnectPaxiSockets"), object: nil)
    }
    
    
    @IBAction func switchBtnTap(_ sender: UISwitch) {
        if sender.isOn {
               // Switch is ON
               print("Switch is ON")
            timeTracking = true
           } else {
               // Switch is OFF
               print("Switch is OFF")
               timeTracking = false
           }
    }
    
    
    @IBAction func approverBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CheckListVC") as? CheckListVC{
            if let presentationController = VC.presentationController as? UISheetPresentationController {
                presentationController.detents = [.medium(), .large()]
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
            }else if selections[0].type == "Exempt"{
                overtimeBtn.setTitle(selections[0].watcher_name, for: .normal)
            }
//            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("disconnectPaxiSockets"), object: nil)
        }
    }
    @objc func disconnectPaxiSocket(_ notification: Notification) {
        approverBtn.setTitle(UserDefaults.standard.string(forKey: "cn"), for: .normal)
//       customerId = UserDefaults.standard.string(forKey: "ci") ?? ""
    }
    
    
    @IBAction func overtimeBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectionVC") as? SelectionVC{
            if let presentationController = VC.presentationController as? UISheetPresentationController {
                presentationController.detents = [.medium()]
            }
            VC.calledType = "Exempt"
            self.present(VC, animated: true)
        }
    }
    
    
    @IBAction func breakBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectionVC") as? SelectionVC{
            if let presentationController = VC.presentationController as? UISheetPresentationController {
                presentationController.detents = [.medium()]
            }
            VC.calledType = "Break"
            self.present(VC, animated: true)
        }
    }
    
    @IBAction func sendInviteBtnTap(_ sender: UIButton) {
        if checkAll(){
            sendInvite(role: selected == 0 ? "3" : "\(selected)", name: nameTF.text ?? "", email: emailTF.text ?? "", mobile: mobileTF.text ?? "", time_tracking: timeTracking, time_approver: approverBtn.titleLabel?.text ?? "", overtime_status: overtimeBtn.titleLabel?.text ?? "", overtime_policy: overtimePolicyBtn.titleLabel?.text ?? "", mealbreak_policy: breakBtn.titleLabel?.text ?? "")
        }
    }
      
    
    @IBAction func overtimePolicyBtnTap(_ sender: UIButton) {
    }
    

}
//MARK: FirstCall
extension AddInviteVC {
    
    func firstCall()
    {
        sendInviteBtn.roundedButton()
        if selected != 0{
            overtimepolicy.isHidden = true
        }
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
            _ = SweetAlert().showAlert("", subTitle:  "Name field cannot be empty", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if emailTF.text == "" || isValidEmailAddress(emailAddressString: emailTF.text ?? "") == false{
            _ = SweetAlert().showAlert("", subTitle:  "Please enter valid E-mail address", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if mobileTF.text == "" || mobileTF.text == " " ||  mobileTF.text?.count ?? 0 <= 10{
            _ = SweetAlert().showAlert("", subTitle:  " Please enter a mobile number with 10 or more characters", style: AlertStyle.none,buttonTitle:"OK")
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
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/invite"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["role": role, "name": name, "email": email, "mobile": mobile, "time_tracking": time_tracking, "time_approver": time_approver,"overtime_status": overtime_status, "overtime_policy": overtime_policy, "mealbreak_policy": mealbreak_policy]
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
}
