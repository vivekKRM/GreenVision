//
//  ShowAdminTaskVC.swift
//  Cleansing
//
//  Created by UIS on 08/11/23.
//

import UIKit
import Fastis
import Alamofire
class ShowAdminTaskVC: UIViewController {
    
    
    @IBOutlet weak var showAdminTaskTV: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var dateBtn: UIButton!
    
    var status:Int = 0
    var searchData = [search]()
    var selectedRow: Int = 0
    var buttonText: String = "All".localizeString(string: lang)
    var dateText: String = "Select Date".localizeString(string: lang)
    var tasks: [AdminTask] = []
    var filteredTasks: [AdminTask] = [] // Filtered results
    var isSearching: Bool {
        return !searchBar.text!.isEmpty
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func filterBtnTap(_ sender: UIButton) {
        showAlert()
    }
    
    
    @IBAction func dateBtnTap(_ sender: UIButton) {
        chooseDate()
    }
    
    
    
}
//MARK: First Call
extension ShowAdminTaskVC {
    
    func firstCall()
    {
        self.title = "Tasks".localizeString(string: lang)
        self.topLabel.text = "Tasks".localizeString(string: lang)
        dateBtn.setTitle("Select Date".localizeString(string: lang), for: .normal)
        buttonText = "All Task".localizeString(string: lang)
        filterBtn.setTitle(buttonText, for: .normal)
        self.navigationController?.isNavigationBarHidden = true
        filterBtn.layer.masksToBounds = true
        dateBtn.layer.masksToBounds = true
        filterBtn.layer.cornerRadius = 5
        dateBtn.layer.cornerRadius = 5
        self.showAdminTaskTV.keyboardDismissMode = .onDrag
        UserDefaults.standard.set("", forKey: "dfilter")
        UserDefaults.standard.setValue( "", forKey: "workerT")
        UserDefaults.standard.setValue( "all", forKey: "statusT")
        UserDefaults.standard.setValue("", forKey: "workerV")
        UserDefaults.standard.setValue("", forKey: "statusV")
        UserDefaults.standard.setValue("", forKey: "approverV")
        UserDefaults.standard.setValue("", forKey: "approverT")
        floatingBtn()
        getAdminTask(task_status: "")
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
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateTaskAdminVC") as? CreateTaskAdminVC{
            VC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    
    
    
    
    func showAlert() {
        // Create an alert controller
        let alertController = UIAlertController(title: "Filter Task".localizeString(string: lang), message: "", preferredStyle: .alert)
        
        // Create three buttons with different actions
        let button1 = UIAlertAction(title: "All Tasks".localizeString(string: lang), style: .default) { (action) in
            // Code to be executed when Button 1 is tapped
            print("Button 1 tapped")
            self.buttonText = "All Task".localizeString(string: lang)
            self.filterBtn.setTitle(self.buttonText, for: .normal)
            self.getAdminTask(task_status: "")
        }
        
        let button2 = UIAlertAction(title: "Complete".localizeString(string: lang), style: .default) { (action) in
            // Code to be executed when Button 2 is tapped
            print("Button 2 tapped")
            self.buttonText = "Complete".localizeString(string: lang)
            self.filterBtn.setTitle(self.buttonText, for: .normal)
            self.getAdminTask(task_status: "3")
        }
        
        let button3 = UIAlertAction(title: "Incomplete".localizeString(string: lang), style: .default) { (action) in
            // Code to be executed when Button 3 is tapped
            print("Button 3 tapped")
            self.buttonText = "Incomplete".localizeString(string: lang)
            self.filterBtn.setTitle(self.buttonText, for: .normal)
            self.getAdminTask(task_status: "2")
        }
        
        let dismissAction = UIAlertAction(title: "Dismiss".localizeString(string: lang), style: .cancel, handler: nil)
        // Set the text color of the buttons to black
        alertController.view.tintColor = .black
        dismissAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        // Add the buttons to the alert controller
        alertController.addAction(button1)
        alertController.addAction(button2)
        alertController.addAction(button3)
        alertController.addAction(dismissAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: Choose Date
    func chooseDate() {
        let fastisController = FastisController(mode: .range)
        fastisController.title = "Choose range".localizeString(string: lang)
        //        fastisController.maximumDate = Date()
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
        dateFormatter.dateFormat = "d MMM"//"E d MMM"
        let tostring = dateFormatter.string(from: toDate)
        print(tostring)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "d MMM"//"E d MMM"
        let fromstring = dateFormatter1.string(from: fromDate)
        print(fromstring)
        let finals = fromstring + " - " + tostring
        dateText = finals
        self.dateBtn.setTitle(finals, for: .normal)
        getAdminTask(task_status: "")
        
    }
}
//MARK: TableView Delegate
extension ShowAdminTaskVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredTasks.count
        } else {
            return tasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "staCell", for: indexPath) as! ShowTaskAdminTVC
        //        let task = tasks[indexPath.row]
        //        cell.taskDate.text = task.startDateTime + " - " + task.dueDateTime
        //        cell.taskName.text = task.title
        //        cell.taskAddress.text = task.location
        //        cell.checkListCount.text =  "\(task.checkedChecklist)"   + "/" +  "\(task.totalChecklist)"
        //        cell.notesCount.text = "\(task.totalNotes)"
        //        cell.editBtn.tag = indexPath.row
        //        cell.taskStatus.text = task.status
        //        cell.editBtn.addTarget(self, action: #selector(editBtnTap(_:)), for: .touchUpInside)
        //        return cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "staCell", for: indexPath) as! ShowTaskAdminTVC
        let task: AdminTask
        if isSearching {
            task = filteredTasks[indexPath.row]
        } else {
            task = tasks[indexPath.row]
        }
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(editBtnTap(_:)), for: .touchUpInside)
        configureCell(cell, with: task)
        return cell
    }
    
    func configureCell(_ cell: ShowTaskAdminTVC, with task: AdminTask) {
        // Configure cell with task details
        cell.taskDate.text = task.startDateTime + " - " + task.dueDateTime
        cell.taskName.text = task.title
        cell.taskAddress.text = task.location
        cell.checkListCount.text =  "\(task.checkedChecklist)"   + "/" +  "\(task.totalChecklist)"
        cell.notesCount.text = "\(task.totalNotes)"
        cell.taskStatus.text = task.status
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ShowTaskAdminTVC {
            cell.shortNameCV.dataSource = self
            cell.shortNameCV.delegate = self
            cell.shortNameCV.tag = indexPath.row
            selectedRow = indexPath.row
            cell.shortNameCV.reloadData()
        }
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
        let selectedTask = isSearching ? filteredTasks[indexPath.row] : tasks[indexPath.row]
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowAdminTaskDetailsVC") as? ShowAdminTaskDetailsVC{
            VC.hidesBottomBarWhenPushed = true
            VC.taskId = selectedTask.taskId
            self.navigationController?.pushViewController(VC, animated: true)
        }
        
    }
    
    @objc func editBtnTap(_ sender: UIButton){
        let tag = sender.tag
        let task = tasks[tag]
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateTaskAdminVC") as? CreateTaskAdminVC{
            VC.hidesBottomBarWhenPushed = true
            VC.taskId = task.taskId
            VC.called = "Show"
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
}


//MARK: Collection View Delegate and DataSource
extension ShowAdminTaskVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  tasks[selectedRow].shortName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "snCell", for: indexPath) as! ShowTaskAdminCVC
        let short = tasks[selectedRow].shortName[indexPath.row]
        
        cell.topView.layer.cornerRadius = 15
        cell.topView.layer.masksToBounds = true
        cell.topView.backgroundColor = UIColor.init(hexString: short.background_color)
        cell.topName.text = short.short_name
        cell.topName.textColor = UIColor.init(hexString: short.text_color)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.scrollDirection = .horizontal
        let numberOfItemsperRow:CGFloat = 9
        let itemWidth = (collectionView.bounds.width - layout.minimumLineSpacing) / numberOfItemsperRow
        return CGSize(width: itemWidth, height: itemWidth)//20.0
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

//MARK: API Integartion
extension ShowAdminTaskVC{
    
    //MARK: Get Task API
    func getAdminTask(task_status: String)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        if dateText == "Select Date".localizeString(string: lang){
            dateText = ""
        }
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/get_task"
        param = ["date_filter": dateText, "task_status": task_status]//All "", Incomplete "2" other "3"
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
                            self.dateText = loginResponse.filter
                            self.dateBtn.setTitle(loginResponse.filter, for: .normal)
                            progressHUD.hide()
                            DispatchQueue.main.async {
                                self.showAdminTaskTV.delegate = self
                                self.showAdminTaskTV.dataSource = self
                                self.showAdminTaskTV.reloadData()
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
                        self.filteredTasks.removeAll()
                        self.showAdminTaskTV.reloadData()
                        
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.error,buttonTitle:"OK".localizeString(string: lang))
                    }else if self.status == 201{
                        progressHUD.hide()
                        self.searchData.removeAll()
                        self.filteredTasks.removeAll()
                        //                        self.changeDateBtn.setTitle( dict["filter"] as? String, for: .normal)
                        self.showAdminTaskTV.reloadData()
                        _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
                    }else{
                        progressHUD.hide()
                        self.searchData.removeAll()
                        self.filteredTasks.removeAll()
                        self.showAdminTaskTV.reloadData()
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
extension ShowAdminTaskVC: UISearchBarDelegate{
    
    func filterTasks(for searchText: String) {
        if searchText.isEmpty {
            filteredTasks = tasks
        } else {
            filteredTasks = tasks.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTasks(for: searchText)
        showAdminTaskTV.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.endEditing(true)
    }
}
