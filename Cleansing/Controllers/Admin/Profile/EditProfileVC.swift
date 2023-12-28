//
//  EditProfileVC.swift
//  Cleansing
//
//  Created by United It Services on 22/08/23.
//

import UIKit
import Photos
import Alamofire

class EditProfileVC: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var editImageBtn: UIButton!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    var imageselected: UIImage!
    var status:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Profile"
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }

    @IBAction func updateBtnTap(_ sender: UIButton) {
        if checkAll(){
            //call API
            updateProfile()
        }
    }
    
    
    @IBAction func editBtnTap(_ sender: UIButton) {
        addOption()
    }
    
}

//MARK: Functions
extension EditProfileVC {
    
    func firstCall()
    {
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = 10//userImage.layer.bounds.height/2
        updateBtn.roundedButton()
        emailTF.inputView = UIView()
        mobileTF.inputView = UIView()
        mobileTF.inputAccessoryView = UIView()
        mobileTF.tintColor = .white
        emailTF.inputAccessoryView = UIView()
        emailTF.tintColor = .white
        addBlackBorder(to: nameTF)
        addBlackBorder(to: emailTF)
        addBlackBorder(to: mobileTF)
        addBlackBorder(to: locationTF)
        getProfile()
    }
    
    func checkAll() -> Bool
    {
        if nameTF.text == "" || nameTF.text?.count ?? 0 < 3{
            _ = SweetAlert().showAlert("", subTitle:  "Please enter your name", style: AlertStyle.none,buttonTitle:"OK")
            return false
//        }else if emailTF.text == "" || isValidEmailAddress(emailAddressString: emailTF.text ?? "") == false{
//            _ = SweetAlert().showAlert("", subTitle:  "Please enter valid E-mail address", style: AlertStyle.none,buttonTitle:"OK")
//            return false
//        }else if mobileTF.text == "" || mobileTF.text?.count ?? 0 < 10{
//            _ = SweetAlert().showAlert("", subTitle:  "Please enter valid mobile number", style: AlertStyle.none,buttonTitle:"OK")
//            return false
        }else{
            return true
        }
    }
}

//MARK: UITextField View Delegate
extension EditProfileVC: UITextFieldDelegate
{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.returnKeyType = UIReturnKeyType.done
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()  //if desired
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileTF || textField == mobileTF{
            if let text = textField.text {
                let floatingLabelTextField = textField
                print(text.count)
                if(text.count < 9) {
                    
                }else{
                    let maxLength = 10
                    let currentString: NSString = (textField.text ?? "") as NSString
                    let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                    return newString.length <= maxLength
                    
                }
            }
        }
        return true
    }
}

//MARK: ImageSelection

extension EditProfileVC: UIImagePickerControllerDelegate , UINavigationControllerDelegate
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
//                userImage.image = imageselected
                uploadImage()
            picker.dismiss(animated: true) {}
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:  true, completion: nil)
    }

}

//MARK: API Integartion
extension EditProfileVC{
    
    //MARK: Get Profile API
    func getProfile()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
      
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/get_profile"
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
                               let loginResponse = try? JSONDecoder().decode(ProfileInfo.self, from: jsonData) {
                                
                                self.getImageFromURL(imageView: self.userImage, stringURL: loginResponse.url + (loginResponse.data.profile_image ?? ""))
                                self.nameTF.text = loginResponse.data.fullname
                                self.emailTF.text = loginResponse.data.email
                                self.mobileTF.text = loginResponse.data.mobile_number
                                
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
    
    
    //MARK: Update Profile API
    func updateProfile()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
      
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/update_profile"
        param = ["name": nameTF.text ?? "", "email": emailTF.text ?? "", "phone": mobileTF.text ?? ""]
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
                               let loginResponse = try? JSONDecoder().decode(DefaultInfo.self, from: jsonData) {
                                
                                _ = SweetAlert().showAlert("", subTitle:  dict["message"] as? String, style: AlertStyle.success,buttonTitle:"OK"){ (isOtherButton) -> Void in
                                    if isOtherButton == true {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                    
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
    
    //MARK: Add Notes  API
    func uploadImage()
    {
        if reachability.isConnectedToNetwork() == false{
            _ = SweetAlert().showAlert("", subTitle: ApiLink.INTERNET_ERROR_MESSAGE, style: AlertStyle.none,buttonTitle:"OK")
            return
        }
        let progressHUD = ProgressHUD()
        self.view.addSubview(progressHUD)
        progressHUD.show()
        var param: Parameters = ["":""]
        let url = "\(ApiLink.HOST_URL)/update_profile_picture"
        let accessToken = UserDefaults.standard.string(forKey: "token") ?? ""
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
                    multipartFormData.append((self.imageselected.jpegData(compressionQuality:0.8)!), withName: "image", fileName: "image.jpg" , mimeType: "image/jpeg")
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
                   
                    if let jsonData = try? JSONSerialization.data(withJSONObject: value),
                       let loginResponse = try? JSONDecoder().decode(DefaultInfo.self, from: jsonData) {
                        
                        self.imageselected = nil
                        self.getImageFromURL(imageView: self.userImage, stringURL: dict["image"] as! String)
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
