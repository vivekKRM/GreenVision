//
//  BreakVC.swift
//  Cleansing
//
//  Created by United It Services on 25/09/23.
//

import UIKit
import Alamofire
class BreakVC: UIViewController {
    @IBOutlet weak var breakTV: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var topLabel: UILabel!

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    
    
    var taskId: Int = 0
    var status:Int = 0
    var breaks = [showBreakDetails]()
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBtn.roundedButton()
        doneBtn.setTitle("Done".localizeString(string: lang), for: .normal)
        topLabel.text = "All breaks with duration, start time and stop time".localizeString(string: lang)
        firstLabel.text = "Duration".localizeString(string: lang)
        secondLabel.text = "Start".localizeString(string: lang)
        thirdLabel.text = "End".localizeString(string: lang)
        showBreak(id: taskId)
    }
    
    @IBAction func doneBtnTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
  

}

//MARK: TableView Delegate
extension BreakVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breaks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bCell", for: indexPath) as! BreakTVC
        cell.startTime.text = breaks[indexPath.row].startDate
        cell.endTime.text = breaks[indexPath.row].endDate
        cell.duration.text = breaks[indexPath.row].duration
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
        
    }
    
}
//MARK: API Integration
extension BreakVC {
    
    //MARK: Task Detail API
    func showBreak(id: Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/singletask"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["id": id]
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
                           let loginResponse = try? JSONDecoder().decode(TaskDetailInfo.self, from: jsonData) {
                            self.breaks.removeAll()
                           
                            for i in 0..<(loginResponse.breakTimes?.count ?? 0){
                                self.breaks.append(showBreakDetails(id: loginResponse.breakTimes?[i].id ?? 0, startDate: loginResponse.breakTimes?[i].start_time ?? "", endDate: loginResponse.breakTimes?[i].end_time ?? "", duration: loginResponse.breakTimes?[i].duration ?? ""))
                            }
                            
                            progressHUD.hide()
                            DispatchQueue.main.async {
                                self.breakTV.delegate = self
                                self.breakTV.dataSource = self
                                self.breakTV.reloadData()
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
