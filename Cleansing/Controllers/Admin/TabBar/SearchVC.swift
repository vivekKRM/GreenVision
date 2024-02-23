//
//  SearchVC.swift
//  surfers
//
//  Created by United It Services on 21/08/23.
//

import UIKit
import Fastis
import Alamofire
class SearchVC: UIViewController {

    @IBOutlet weak var searchTV: UITableView!
    
    @IBOutlet weak var topLabel: UILabel!
    //    @IBOutlet weak var filterBtn: UIButton!
//    @IBOutlet weak var changeDateView: UIView!
//    @IBOutlet weak var changeDateBtn: UIButton!
    
    var status: Int = 0
    var searchData = [search]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        firstCall()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    @IBAction func changeDateBtnTap(_ sender: UIButton) {
        chooseDate()
    }
    
    
    @IBAction func filterBtnTap(_ sender: UIButton) {
    }
    

}
//MARK: First Call
extension SearchVC {
    
    func firstCall()
    {
        topLabel.text = "All Projects".localizeString(string: lang)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("disconnectPaxiSocket"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("disconnectPaxiSockets"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("disconnectPaxiSocketss"), object: nil)
        UserDefaults.standard.removeObject(forKey: "cm")
        UserDefaults.standard.removeObject(forKey: "sm")
        UserDefaults.standard.removeObject(forKey: "Map")
        UserDefaults.standard.removeObject(forKey: "PlaceName")
        UserDefaults.standard.synchronize()
//        changeDateView.layer.masksToBounds = true
//        changeDateView.layer.cornerRadius = 5
        UserDefaults.standard.set("", forKey: "dfilter")
        UserDefaults.standard.setValue( "", forKey: "workerT")
        UserDefaults.standard.setValue( "all", forKey: "statusT")
        UserDefaults.standard.setValue("", forKey: "workerV")
        UserDefaults.standard.setValue("", forKey: "statusV")
        UserDefaults.standard.setValue("", forKey: "approverV")
        UserDefaults.standard.setValue("", forKey: "approverT")
        getProject()
        floatingBtn()
    }
    
    //MARK: Add Floating Button
    func floatingBtn(){
        let floatingButton = UIButton(type: .system)
        floatingButton.frame = CGRect(x: UIScreen.main.bounds.width * 0.8, y: UIScreen.main.bounds.height * 0.8, width: 60, height: 60)
        floatingButton.backgroundColor = UIColor.init(hexString: "5FB8EE")
        floatingButton.layer.cornerRadius = 30 // Half of the width
        floatingButton.setTitle("+", for: .normal)
        floatingButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        floatingButton.setTitleColor(UIColor.black, for: .normal)
        
        // Add a tap action to the button
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        
        // Add the floating button to the view
        view.addSubview(floatingButton)
    }
    
    @objc func floatingButtonTapped() {
        // Handle the button tap action
        print("Floating button tapped!")
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddAdminProjVC") as? AddAdminProjVC{
            VC.hidesBottomBarWhenPushed = true
                 self.navigationController?.pushViewController(VC, animated: true)
             }
    }
    
    //MARK: Choose Date
    func chooseDate() {
            let fastisController = FastisController(mode: .range)
        fastisController.title = "Choose range".localizeString(string: lang)
            fastisController.maximumDate = Date()
            fastisController.allowToChooseNilDate = true
            fastisController.allowDateRangeChanges = true
            fastisController.shortcuts = [.today, .lastWeek]
            fastisController.doneHandler = { resultRange in
                print(resultRange)
                if resultRange != nil{
                    let todata = resultRange?.toDate
                    let fromdata = resultRange?.fromDate
                    self.changeDate(toDate: todata!, fromDate: fromdata!)
                }
                
            }
            fastisController.present(above: self)
        }
    
    func changeDate(toDate: Date , fromDate: Date)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E d MMM"
       let tostring = dateFormatter.string(from: toDate)
        print(tostring)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "E d MMM"
        let fromstring = dateFormatter1.string(from: fromDate)
        print(fromstring)        
        let finals = fromstring + " - " + tostring
//        changeDateBtn.setTitle(finals, for: .normal)
    }
    
}
//MARK: TableView Delegate
extension SearchVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sCell", for: indexPath) as! ShowAdminProjTVC
        cell.projectName.text = searchData[indexPath.row].taskTitle
        if searchData[indexPath.row].breakTime != ""{
            cell.projectCost.setTitle("$ " + searchData[indexPath.row].breakTime, for: .normal)
        }else{
            cell.projectCost.setTitle("", for: .normal)
        }
        cell.projectTime.text = searchData[indexPath.row].startTime
        cell.projectLocation.text = searchData[indexPath.row].workingType
        cell.customerName.text = searchData[indexPath.row].name
        cell.projectEditBtn.tag = indexPath.row
        cell.projectEditBtn.addTarget(self, action: #selector(editBtnTap(_:)), for: .touchUpInside)
       
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
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAdminProjVC") as? DetailAdminProjVC{
            VC.hidesBottomBarWhenPushed = true
            VC.taskId = searchData[indexPath.row].id
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @objc func editBtnTap(_ sender: UIButton){
        let tag = sender.tag
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddAdminProjVC") as? AddAdminProjVC{
            VC.hidesBottomBarWhenPushed = true
            VC.type = "Edit"
            VC.otherProj = searchData[tag].id
                 self.navigationController?.pushViewController(VC, animated: true)
             }
    }
    
}
//MARK: API Integartion
extension SearchVC{
    
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
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/get_project"
        print(param)
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
                           let loginResponse = try? JSONDecoder().decode(ProjectResponse.self, from: jsonData) {
                            self.searchData.removeAll()
//                            self.changeDateBtn.setTitle(loginResponse.filter, for: .normal)
//                            self.date_selection = loginResponse.filter
                            for i in 0..<loginResponse.projects.count{
                                self.searchData.append(search.init(workingType: loginResponse.projects[i].location , name: loginResponse.projects[i].customerName, taskTitle: loginResponse.projects[i].projectName, dateRange:"", startTime: loginResponse.projects[i].spendTime, id: loginResponse.projects[i].id, endTime: "", breakTime: "\(loginResponse.projects[i].cost)", servicelat: "", servicelong: "", type: "", timeCardType: 0, createBy: 0, taskName: "", hours: "",minutes: ""))
                            }
                            progressHUD.hide()
                            DispatchQueue.main.async {
                                self.searchTV.delegate = self
                                self.searchTV.dataSource = self
                                self.searchTV.reloadData()
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
                        self.searchData.removeAll()
                        self.searchTV.reloadData()
                        
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
                    }else if self.status == 201{
                        progressHUD.hide()
                        self.searchData.removeAll()
//                        self.changeDateBtn.setTitle( dict["filter"] as? String, for: .normal)
                        self.searchTV.reloadData()
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
                    }else{
                        progressHUD.hide()
                        self.searchData.removeAll()
                        self.searchTV.reloadData()
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
