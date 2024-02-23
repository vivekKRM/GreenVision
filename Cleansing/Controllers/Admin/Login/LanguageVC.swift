//
//  LanguageVC.swift
//  Cleansing
//
//  Created by uis on 17/01/24.
//

import UIKit
import Alamofire
class LanguageVC: UIViewController {

    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var languageTV: UITableView!
    @IBOutlet weak var chooseLabel: UILabel!
    @IBOutlet weak var subLabelText: UILabel!
    
    var selectedIndexPath: IndexPath?
    var onDismiss: ((String) -> Void)?
    var status:Int = 0
    var language:[String] = []
    var langKey:[String] = []
    var languageSelected:String = ""
    var languageSend:String = ""
    var chnageText:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        proceedBtn.roundedButton()
        getLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        lang = UserDefaults.standard.string(forKey: "Lang") ?? "en"
        subLabelText.text = "Select your preferred language to use Green Vision Cleansing App easily.".localizeString(string: lang)
        if chnageText{
            proceedBtn.setTitle("SUBMIT".localizeString(string: lang), for: .normal)
            chooseLabel.text = "Update your language".localizeString(string: lang)
        }else{
            proceedBtn.setTitle("CONTINUE".localizeString(string: lang), for: .normal)
            chooseLabel.text = "Choose your language".localizeString(string: lang)
        }
    }
    @IBAction func continueBtnTap(_ sender: UIButton) {
        if languageSelected == ""{
            _ = SweetAlert().showAlert("", subTitle:  "Please select the language to proceed.".localizeString(string: lang), style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
        }else{
            if chnageText {
                updateLanguage(lang: languageSelected)
            }else{
                UserDefaults.standard.setValue(languageSelected, forKey: "Lang")
                if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC{
                    VC.langer = languageSelected
                    self.navigationController?.pushViewController(VC, animated: true)
                }
            }
          
        }
    }
    
    
    
}

//MARK: TableView Delegate
extension LanguageVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.language.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lCell", for: indexPath) as! LanguageTVC
        cell.langBtn.setTitle(self.language[indexPath.row], for: .normal)
        cell.langBtn.tag = indexPath.row
        cell.langBtn.addTarget(self, action: #selector(tapLang(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    @objc func tapLang(_ sender: UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
           
           // Deselect previously selected row if any
           if let selectedIndexPath = selectedIndexPath {
               if let selectedCell = languageTV.cellForRow(at: selectedIndexPath) as? LanguageTVC {
                   selectedCell.langBtn.setImage(UIImage(systemName: "circle"), for: .normal)
               }
           }
           
           // Select the newly tapped cell
           if let tappedCell = languageTV.cellForRow(at: indexPath) as? LanguageTVC {
               tappedCell.langBtn.setImage(UIImage(systemName: "circle.fill"), for: .normal)
           }
           
           // Update selectedIndexPath
           selectedIndexPath = indexPath
           
           // Update selected language
           languageSelected = self.langKey[indexPath.row]
           languageSend = self.language[indexPath.row]
    }
}


//MARK: API Integartion
extension LanguageVC {
    
    //MARK: Get Language
    func getLanguage()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        let fcmToken:String = UserDefaults.standard.string(forKey: "fcm") ?? ""
        let url = "\(ApiLink.HOST_URL)/get_lang"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        print("Access Token: \(accessToken)")
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
                               let loginResponse = try? JSONDecoder().decode(LanguageResponse.self, from: jsonData) {
                               
                                self.language.removeAll()
                                self.langKey.removeAll()
                                for i in 0..<loginResponse.languages.count{
                                    self.language.append(loginResponse.languages[i].name)
                                    self.langKey.append(loginResponse.languages[i].shortName)
                                }
                                progressHUD.hide()
                                DispatchQueue.main.async {
                                    self.languageTV.delegate = self
                                    self.languageTV.dataSource = self
                                    self.languageTV.reloadData()
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
                                UserDefaults.standard.setValue(self.languageSelected, forKey: "Lang")
                                self.onDismiss?(self.languageSend)
                                self.dismiss(animated: true, completion: nil)
                                
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
