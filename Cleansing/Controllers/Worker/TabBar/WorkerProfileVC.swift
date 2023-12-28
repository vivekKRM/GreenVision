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
    
    var profileData = [profile]()
    var status:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    
}
extension WorkerProfileVC {
    
    func firstCall()
    {
        profileImage.layer.cornerRadius = 10
        profileImage.layer.masksToBounds = true
        appVersion.text = "Worker"
        
        workerGetProfile()
        profileData.append(profile.init(image: ["profile2","email2"], name: ["Edit Profile","Contact Us"]))//,"logout2"
        profileTV.delegate = self
        profileTV.dataSource = self
        profileTV.reloadData()
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
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }else if indexPath.row == 1{
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactUsVC") as? ContactUsVC{
                self.navigationController?.pushViewController(VC, animated: true)
            }
            
        }else{
            let refreshAlert = UIAlertController(title: "", message: "Do you want to Logout ?", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                refreshAlert .dismiss(animated: true, completion: nil)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "LogOut", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                UserDefaults.standard.setValue(false, forKey: "signed")
                ksceneDelegate?.logout()
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    
    
}

//MARK: API Integartion
extension WorkerProfileVC{
    
    //MARK: Get Profile API
    func workerGetProfile()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
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
                                self.userEmail.text = loginResponse.data.email
                                
                                
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
    
}
