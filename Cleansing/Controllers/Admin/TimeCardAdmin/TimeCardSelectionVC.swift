//
//  TimeCardSelectionVC.swift
//  Cleansing
//
//  Created by uis on 19/02/24.
//

import UIKit
import Alamofire
class TimeCardSelectionVC: UIViewController {

    
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var checkListTV: UITableView!
    @IBOutlet weak var checkListTopName: UILabel!
    @IBOutlet weak var allView: UIView!
    
    @IBOutlet weak var allBtn: UIButton!
    var dataCompletion: (([String:String]) -> Void)?
    var taskId: Int = 0
    var selectedIndices = Set<Int>()
    var selectedIndex: Int?
    var isChecked = false
    var status: Int = 0
    var calledType:String = ""
    var datas:[String] = []
    var checklist = [showCheckListDetails]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    
    
    @IBAction func submitBtnTap(_ sender: UIButton) {
        var selectedTitles = getTitleFromSelectedIndices()
        print("Selected titles:", selectedTitles)
        if selectedTitles.isEmpty {
            print("selectedTitles is empty")
            selectedTitles["0"] = "All"
        }
        dataCompletion?(selectedTitles)
        self.dismiss(animated: true,completion: nil)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        isChecked.toggle()
        if isChecked {
            allBtn.setImage(UIImage(systemName: "square"), for: .normal)
            // Perform actions when the button is checked
        } else {
            allBtn.setImage( UIImage(systemName: "checkmark.square.fill"), for: .normal)
            selectedIndices.removeAll()
            checkListTV.reloadData()
            // Perform actions when the button is unchecked
        }
    }
    
}
//MARK: First Call
extension TimeCardSelectionVC {
    
    func firstCall()
    {
        submitBtn.setTitle("Submit".localizeString(string: lang), for: .normal)
        submitBtn.roundedButton()
      if calledType == "Status"{
//            self.title = "Select an status".localizeString(string: lang)
            self.checkListTopName.text = "Select an status".localizeString(string: lang)
//            self.checklist.append(showCheckListDetails(id: 1, employee_id: 0, title: "All", project_id: 0, task_id: 0, status:0))
            self.checklist.append(showCheckListDetails(id: 0, employee_id: 0, title: "Clocked in", project_id: 0, task_id: 0, status:0))
            self.checklist.append(showCheckListDetails(id: 2, employee_id: 0, title: "Approved", project_id: 0, task_id: 0, status:0))
            self.checklist.append(showCheckListDetails(id: 1, employee_id: 0, title: "Clocked out", project_id: 0, task_id: 0, status:0))
            self.checkListTV.delegate = self
            self.checkListTV.dataSource = self
            self.checkListTV.reloadData()
        }else if calledType == "Manager"{
            getManager()
        }else{
            getMembers()
        }
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(firstTap(_:)))
        allView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func firstTap(_ sender: UITapGestureRecognizer){
        isChecked.toggle()
        if isChecked {
            allBtn.setImage(UIImage(systemName: "square"), for: .normal)
            // Perform actions when the button is checked
        } else {
            allBtn.setImage( UIImage(systemName: "checkmark.square.fill"), for: .normal)
            selectedIndices.removeAll()
            checkListTV.reloadData()
            // Perform actions when the button is unchecked
        }
       
    }
    
    func getTitleFromSelectedIndices() -> [String: String] {
        var titles = [String: String]()
//        if calledType == "Status"{
//            let id = "\(checklist[selectedIndex ?? 0].id)"
//            let title = checklist[selectedIndex ?? 0].title
//            titles[id] = title
//            UserDefaults.standard.setValue("\(checklist[selectedIndex ?? 0].id)", forKey: "statusT")
//        }else{
            for index in selectedIndices {
                let id = "\(checklist[index].id)"
                let title = checklist[index].title
                titles[id] = title
            }
//        }
        return titles
    }
}

//MARK: TableView Delegate
extension TimeCardSelectionVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tclCell", for: indexPath) as! CheckListTVC
        
        cell.firstLabel.text = checklist[indexPath.row].title
//        if calledType == "Status"{
//            let isSelected = indexPath.row == selectedIndex
//               cell.firstButton.setImage(isSelected ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square"), for: .normal)
//        }else{
            let isSelected = selectedIndices.contains(indexPath.row)
            cell.firstButton.setImage(isSelected ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square"), for: .normal)
//        }
        cell.firstView.tag = indexPath.row
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(firstviewTapped(_:)))
        cell.firstView.addGestureRecognizer(tapGesture)
       
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func firstviewTapped(_ gesture: UITapGestureRecognizer) {
        print("View1 tapped!")
        if let tappedView = gesture.view {
            let index = tappedView.tag
//            if calledType == "Status"{
//                if index == selectedIndex {
//                    selectedIndex = nil
//                } else {
//                    // Otherwise, update the selected index
//                    selectedIndex = index
//                }
//                checkListTV.reloadData()
//            }else{
                if selectedIndices.contains(index) {
                    selectedIndices.remove(index)
                } else {
                    selectedIndices.insert(index)
                    allBtn.setImage(UIImage(systemName: "square"), for: .normal)
                }
                checkListTV.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
//        }
    }
}
//MARK: API Implement

extension TimeCardSelectionVC {
  
    //MARK: Get memebers API to create Task Admin
    func getMembers()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/get_members"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        print(param)
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
                           let loginResponse = try? JSONDecoder().decode(MembersResponse.self, from: jsonData) {
                            self.checkListTopName.text = "Select worker".localizeString(string: lang)
                            
                            self.checklist.removeAll()
//                            self.checklist.append(showCheckListDetails(id: 0, employee_id: 0, title: "All", project_id: 0, task_id: 0, status:0))
                            for i in 0..<loginResponse.members.count{
                                self.checklist.append(showCheckListDetails(id: loginResponse.members[i].id, employee_id: 0, title: loginResponse.members[i].fullname, project_id: 0, task_id: 0, status:0))
                            }
                            progressHUD.hide()
                            self.checkListTV.delegate = self
                            self.checkListTV.dataSource = self
                            self.checkListTV.reloadData()
                            
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
    
    //MARK: Get Manager API
    func getManager()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/get_manager"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        print(param)
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
                           let loginResponse = try? JSONDecoder().decode(ManagerResponse.self, from: jsonData) {
                            self.checkListTopName.text = "Select time approver".localizeString(string: lang)
                            
                            progressHUD.hide()
                            self.checklist.removeAll()
//                            self.checklist.append(showCheckListDetails(id: 0, employee_id: 0, title: "All", project_id: 0, task_id: 0, status:0))
                            for i in 0..<loginResponse.manager.count{
                                self.checklist.append(showCheckListDetails(id: loginResponse.manager[i].id, employee_id: 0, title: loginResponse.manager[i].fullname, project_id: 0, task_id: 0, status:0))
                            }
                            self.checkListTV.delegate = self
                            self.checkListTV.dataSource = self
                            self.checkListTV.reloadData()
                            
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
    
    //Filter TimeCard
    
}
