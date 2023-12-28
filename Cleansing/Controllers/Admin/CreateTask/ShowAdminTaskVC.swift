//
//  ShowAdminTaskVC.swift
//  Cleansing
//
//  Created by UIS on 08/11/23.
//

import UIKit
import Alamofire
class ShowAdminTaskVC: UIViewController {

    
    @IBOutlet weak var showAdminTaskTV: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let button = UIButton(type: .custom)
    var status:Int = 0
    var searchData = [search]()
    var buttonText: String = "All"
    var tasks: [AdminTask] = []
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    
    

    
    
}
//MARK: First Call
extension ShowAdminTaskVC {
    
    func firstCall()
    {
        self.title = "Tasks"
        createBar()
        floatingBtn()
        getAdminTask(task_status: "")
    }
    
    //MARK: Create Navigation Bar
    func createBar()
    {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 44))

                // Create a button with an image and text
                button.frame = CGRect(x: 0, y: 0, width: 120, height: 44)
                button.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
                button.setTitle(buttonText, for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10) // Adjust image/text spacing
                button.addTarget(self, action: #selector(showAlert(_:)), for: .touchUpInside)
                
                // Add the button to the custom view
                customView.addSubview(button)

                // Create a UIBarButtonItem with the custom view
                let customBarButtonItem = UIBarButtonItem(customView: customView)

                // Set the left bar button item of the navigation bar
                navigationItem.leftBarButtonItem = customBarButtonItem
    }
    
    //MARK: Add Floating Button
    func floatingBtn(){
        let floatingButton = UIButton(type: .system)
        floatingButton.frame = CGRect(x: UIScreen.main.bounds.width * 0.8, y: UIScreen.main.bounds.height * 0.8, width: 60, height: 60)
        floatingButton.backgroundColor = UIColor.init(hexString: "004080")
        floatingButton.layer.cornerRadius = 30 // Half of the width
        floatingButton.setTitle("+", for: .normal)
        floatingButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        floatingButton.setTitleColor(UIColor.white, for: .normal)
        
        // Add a tap action to the button
        floatingButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        
        // Add the floating button to the view
        view.addSubview(floatingButton)
    }
    
    @objc func floatingButtonTapped() {
        // Handle the button tap action
        print("Floating button tapped!")
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateTaskAdminVC") as? CreateTaskAdminVC{
                 self.navigationController?.pushViewController(VC, animated: true)
             }
    }
    
    
    @objc func showAlert(_ sender: UIButton) {
           // Create an alert controller
           let alertController = UIAlertController(title: "Filter Task", message: "", preferredStyle: .alert)
           
           // Create three buttons with different actions
           let button1 = UIAlertAction(title: "All", style: .default) { (action) in
               // Code to be executed when Button 1 is tapped
               print("Button 1 tapped")
               self.buttonText = "All"
               self.button.setTitle( self.buttonText, for: .normal)
               self.getAdminTask(task_status: "")
           }
           
           let button2 = UIAlertAction(title: "Complete", style: .default) { (action) in
               // Code to be executed when Button 2 is tapped
               print("Button 2 tapped")
               self.buttonText = "Complete"
               self.button.setTitle( self.buttonText, for: .normal)
               self.getAdminTask(task_status: "3")
           }
           
           let button3 = UIAlertAction(title: "In-Complete", style: .default) { (action) in
               // Code to be executed when Button 3 is tapped
               print("Button 3 tapped")
               self.buttonText = "In-Complete"
               self.button.setTitle( self.buttonText, for: .normal)
               self.getAdminTask(task_status: "2")
           }
           
           // Add the buttons to the alert controller
           alertController.addAction(button1)
           alertController.addAction(button2)
           alertController.addAction(button3)
           
           // Present the alert controller
           present(alertController, animated: true, completion: nil)
       }
   }
//MARK: TableView Delegate
extension ShowAdminTaskVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "staCell", for: indexPath) as! ShowTaskAdminTVC
        let task = tasks[indexPath.row]
        cell.taskDate.text = task.startDateTime + " - " + task.dueDateTime
        cell.taskName.text = task.title
        cell.taskAddress.text = task.location
        cell.checkListCount.text =  "\(task.checkedChecklist)"   + "/" +  "\(task.totalChecklist)"
        cell.notesCount.text = "\(task.totalNotes)"
        cell.editBtn.tag = indexPath.row
        cell.taskStatus.text = task.status
        cell.editBtn.addTarget(self, action: #selector(editBtnTap(_:)), for: .touchUpInside)
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
        let task = tasks[indexPath.row]
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowAdminTaskDetailsVC") as? ShowAdminTaskDetailsVC{
            VC.taskId = task.taskId
            self.navigationController?.pushViewController(VC, animated: true)
             }
        
    }
    
    @objc func editBtnTap(_ sender: UIButton){
        let tag = sender.tag
        let task = tasks[tag]
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateTaskAdminVC") as? CreateTaskAdminVC{
            VC.taskId = task.taskId
            VC.called = "Show"
            self.navigationController?.pushViewController(VC, animated: true)
             }
    }
    
}
//MARK: API Integartion
extension ShowAdminTaskVC{
    
    //MARK: Get Task API
    func getAdminTask(task_status: String)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/get_task"
        param = ["date_filter": "", "task_status": task_status]//All "", Incomplete "2" other "3"
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
                        self.tasks.removeAll()
                        if let jsonData = try? JSONSerialization.data(withJSONObject: value),
                           let loginResponse = try? JSONDecoder().decode(AdminTaskResponse.self, from: jsonData) {
                            self.tasks = loginResponse.data
                            
                            progressHUD.hide()
                            DispatchQueue.main.async {
                                self.showAdminTaskTV.delegate = self
                                self.showAdminTaskTV.dataSource = self
                                self.showAdminTaskTV.reloadData()
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
                        self.searchData.removeAll()
                        self.showAdminTaskTV.reloadData()
                        
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK")
                    }else if self.status == 201{
                        progressHUD.hide()
                        self.searchData.removeAll()
//                        self.changeDateBtn.setTitle( dict["filter"] as? String, for: .normal)
                        self.showAdminTaskTV.reloadData()
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.warning,buttonTitle:"OK")
                    }else{
                        progressHUD.hide()
                        self.searchData.removeAll()
                        self.showAdminTaskTV.reloadData()
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
