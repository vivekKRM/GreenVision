//
//  ShowNotesAdminVC.swift
//  Cleansing
//
//  Created by uis on 29/12/23.
//

import UIKit
import Alamofire

class ShowNotesAdminVC: UIViewController {
    
    @IBOutlet weak var showNotesTV: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var addNotesBtn: UIButton!
    @IBOutlet weak var nodateLabel: UILabel!
    
    var status:Int = 0
    var taskID: Int = 0
    var selectedRow: Int = 0
    var projectType: Int = 0
    var calledFrom: String = ""
    var notesdetails = [showNotes]()
    var timecard_type:Int = 0
    var exist:[Bool] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "View Notes".localizeString(string: lang)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        firstCall()
    }
    
    @IBAction func addBtnTap(_ sender: UIButton) {
        if projectType == 2{
            _ = SweetAlert().showAlert("", subTitle:  "Approved time cards notes cannot be added".localizeString(string: lang), style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
        }else{
            // Handle the button tap action
            print("Floating button tapped!")
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNotesVC") as? AddNotesVC{
                VC.hidesBottomBarWhenPushed = true
                VC.calledType = calledFrom
                VC.timecard_type = timecard_type
                VC.task_id = taskID
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
    }
    
}

extension ShowNotesAdminVC {
    
    func firstCall()
    {
        addNotesBtn.setTitle("ADD NEW NOTES".localizeString(string: lang), for: .normal)
        nodateLabel.text = "No data found for notes of this task at this moment!".localizeString(string: lang)
        if calledFrom == "TimeCard"{
            floatingBtn()
            getNotes(id: taskID)
        }else if calledFrom == "AdminTask"{
            floatingBtn()
            getTaskAdmin(id: taskID)
        }
        addNotesBtn.roundedButton()
    }
    @objc func rightBarButtonTapped() {
        // Handle the button tap here
        print("Right bar button tapped")
        
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNotesVC") as? AddNotesVC{
            VC.hidesBottomBarWhenPushed = true
            VC.calledType = ""
            VC.timecard_type = timecard_type
            VC.task_id = taskID
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    //MARK: Add Floating Button
    func floatingBtn(){
        let floatingButton = UIButton(type: .system)
        floatingButton.frame = CGRect(x: UIScreen.main.bounds.width * 0.8, y: UIScreen.main.bounds.height * 0.65, width: 60, height: 60)
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
        if projectType == 2{
            _ = SweetAlert().showAlert("", subTitle:  "Approved time cards notes cannot be added".localizeString(string: lang), style: AlertStyle.warning,buttonTitle:"OK".localizeString(string: lang))
        }else{
            // Handle the button tap action
            print("Floating button tapped!")
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNotesVC") as? AddNotesVC{
                VC.hidesBottomBarWhenPushed = true
                VC.timecard_type = timecard_type
                VC.calledType = calledFrom
                VC.task_id = taskID
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
    }
}
//MARK:  TableView Delegate and DataSource
extension ShowNotesAdminVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesdetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "snCell", for: indexPath) as! ShowNotesTVC
        cell.notesDate.text =  notesdetails[indexPath.row].nsdate + " " + notesdetails[indexPath.row].nstime
        cell.notesTitle.text =  notesdetails[indexPath.row].ntitle
        getImageFromURL(imageView: cell.personImage, stringURL: notesdetails[indexPath.row].npimage)
        cell.personName.text  = notesdetails[indexPath.row].npname
        cell.viewBtn.setTitle("View".localizeString(string: lang), for: .normal)
        if notesdetails[indexPath.row].roleId == 2{
            cell.viewBtn.addTarget(self, action: #selector(viewBtnTap(_:)), for: .touchUpInside)
            cell.viewBtn.tag = indexPath.row
        }else{
            cell.viewBtn.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ShowNotesTVC {
            if exist.isEmpty || !exist[indexPath.row] {
                cell.collectionHeight.constant = 100.0
                cell.showNotesCV.dataSource = self
                cell.showNotesCV.delegate = self
                cell.showNotesCV.tag = indexPath.row
                selectedRow = indexPath.row
                cell.showNotesCV.reloadData()
            }else{
                cell.collectionHeight.constant = 0.0
            }
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if exist.isEmpty || !exist[indexPath.row] {
            return UITableView.automaticDimension
        } else {
           return 120
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if exist.isEmpty || !exist[indexPath.row] {
            return UITableView.automaticDimension
        } else {
           return 120
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if notesdetails[indexPath.row].roleId == 2{
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNotesVC") as? AddNotesVC{
                VC.hidesBottomBarWhenPushed = true
                VC.calledType = "Show"
                if  calledFrom == "TimeCard"{
                    VC.typee = "Times"
                }
                if  calledFrom == "AdminTask"{
                    VC.typee = "Timers"
                }
                VC.timecard_type = timecard_type
                VC.noteId = "\(notesdetails[indexPath.row].nid)"
                VC.task_id = taskID
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
        
        
    }
    
    @objc func viewBtnTap(_ sender: UIButton){
        let tag = sender.tag ?? 0
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNotesVC") as? AddNotesVC{
            VC.hidesBottomBarWhenPushed = true
            VC.calledType = "Show"
            if  calledFrom == "TimeCard"{
                VC.typee = "Times"
            }
            if  calledFrom == "AdminTask"{
                VC.typee = "Timers"
            }
            VC.task_id = taskID
            VC.noteId = "\(notesdetails[tag].nid)"
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
}

//MARK: Collection View Delegate and DataSource
extension ShowNotesAdminVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notesdetails[selectedRow].nImageId.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "anCell", for: indexPath) as! AddNotesCVC
        getImageFromURL(imageView: cell.notesImageView, stringURL: notesdetails[selectedRow].url  + (notesdetails[selectedRow].nImageId[indexPath.row].images ?? ""))
        cell.deleteBtn.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.scrollDirection = .horizontal
        let numberOfItemsperRow:CGFloat = 4
        let itemWidth = (collectionView.bounds.width - layout.minimumLineSpacing) / numberOfItemsperRow
        return CGSize(width: itemWidth + 30, height: itemWidth + 30  )//20.0
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC{
            VC.hidesBottomBarWhenPushed = true
            VC.image = notesdetails[selectedRow].url  + (notesdetails[selectedRow].nImageId[indexPath.row].images ?? "")
            VC.modalPresentationStyle = .formSheet
            self.present(VC, animated: true)
        }
        
    }
}
//MARK: API Integration
extension ShowNotesAdminVC {
    
    
    //MARK:  Get Notes TimeCard API
    func getNotes(id: Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/timecard_detail"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["timecard_id": "\(id)"]
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
                           let loginResponse = try? JSONDecoder().decode(TimeCardDetailsInfo.self, from: jsonData) {
                            self.notesdetails.removeAll()
                            self.exist.removeAll()
                            self.timecard_type = loginResponse.timeCards[0].timecard_type
                            for i in 0..<loginResponse.timeCards[0].notes.count{
                                self.notesdetails.append(showNotes.init(nsdate: loginResponse.timeCards[0].notes[i].date ?? "", nstime: loginResponse.timeCards[0].notes[i].time ?? "", ntitle: loginResponse.timeCards[0].notes[i].note_title ?? "", nid: loginResponse.timeCards[0].notes[i].id ?? 0, nImageId: loginResponse.timeCards[0].notes[i].image, url: loginResponse.timeCards[0].notes[i].url ?? "", npimage: loginResponse.timeCards[0].notes[i].uploaded_by_profile ?? "", npname: loginResponse.timeCards[0].notes[i].uploaded_by ?? "", roleId: loginResponse.timeCards[0].notes[i].role ?? 0))
                                self.projectType = loginResponse.timeCards[0].approve
                                
                                let note = loginResponse.timeCards[0].notes[i]
                                var isImageEmpty = true
                                for _ in 0..<note.image.count {
                                    if !note.image.isEmpty {
                                        isImageEmpty = false
                                        break
                                    }
                                }
                                self.exist.append(isImageEmpty)
                            }
                            progressHUD.hide()
                            if self.notesdetails.count < 1{
                                self.topView.isHidden = false
                            }else{
                                self.topView.isHidden = true
                            }
                            DispatchQueue.main.async {
                                self.showNotesTV.delegate = self
                                self.showNotesTV.dataSource = self
                                self.showNotesTV.reloadData()
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
    
    
    //MARK: Get Task API for Admin
    func getTaskAdmin(id: Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/get_task_detail"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["task_id" : id]
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
                           let loginResponse = try? JSONDecoder().decode(DetailAdminTasks.self, from: jsonData) {
                            self.notesdetails.removeAll()
                            self.exist.removeAll()
                            
                            for i in 0..<loginResponse.task.notes.count{
                                self.notesdetails.append(showNotes.init(nsdate: loginResponse.task.notes[i].date ?? "", nstime: loginResponse.task.notes[i].time ?? "", ntitle: loginResponse.task.notes[i].note_title ?? "", nid: loginResponse.task.notes[i].id ?? 0, nImageId: loginResponse.task.notes[i].image, url: loginResponse.task.notes[i].url ?? "", npimage: loginResponse.task.notes[i].uploaded_by_profile ?? "", npname: loginResponse.task.notes[i].uploaded_by ?? "", roleId: loginResponse.task.notes[i].role ?? 0))
                                
                                
                                let note = loginResponse.task.notes[i]
                                var isImageEmpty = true
                                for _ in 0..<note.image.count {
                                    if !note.image.isEmpty {
                                        isImageEmpty = false
                                        break
                                    }
                                }
                                self.exist.append(isImageEmpty)
                            }
                            progressHUD.hide()
                            if self.notesdetails.count < 1{
                                self.topView.isHidden = false
                            }else{
                                self.topView.isHidden = true
                            }
                            DispatchQueue.main.async {
                                self.showNotesTV.delegate = self
                                self.showNotesTV.dataSource = self
                                self.showNotesTV.reloadData()
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

