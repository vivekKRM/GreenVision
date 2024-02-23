//
//  SelectProjectVC.swift
//  Cleansing
//
//  Created by United It Services on 27/10/23.
//

import UIKit
import Alamofire
class SelectProjectVC: UIViewController {

    @IBOutlet weak var selectProjectTV: UITableView!
    @IBOutlet weak var selectProjectBtn: UIButton!
    var alertController: UIAlertController!
    var pickerView: UIPickerView!
    var status:Int = 0
    var project_id: Int = 0
    var showData = [showProject]()
    var searchData = [selectProjectTask]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Project & Task".localizeString(string: lang)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    
    @IBAction func selectDownTap(_ sender: UIButton) {
        present(alertController, animated: true)
    }
    
    @IBAction func selectProjectBtnTap(_ sender: UIButton) {
        present(alertController, animated: true)
    }

}
extension SelectProjectVC{
    
    func firstCall()
    {
        
        selectProjectBtn.layer.cornerRadius = 10
        selectProjectBtn.layer.borderWidth = 1
        selectProjectBtn.layer.borderColor = UIColor.lightGray.cgColor 
               
        getProject()//API
        projectPicker()
        
    }
    //MARK: Project Picker
    func projectPicker()
    {
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        // Create a UIAlertController with a UIPickerView
        alertController = UIAlertController(title: "Select an Option".localizeString(string: lang), message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        // Add the UIPickerView to the UIAlertController
        alertController.view.addSubview(pickerView)
        
        // Define actions for the UIAlertController
        //                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let selectAction = UIAlertAction(title: "Submit".localizeString(string: lang), style: .default) { [weak self] (action) in
            if let selectedRow = self?.pickerView.selectedRow(inComponent: 0) {
                let selectedOption = self?.showData[selectedRow].name ?? ""
                self?.selectProjectBtn.setTitle(selectedOption, for: .normal)
                print(selectedOption ?? "" + "Hello".localizeString(string: lang))
                self?.project_id = self?.showData[selectedRow].id ?? 0
                self?.getTask(id: self?.project_id ?? 0)
            }
        }
        // Add actions to the UIAlertController
        //                alertController.addAction(cancelAction)
        alertController.addAction(selectAction)
        // Configure the UIPickerView
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -40).isActive = true
        pickerView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 10).isActive = true
    }
}

extension SelectProjectVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sptCell", for: indexPath) as! SelectProjectTVC
        cell.taskName.text = searchData[indexPath.row].name
        cell.taskLocation.text = searchData[indexPath.row].location
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
        let myAr = [project_id, searchData[indexPath.row].id, searchData[indexPath.row].name, searchData[indexPath.row].manager_id, searchData[indexPath.row].manager_name] as [Any]
        UserDefaults.standard.setValue(myAr, forKey: "spt")
        self.navigationController?.popViewController(animated: true)
        
    }
}
extension SelectProjectVC: UIPickerViewDelegate, UIPickerViewDataSource {
    // UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return showData.count
    }
    
    // UIPickerViewDelegate methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return showData[row].name
    }
}

//MARK: API Integration
extension SelectProjectVC {
    
    //MARK: Get Project API
    func getProject()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let url = "\(ApiLink.HOST_URL)/assignproject"
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
                           let loginResponse = try? JSONDecoder().decode(GetProjectInfo.self, from: jsonData) {
                            self.showData.removeAll()
                            self.selectProjectBtn.setTitle(loginResponse.data[0].project_name, for: .normal)
                            for i in 0..<loginResponse.data.count{
                                self.showData.append(showProject.init(id: loginResponse.data[i].id, name: loginResponse.data[i].project_name))
                            }
                            self.project_id = self.showData[0].id
                            self.getTask(id: self.showData[0].id)
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
    
    
    //MARK: Get Task API
    func getTask(id: Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/timecard_task_list"
        param = ["project_id": String(id)]
        print(param)
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
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
                           let loginResponse = try? JSONDecoder().decode(TaskResponse.self, from: jsonData) {
                            self.searchData.removeAll()
                            for i in 0..<loginResponse.task.count{
                                self.searchData.append(selectProjectTask(id: loginResponse.task[i].id, name: loginResponse.task[i].taskTitle, location: loginResponse.task[i].location ?? "", manager_id: "\(loginResponse.task[i].manager_id)", manager_name: loginResponse.task[i].manager_name))
                            }
                            progressHUD.hide()
                            DispatchQueue.main.async {
                                self.selectProjectTV.delegate = self
                                self.selectProjectTV.dataSource = self
                                self.selectProjectTV.reloadData()
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
