//
//  ShowAdminTaskDetailsVC.swift
//  Cleansing
//
//  Created by UIS on 13/11/23.
//

import UIKit
import Alamofire
class ShowAdminTaskDetailsVC: UIViewController {
    
    @IBOutlet weak var showTaskTV: UITableView!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var selectDateTime: UITextField!
    @IBOutlet weak var selectDueDate: UITextField!
    @IBOutlet weak var selectProject: UILabel!
    @IBOutlet weak var selectWatcher: UITextField!
    @IBOutlet weak var addNotes: UIButton!
    @IBOutlet weak var EditTask: UIButton!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var selectMember: UITextView!
    @IBOutlet weak var navigateBtn: UIButton!
    @IBOutlet weak var checkListView: UIView!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    @IBOutlet weak var sixLabel: UILabel!
    @IBOutlet weak var sevenLabel: UILabel!
    
    var status: Int = 0
    var taskId: Int = 0
    var endLat: Double = 0.0
    var endLng: Double = 0.0
    var checkListData = [createCheckList]()
    var completeStatus: Int = 0
    var selectedRow: Int = 0
    var notesdetails = [showNotes]()
    var exist:[Bool] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }
    
    
    @IBAction func editTaskBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateTaskAdminVC") as? CreateTaskAdminVC{
            VC.hidesBottomBarWhenPushed = true
            VC.taskId = taskId
            VC.called = "Show"
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func addNotesBtnTap(_ sender: UIButton) {
        //add notes
//        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowNotesAdminVC") as? ShowNotesAdminVC{
//            VC.hidesBottomBarWhenPushed = true
//            VC.taskID = taskId
//            VC.calledFrom = "AdminTask"
//            self.navigationController?.pushViewController(VC, animated: true)
//        }
        
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNotesVC") as? AddNotesVC{
            VC.hidesBottomBarWhenPushed = true
            VC.calledType = ""
            VC.task_id = taskId
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func statusBtnTap(_ sender: UIButton) {
        if completeStatus != 3{
            let refreshAlert = UIAlertController(title: "Complete Task".localizeString(string: lang), message: "Do you want to complete this task ?".localizeString(string: lang), preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel".localizeString(string: lang), style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
                refreshAlert .dismiss(animated: true, completion: nil)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Complete".localizeString(string: lang), style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                self.statusBtn.setTitleColor(UIColor.white, for: .normal)
                self.statusBtn.backgroundColor = UIColor.init(hexString: "528E4A")
                if let image = UIImage(systemName: "checkmark.circle.fill") {
                    let tintedImage = image.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
                    self.statusBtn.setImage(tintedImage, for: .normal)
                }
                self.taskComplete(id: self.taskId)
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func navigateBtnTap(_ sender: UIButton) {
        mapBtnTap()
    }
    
  
    
}

//MARK: First Call
extension ShowAdminTaskDetailsVC {
    
    func firstCall()
    {
        firstLabel.text = "STATUS".localizeString(string: lang)
        secondLabel.text = "START DATE".localizeString(string: lang)
        thirdLabel.text = "DUE DATE".localizeString(string: lang)
        fourthLabel.text = "PROJECT".localizeString(string: lang)
        navigateBtn.setTitle("NAVIGATE".localizeString(string: lang), for: .normal)
        fifthLabel.text = "ASSIGNS".localizeString(string: lang)
        sixLabel.text = "WATCHERS".localizeString(string: lang)
//        sevenLabel.text = "Check Lists".localizeString(string: lang)
        EditTask.setTitle("Edit Task".localizeString(string: lang), for: .normal)
        addNotes.setTitle("Notes".localizeString(string: lang), for: .normal)
        statusBtn.setTitle("COMPLETE".localizeString(string: lang), for: .normal)
        getTask()
        self.title = "View Task".localizeString(string: lang)
        EditTask.roundedButton()
        addNotes.roundedButton()
        selectDateTime.inputView = UIView()
        selectDateTime.inputAccessoryView = UIView()
        selectDateTime.tintColor = .white
        selectDueDate.inputView = UIView()
        selectDueDate.inputAccessoryView = UIView()
        selectDueDate.tintColor = .white
        selectWatcher.inputView = UIView()
        selectMember.textColor = .lightGray
//        selectMember.layer.cornerRadius = 5
//        selectMember.layer.masksToBounds = true
//        selectMember.layer.borderColor = UIColor.black.cgColor
//        selectMember.layer.borderWidth = 0.5
        selectWatcher.inputAccessoryView = UIView()
        selectWatcher.tintColor = .white
        selectMember.inputView = UIView()
        selectMember.inputAccessoryView = UIView()
        selectMember.tintColor = .white
        navigateBtn.layer.masksToBounds = true
        navigateBtn.layer.cornerRadius = 5
        navigateBtn.layer.borderWidth = 1
        navigateBtn.layer.borderColor = UIColor.lightGray.cgColor
        
        statusBtn.layer.cornerRadius = 5
        statusBtn.layer.masksToBounds = true
        statusBtn.layer.borderWidth = 0.5
        statusBtn.layer.borderColor = UIColor.lightGray.cgColor
        createBar()

    }
    
    //MARK: Create UINavigationBar Button
    func createBar(){
        if let deleteImage = UIImage(named: "trash-bin") {
            let originalDeleteImage = deleteImage.withRenderingMode(.alwaysOriginal)
            let deleteButton = UIBarButtonItem(
                image: originalDeleteImage,
                style: .plain,
                target: self,
                action: #selector(deleteButtonTapped)
            )
            navigationItem.rightBarButtonItem = deleteButton
        }
    }
    
    @objc func deleteButtonTapped() {
        let refreshAlert = UIAlertController(title: "Delete Task".localizeString(string: lang), message: "Deleting the task will remove all your task data, do you want to delete ?".localizeString(string: lang), preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel".localizeString(string: lang), style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            refreshAlert .dismiss(animated: true, completion: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Delete".localizeString(string: lang), style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.deleteTasks(id: self.taskId)
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
   
    
    func mapBtnTap() {
        let latitude = endLat // Replace with your desired latitude
        let longitude = endLng // Replace with your desired longitude
        
        if let url = URL(string: "comgooglemaps://?q=\(latitude),\(longitude)&directionsmode=driving") {
            if UIApplication.shared.canOpenURL(url) {
                // Open Google Maps app if available
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Open Google Maps in Safari if the app is not installed
                let webUrl = URL(string: "https://maps.google.com/maps?q=\(latitude),\(longitude)&directionsmode=driving")
                UIApplication.shared.open(webUrl!, options: [:], completionHandler: nil)
            }
        }
        
        //        showRouteOnAppleMaps(startLat: 28.5355, startLong: 77.3910, endLat: 28.4089, endLong: 77.3178)
        
    }
}

//MARK: TableView Delegate
extension ShowAdminTaskDetailsVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return checkListData.count
        }else{
            return notesdetails.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cclCell", for: indexPath) as! CreateCheckListTVC
            cell.topLabel.text = checkListData[indexPath.row].title
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTap(_:)), for: .touchUpInside)
            cell.topButton.tag = indexPath.row
            cell.topButton.addTarget(self, action: #selector(selectBtnTap(_:)), for: .touchUpInside)
            if checkListData[indexPath.row].status == 1{
                cell.topButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            }else{
                cell.topButton.setImage(UIImage(systemName: "square"), for: .normal)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "snCell", for: indexPath) as! ShowNotesTVC
            cell.notesDate.text =  notesdetails[indexPath.row].nsdate + " " + notesdetails[indexPath.row].nstime
            cell.notesTitle.text =  notesdetails[indexPath.row].ntitle
            getImageFromURL(imageView: cell.personImage, stringURL: notesdetails[indexPath.row].npimage)
            cell.personName.text  = notesdetails[indexPath.row].npname
            cell.viewBtn.setTitle("Edit".localizeString(string: lang), for: .normal)
            if notesdetails[indexPath.row].roleId == 2 {
                cell.viewBtn.addTarget(self, action: #selector(viewBtnTap(_:)), for: .touchUpInside)
                cell.viewBtn.tag = indexPath.row
            }else{
                cell.viewBtn.isHidden = true
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if indexPath.section == 1{
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
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return UITableView.automaticDimension
        }else{
            if exist.isEmpty || !exist[indexPath.row] {
                return UITableView.automaticDimension
            } else {
               return 120
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return UITableView.automaticDimension
        }else{
            if exist.isEmpty || !exist[indexPath.row] {
                return UITableView.automaticDimension
            } else {
               return 120
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.section == 1{
            if notesdetails[indexPath.row].roleId == 2{
                if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNotesVC") as? AddNotesVC{
                    VC.hidesBottomBarWhenPushed = true
                    VC.calledType = "Show"
                    VC.typee = "Timers"
                    VC.noteId = "\(notesdetails[indexPath.row].nid)"
                    VC.task_id = taskId
                    self.navigationController?.pushViewController(VC, animated: true)
                }
            }
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
        viewHeader.backgroundColor = UIColor.init(hexString: "f5f5f5")
        
        let imag11 = UIImageView(frame: CGRect(x: 15, y: 10, width: 20, height: 20))
        imag11.image = UIImage(systemName: "checklist.checked")
        imag11.tintColor = UIColor.init(hexString: "004080")
        viewHeader.addSubview(imag11)
        
        if section == 0{
            let label1 = UILabel(frame: CGRect(x: 42, y: 10, width: 150, height: 24))
            label1.text = "Check Lists".localizeString(string: lang)
            label1.textColor = UIColor.init(hexString: "004080")
            label1.font = UIFont(name: "Poppins-Medium", size: 16)
            viewHeader.addSubview(label1)
        }else{
            let label1 = UILabel(frame: CGRect(x: 42, y: 10, width: 200, height: 24))
            label1.text = "Notes".localizeString(string: lang)
            label1.textColor =  UIColor.init(hexString: "004080")
            label1.font = UIFont(name: "Poppins-Medium", size: 16)
            viewHeader.addSubview(label1)
        }
        return viewHeader
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && checkListData.count > 0{
            return 40
        }else if section == 1 && notesdetails.count > 0{
            return 40
        }else{
            return 0
        }
    }
    
    @objc func deleteBtnTap(_ sender: UIButton){
        let tag = sender.tag
        let refreshAlert = UIAlertController(title: "Delete Checklist".localizeString(string: lang), message: "Do you want to delete this task checklist ?".localizeString(string: lang), preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel".localizeString(string: lang), style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            refreshAlert .dismiss(animated: true, completion: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Delete".localizeString(string: lang), style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.deleteCheckList(id: self.checkListData[tag].id, tag: tag)
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    @objc func selectBtnTap(_ sender: UIButton){
        let tag = sender.tag
        submitCheckList(id: checkListData[tag].id, tag: tag)
    }
    
    @objc func viewBtnTap(_ sender: UIButton){
        let tag = sender.tag ?? 0
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNotesVC") as? AddNotesVC{
            VC.hidesBottomBarWhenPushed = true
            VC.calledType = "Show"
            VC.typee = "Timers"
            VC.task_id = taskId
            VC.noteId = "\(notesdetails[tag].nid)"
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
}

//MARK: Collection View Delegate and DataSource
extension ShowAdminTaskDetailsVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource
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
extension ShowAdminTaskDetailsVC{
    
    //MARK: Get Task API
    func getTask()
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
        param = ["task_id" : taskId]
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
                            self.checkListData.removeAll()
                            self.taskTitle.text = loginResponse.task.title
                            self.selectMember.text = loginResponse.task.memberName
                            self.selectMember.textColor = .black
                            self.selectDateTime.text = loginResponse.task.startDateTime
                            self.selectDueDate.text = loginResponse.task.dueDateTime
                            self.selectProject.text = loginResponse.task.projectName + " - " + loginResponse.task.location
                            self.selectWatcher.text = loginResponse.task.managerName
                            
                            if let doubleValue = Double(loginResponse.task.latitude) {
                                // Use doubleValue as a Double
                                print(doubleValue)
                                self.endLat = doubleValue
                            } else {
                                // Handle the case where the conversion fails
                                print("Invalid double value")
                            }
                            
                            if let doubleValue1 = Double(loginResponse.task.longitude) {
                                // Use doubleValue as a Double
                                print(doubleValue1)
                                self.endLng = doubleValue1
                            } else {
                                // Handle the case where the conversion fails
                                print("Invalid double value")
                            }
                            self.completeStatus = loginResponse.task.status
                            if loginResponse.task.status == 3 {
                                if let image = UIImage(systemName: "checkmark.circle.fill") {
                                    let tintedImage = image.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
                                    self.statusBtn.setImage(tintedImage, for: .normal)
                                }
                                self.statusBtn.setTitleColor(UIColor.white, for: .normal)
                                self.statusBtn.backgroundColor = UIColor.init(hexString: "528E4A")
                                self.EditTask.isHidden = true
                                self.addNotes.isHidden = true
                                self.statusBtn.setTitle("TASK COMPLETED".localizeString(string: lang), for: .normal)
                            }else{
                                if let image = UIImage(systemName: "checkmark.circle.fill") {
                                    let tintedImage = image.withTintColor(UIColor.lightGray, renderingMode: .alwaysOriginal)
                                    self.statusBtn.setImage(tintedImage, for: .normal)
                                }
                            }
                            
                            if loginResponse.task.checklist.count < 1{
//                                self.checkListView.isHidden = true
                            }
                            for i in 0..<loginResponse.task.checklist.count{
                                self.checkListData.append(createCheckList.init(id: loginResponse.task.checklist[i].id, title: loginResponse.task.checklist[i].title, status: loginResponse.task.checklist[i].status))
                            }
                           
                            
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
//                                self.topView.isHidden = false
                            }else{
//                                self.topView.isHidden = true
                            }
                            DispatchQueue.main.async {
                                self.showTaskTV.delegate = self
                                self.showTaskTV.dataSource = self
                                self.showTaskTV.reloadData()
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
    
    func submitCheckList(id: Int, tag: Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/change_status_checklist"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["checkList_id": id]
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
                            
                            self.getTask()
                            //                                print(self.checkListData[tag])
                            //                                self.checkListData.insert(createCheckList.init(id:  self.checkListData[tag].id, title:  self.checkListData[tag].title, status: 1), at: tag)
                            //                                print(self.checkListData[tag])
                            //                                self.checkListData.remove(at: tag + 1)
                            //                                self.createTaskTV.reloadData()
                            
                            
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
    
    //MARK: Delete Tasks
    func deleteTasks(id : Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let url = "\(ApiLink.HOST_URL)/delete_task"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        
        print("Access Token: \(accessToken)")
        var param: Parameters = ["":""]
        param = ["task_id": id]
        print(param)
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
                            _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.success,buttonTitle:"OK".localizeString(string: lang)){ (isOtherButton) -> Void in
                                if isOtherButton == true {
                                    self.navigationController?.popViewController(animated: true)
                                }
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
    
    //MARK: Delete Checklist
    func deleteCheckList(id: Int, tag: Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/delete_checklist"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["checklist_id": id]
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
                            self.getTask()
                            
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
    
    //MARK: Task Completion
    func taskComplete(id: Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK".localizeString(string: lang))
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/task_completion"
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
                           let loginResponse = try? JSONDecoder().decode(DefaultInfo.self, from: jsonData) {
                            
                            progressHUD.hide()
                            self.completeStatus = 3
                            
                            if let image = UIImage(systemName: "checkmark.circle.fill") {
                                let tintedImage = image.withTintColor(UIColor.systemGreen, renderingMode: .alwaysOriginal)
                                self.statusBtn.setImage(tintedImage, for: .normal)
                            }
                           
                            _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.success,buttonTitle:"OK".localizeString(string: lang))
                            
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

//MARK: TextField Delegate

extension ShowAdminTaskDetailsVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Disable paste, replace, etc. by always returning false
        textField.inputAssistantItem.leadingBarButtonGroups = []
        textField.inputAssistantItem.trailingBarButtonGroups = []
        return false
    }
}


