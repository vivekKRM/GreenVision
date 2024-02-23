//
//  ViewFullDataVC.swift
//  Cleansing
//
//  Created by uis on 13/12/23.
//

import UIKit
import Alamofire
class ViewFullDataVC: UIViewController {
    
    @IBOutlet weak var fullDataTV: UITableView!
    var status: Int = 0
    var daywise = [dayWiseData]()
    var task_id: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Day Wise Data".localizeString(string: lang)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewFullData(id: task_id)
    }
    
    
    
}


//MARK: TableView Delegate
extension ViewFullDataVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daywise.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vfdCell", for: indexPath) as! ViewFullDataTVC
        cell.dayNumber.text = daywise[indexPath.row].day
        cell.breakDuration.text = daywise[indexPath.row].breakTime + " Min".localizeString(string: lang)
        cell.startTime.text = daywise[indexPath.row].startDateTime
        cell.finishTime.text =  daywise[indexPath.row].endDateTime
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
extension ViewFullDataVC {
    
    //MARK: Task Detail API
    func viewFullData(id: String)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/day_wise_data"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["task_id": id]
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
                           let loginResponse = try? JSONDecoder().decode(ApiResponse.self, from: jsonData) {
                            self.daywise.removeAll()
                            for i in 0..<loginResponse.dayWiseData.count{
                                self.daywise.append(dayWiseData.init(startDateTime: loginResponse.dayWiseData[i].startDateTime, endDateTime: loginResponse.dayWiseData[i].endDateTime ?? "", totalWorkHours: loginResponse.dayWiseData[i].totalWorkHours, totalWorkMin: loginResponse.dayWiseData[i].totalWorkMin, totalWorkSec: loginResponse.dayWiseData[i].totalWorkSec, day: loginResponse.dayWiseData[i].day, breakTime: loginResponse.dayWiseData[i].breakTime))
                            }
                            progressHUD.hide()
                            DispatchQueue.main.async {
                                self.fullDataTV.delegate = self
                                self.fullDataTV.dataSource = self
                                self.fullDataTV.reloadData()
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
