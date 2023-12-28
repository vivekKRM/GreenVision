//
//  AddNotesVC.swift
//  Cleansing
//
//  Created by United It Services on 04/09/23.
//

import UIKit
import Photos
import Alamofire
class AddNotesVC: UIViewController {
    
    @IBOutlet weak var notesTitle: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var addNotesTV: UITableView!
    @IBOutlet weak var addNotesCV: UICollectionView!
    @IBOutlet weak var addNotesBtn: UIButton!
    
    var docsName: String = ""
    var task_id: Int = 0
    var noteId: String = ""
    var imagesUrl:[String] = []
    var imageselected: UIImage!
    var calledType:String = ""
    var typee:String = ""
    var textChnage: Bool = false
    var count = 0
    var status: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Notes"
        firstCall()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //show notes API
        if calledType == "Show"{
            showNotes(note_id: noteId)
        }else if calledType == "TimeCard"{
//            getTimeCard(id: task_id)
        }
    }
    
    
    @IBAction func addNotesBtnTap(_ sender: UIButton) {
        self.view.endEditing(true)
        if imageselected == nil && textChnage{
            if notesTitle.text ?? "" != ""{
                addNotesShow(task_id: task_id, note_title: notesTitle.text ?? "", notes: descriptionTV.text ?? "", note_id: noteId)
            }
        }
        //self.navigationController?.popViewController(animated: true)
        if calledType == "TimeCard"{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    
    @IBAction func addImageBtnTap(_ sender: UIButton) {
        if checkAll(){
            addOption()
        }
    }
    
    
}
extension AddNotesVC{
    func firstCall()
    {
        if calledType == "" {
            addNotesBtn.isHidden = false
        }else if  calledType == "TimeCard"{
            addNotesBtn.isHidden = false
            getTimeCard(id: task_id)
        }else if  calledType == "AdminTask"{
            addNotesBtn.isHidden = false
           
        }else{
            if typee == "Times"{
                 getTimeCard(id: task_id)
            }
            addNotesBtn.isHidden = false//true on 8 Nov
            addNotesBtn.setTitle("Save Notes", for: .normal)//on 8 Nov
        }
       
        addBlackBorder(to: notesTitle)
        descriptionTV.textColor = UIColor.lightGray
        descriptionTV.layer.borderColor = UIColor.buttonColor().cgColor
        descriptionTV.layer.borderWidth = 1
        descriptionTV.layer.cornerRadius = 5
        descriptionTV.layer.masksToBounds = true
        descriptionTV.delegate = self
        descriptionTV.text = "Enter Description(Optional)"
        addNotesBtn.roundedButton()
        addNotesCV.delegate = self
        addNotesCV.dataSource = self
        addNotesCV.reloadData()
    }
    
    
    
}
extension AddNotesVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }else{
            textChnage = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Description(Optional)"
            textView.textColor = UIColor.lightGray
        }else{
            textChnage = true
        }
        
    }
}
//MARK: COLLECTION VIEW DELEGATES
extension AddNotesVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesUrl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "anCell", for: indexPath) as! AddNotesCVC
        getImageFromURL(imageView: cell.notesImageView, stringURL: imagesUrl[indexPath.row])
        cell.notesImageView.layer.borderColor = UIColor.buttonColor().cgColor
        cell.notesImageView.layer.borderWidth = 1
        cell.notesImageView.layer.cornerRadius = 5
        cell.notesImageView.layer.masksToBounds = true
        //        if indexPath.row == 0 {
        cell.deleteBtn.isHidden = true
        //        }else{
        //            cell.deleteBtn.isHidden = false
        //        }
        //        cell.deleteBtn.addTarget(self, action: #selector(deletePhoto(_:)), for: .touchUpInside)
        //        cell.deleteBtn.tag = indexPath.row
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
        let numberOfItemsperRow:CGFloat = 4.0
        let itemWidth = (collectionView.bounds.width - layout.minimumLineSpacing) / numberOfItemsperRow
        return CGSize(width: itemWidth + 30, height: itemWidth + 30 )//20.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC{
            VC.image = imagesUrl[indexPath.row]
            VC.modalPresentationStyle = .formSheet
            self.present(VC, animated: true)
        }
    }
    
    @objc func deletePhoto(_ sender: UIButton)
    {
        
        let refreshAlert = UIAlertController(title: "", message: "Do you want to delete the selected image ?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            refreshAlert .dismiss(animated: true, completion: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            self.imagesUrl.remove(at: sender.tag)
            self.addNotesCV.reloadData()
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    
}
//MARK: ImageSelection

extension AddNotesVC: UIImagePickerControllerDelegate , UINavigationControllerDelegate
{
    //MARK: Menu Option
    func addOption()
    {
        let alert = UIAlertController(title: " ", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            self.openCameraPic()
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.openCameraPic()
                }
            }
        case .denied: // The user has previously denied access.
            _ = SweetAlert().showAlert("", subTitle:  "You have denied choosing the photos from camera, please allow access from your phone's settings.", style: AlertStyle.warning,buttonTitle:"OK"){ (isOtherButton) -> Void in
                if isOtherButton == true {
                    if let appSettingsURL = NSURL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.openURL(appSettingsURL as URL)
                    }
                }
            }
        case .restricted: // The user can't grant access due to restrictions.
            return
        }
    }
    
    func openCameraPic()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallery()
    {
        PHPhotoLibrary.requestAuthorization { (status) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                DispatchQueue.main.async {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = true
                    imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            else
            {
                let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            if status == .denied{
                _ = SweetAlert().showAlert("", subTitle:  "You have denied choosing the photos from library, please allow access from your phone's settings.", style: AlertStyle.warning,buttonTitle:"OK"){ (isOtherButton) -> Void in
                    if isOtherButton == true {
                        if let appSettingsURL = NSURL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.openURL(appSettingsURL as URL)
                        }
                    }
                }
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                imageselected = img
            }
            else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imageselected = img
            }
            if  descriptionTV.text == "Enter Description(Optional)"{
                addNotesShow(task_id: task_id, note_title: notesTitle.text ?? "", notes: "", note_id: noteId)
            }else{
                addNotesShow(task_id: task_id, note_title: notesTitle.text ?? "", notes: descriptionTV.text ?? "", note_id: noteId)
            }
            //            }
            picker.dismiss(animated: true) {
                self.addNotesCV.reloadData()
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:  true, completion: nil)
    }
    
    func checkAll() -> Bool
    {
        if notesTitle.text == "" || notesTitle.text?.count ?? 0 < 3{
            _ = SweetAlert().showAlert("", subTitle:  "Please enter notes title", style: AlertStyle.none,buttonTitle:"OK")
            return false
//        }else if descriptionTV.text == ""{
//            _ = SweetAlert().showAlert("", subTitle:  "Please enter notes description", style: AlertStyle.none,buttonTitle:"OK")
//            return false
        }else{
            return true
        }
    }
    
}


//MARK: API Integration
extension AddNotesVC {
    
    //MARK: Add Notes  API
    func addNotesShow(task_id: Int, note_title: String, notes: String , note_id: String)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/notesave"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
//        descriptionTV.textColor = .lightGray
//        descriptionTV.text = "Enter Description(Optional)"
        param = ["task_ids": "\(task_id)", "note_title": note_title, "notes": notes, "note_id": note_id]
        print(param)
        print("Access Token: \(accessToken)")
        let header : HTTPHeaders = ["Content-type": "application/json","enctype" : "multipart/form-data","Authorization": "Bearer "+accessToken+""]
        AF.upload(
            multipartFormData: { (multipartFormData) in
                for (key, value) in param {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    }
                }
                if self.imageselected != nil{
                    multipartFormData.append((self.imageselected.jpegData(compressionQuality:0.8)!), withName: "file_upload", fileName: "image.jpg" , mimeType: "image/jpeg")
                }
            }
            , to: url, method: .post,
            headers:header)
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseJSON { response in
            switch response.result {
                
            case .success(let value):
                let dict = value as! [String:Any]
                self.status = dict["status"] as! Int
                if self.status == 200
                {
                    self.imagesUrl.removeAll()
                    if let jsonData = try? JSONSerialization.data(withJSONObject: value),
                       let loginResponse = try? JSONDecoder().decode(ShowNotesInfo.self, from: jsonData) {
                        self.noteId = "\(loginResponse.data[0].id)"
                        self.notesTitle.text = loginResponse.data[0].note_title
                        self.descriptionTV.text = loginResponse.data[0].notes
                        if let images = loginResponse.images {
                            for image in images {
                                print("Image ID: \(image.id)")
                                print("Image Name: \(image.images)")
                                self.imagesUrl.append(loginResponse.url + "/" + image.images)
                            }
                        }
                        progressHUD.hide()
                        self.addNotesCV.reloadData()
                       
                        
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
    
    //MARK: Show Notes  API
    func showNotes(note_id: String)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/notes_detail"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        param = ["id": note_id]
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
                    self.imagesUrl.removeAll()
                    if let jsonData = try? JSONSerialization.data(withJSONObject: value),
                       let loginResponse = try? JSONDecoder().decode(ShowNotesInfo.self, from: jsonData) {
                        
                        self.noteId = "\(loginResponse.data[0].id)"
                        self.notesTitle.text = loginResponse.data[0].note_title
                        self.descriptionTV.text = loginResponse.data[0].notes
                        self.descriptionTV.textColor = UIColor.black
                        if let images = loginResponse.images {
                            for image in images {
                                print("Image ID: \(image.id)")
                                print("Image Name: \(image.images)")
                                self.imagesUrl.append(loginResponse.url + "/" + image.images)
                            }
                        }
                        
//                        self.notesTitle.inputView = UIView()
//                        self.notesTitle.inputAccessoryView = UIView()
//                        self.notesTitle.tintColor = .white
//                        
//                        self.descriptionTV.inputView = UIView()
//                        self.descriptionTV.inputAccessoryView = UIView()
//                        self.descriptionTV.tintColor = .white
//                        
                        
                        self.addNotesCV.reloadData()
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
    
    //MARK: Get Time Card
    func getTimeCard(id : Int)
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        
        let url = "\(ApiLink.HOST_URL)/timecard_detail"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
        
        print("Access Token: \(accessToken)")
        var param: Parameters = ["":""]
        param = ["timecard_id": id]
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
                           let loginResponse = try? JSONDecoder().decode(TimeCardDetailsInfo.self, from: jsonData) {
                           
                            self.task_id = loginResponse.timeCards[0].task_id
                            
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
extension AddNotesVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textChnage = true
    }
}
