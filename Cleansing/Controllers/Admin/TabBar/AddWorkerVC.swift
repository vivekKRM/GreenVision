//
//  AddWorkerVC.swift
//  surfers
//
//  Created by United It Services on 21/08/23.
//

import UIKit
import CoreLocation
import Photos
class AddWorkerVC: UIViewController {
    
    @IBOutlet weak var addWokerBtn: UIButton!
    @IBOutlet weak var takePictureBtn: UIButton!
    @IBOutlet weak var currentlocation: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var patientImageView: UIImageView!
    @IBOutlet weak var patientTV: UITableView!
    @IBOutlet weak var fNameTF: UITextField!
    @IBOutlet weak var lNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var maleView: UIView!
    @IBOutlet weak var maleButton: customButton!
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var femaleButton: customButton!
    @IBOutlet weak var othersView: UIView!
    @IBOutlet weak var othersButton: customButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var serviceTF: UITextField!
    @IBOutlet weak var subserviceTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var zipTF: UITextField!
    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var bankNameTF: UITextField!
    @IBOutlet weak var ifscTF: UITextField!
    @IBOutlet weak var ssnTF: UITextField!
    @IBOutlet weak var dlTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    
    
    let items = ["Recurring Scheduled Cleaning", "Deep Cleaning", "Airbnb Cleaning"]
    let subitems = ["Home Cleanser", "Bathroom Cleanser", "Kitchen Cleanser", "LivingRoom Cleanser", "BedRoom Cleanser"]
    var imageselected: UIImage!
    var workerinfo = AddWorker()
    var pickerView = UIPickerView()
    var subpickerView = UIPickerView()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        firstCall()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        addOption()
    }
    
    @IBAction func datepickerTapped(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
           if let day = components.day, let month = components.month, let year = components.year {
               print("\(day) \(month) \(year)")
               self.workerinfo.dob = "\(day)" + "-" + "\(month)" + "-" + "\(year)"
              
               
           }
    }
    
    @IBAction func maleBtnTapped(_ sender: customButton) {
        if let button = sender as? customButton {
            button.isSelected = !button.isSelected
            self.workerinfo.gender = "Male"
            //            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = UIColor.buttonColor()
        }
       
        othersButton.isSelected = false
        femaleButton.isSelected = false
    }
    
    @IBAction func femaleBtnTapped(_ sender: customButton) {
        if let button = sender as? customButton {
            button.isSelected = !button.isSelected
            self.workerinfo.gender = "Female"
            button.backgroundColor = UIColor.buttonColor()
        }
        
        maleButton.isSelected = false
        othersButton.isSelected = false
    }
    
    @IBAction func othersBtnTapped(_ sender: customButton) {
        if let button = sender as? customButton {
            button.isSelected = !button.isSelected
            self.workerinfo.gender = "Others"
            button.backgroundColor = UIColor.buttonColor()
        }
        
        maleButton.isSelected = false
        femaleButton.isSelected = false
    }
    
    @IBAction func addWorkerBtnTap(_ sender: UIButton) {
        if checkAll() {
            //call API
        }
    }
    
    
}
extension AddWorkerVC{
    
    func firstCall()
    {
//        //MARK: Picker
        pickerView.delegate = self
        pickerView.dataSource = self
        subpickerView.delegate = self
        subpickerView.dataSource = self
        serviceTF.inputView = pickerView
        subserviceTF.inputView = subpickerView
//        //MARK: Location
        locationManager.delegate = self
        checkLocationServices()
        addBlackBorder(to: fNameTF)
        addBlackBorder(to: lNameTF)
        addBlackBorder(to: emailTF)
        addBlackBorder(to: mobileNumberTF)
        addBlackBorder(to: serviceTF)
        addBlackBorder(to: dobTF)
        addBlackBorder(to: passwordTF)
        addBlackBorder(to: countryTF)
        addBlackBorder(to: stateTF)
        addBlackBorder(to: cityTF)
        addBlackBorder(to: zipTF)
        addBlackBorder(to: accountTF)
        addBlackBorder(to: bankNameTF)
        addBlackBorder(to: ifscTF)
        addBlackBorder(to: ssnTF)
        addBlackBorder(to: dlTF)
        addBlackBorder(to: subserviceTF)
        addBlackBorder(to: confirmPasswordTF)
        addWokerBtn.roundedButton()
        takePictureBtn.roundedButton()
        
        AddShadow10(button: maleButton)
        AddShadow10(button: femaleButton)
        AddShadow10(button: othersButton)
        
        maleView.dropShadowWithBlackColor()
        femaleView.dropShadowWithBlackColor()
        othersView.dropShadowWithBlackColor()
      
        
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
    }
    
    func checkAll() -> Bool
    {
        if fNameTF.text == "" || fNameTF.text?.count ?? 0 < 3{
            _ = SweetAlert().showAlert("", subTitle:  "Please enter your first name", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else  if lNameTF.text == "" || lNameTF.text?.count ?? 0 < 3{
            _ = SweetAlert().showAlert("", subTitle:  "Please enter your last name", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if emailTF.text == "" || isValidEmailAddress(emailAddressString: emailTF.text ?? "") == false{
            _ = SweetAlert().showAlert("", subTitle:  "Please enter valid E-mail address", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if mobileNumberTF.text == "" || mobileNumberTF.text?.count ?? 0 < 10{
            _ = SweetAlert().showAlert("", subTitle:  "Please enter valid mobile number", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if serviceTF.text == "" || serviceTF.text?.count ?? 0 < 10{
            _ = SweetAlert().showAlert("", subTitle:  "Please choose the services", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if subserviceTF.text == "" || subserviceTF.text?.count ?? 0 < 10{
            _ = SweetAlert().showAlert("", subTitle:  "Please choose the sub-services", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if dobTF.text == "" || dobTF.text?.count ?? 0 < 12{
            _ = SweetAlert().showAlert("", subTitle:  "Please select the date of birth", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if passwordTF.text == "" || passwordTF.text?.count ?? 0 < 6 {
            _ = SweetAlert().showAlert("", subTitle:  "Please enter valid password", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if confirmPasswordTF.text == "" || confirmPasswordTF.text?.count ?? 0 < 6 {
            _ = SweetAlert().showAlert("", subTitle:  "Please enter valid confirm password", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if passwordTF.text != confirmPasswordTF.text {
            _ = SweetAlert().showAlert("", subTitle:  "Password and confirm password doesnot match", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if countryTF.text == "" || countryTF.text?.count ?? 0 < 5 {
            _ = SweetAlert().showAlert("", subTitle:  "Please select country", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if stateTF.text == "" || stateTF.text?.count ?? 0 < 3 {
            _ = SweetAlert().showAlert("", subTitle:  "Please select state", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if cityTF.text == "" || cityTF.text?.count ?? 0 < 3 {
            _ = SweetAlert().showAlert("", subTitle:  "Please select city", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if zipTF.text == "" || zipTF.text?.count ?? 0 < 8 {
            _ = SweetAlert().showAlert("", subTitle:  "Please enter zip code", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if accountTF.text == "" || accountTF.text?.count ?? 0 < 15 {
            _ = SweetAlert().showAlert("", subTitle:  "Please enter your account number", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if bankNameTF.text == "" || bankNameTF.text?.count ?? 0 < 3 {
            _ = SweetAlert().showAlert("", subTitle:  "Please select country", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if ifscTF.text == "" || ifscTF.text?.count ?? 0 < 7 {
            _ = SweetAlert().showAlert("", subTitle:  "Please enter your bank account IFSC code", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if ssnTF.text == "" || ssnTF.text?.count ?? 0 < 15 {
            _ = SweetAlert().showAlert("", subTitle:  "Please enter your SSN number", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if dlTF.text == "" || dlTF.text?.count ?? 0 < 10 {
            _ = SweetAlert().showAlert("", subTitle:  "Please enter your vehicle driving licence", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else{
            return true
        }
    }
    
}


extension AddWorkerVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
           if textField == dobTF {
               // Show the date picker
               return true
           }
           return true
       }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileNumberTF || textField == mobileNumberTF{
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

//MARK: Picker
extension AddWorkerVC:  UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == subpickerView{
            return subitems.count
        }else{
            return items.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == subpickerView{
            return subitems[row]
        }else{
            return items[row]
        }
      
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == subpickerView{
            subserviceTF.text = subitems[row]
            subserviceTF.resignFirstResponder() // Close the picker
        }else{
            serviceTF.text = items[row]
            serviceTF.resignFirstResponder() // Close the picker
        }
        
    }
}
//MARK: Location
extension AddWorkerVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                if let locality = placemark.locality, let country = placemark.country {
                    self.currentlocation.text = "\(locality), \(country)"
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch manager.authorizationStatus {
               case .authorizedWhenInUse, .authorizedAlways:
                   break
               case .denied, .restricted:
                openAppSettings()
            self.currentlocation.text = "Location Access Denied"
               case .notDetermined:
                   break // Handle the case where the user hasn't made a decision yet
               @unknown default:
                   break
               }
    }
    
    func checkLocationServices() {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            } else {
                self.currentlocation.text = "Location Services Disabled"
            }
        }
    
    func openAppSettings() {
           if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
               if UIApplication.shared.canOpenURL(settingsUrl) {
                   UIApplication.shared.open(settingsUrl, completionHandler: nil)
               }
           }
       }
    
    
}
//MARK: ImageSelection

extension AddWorkerVC: UIImagePickerControllerDelegate , UINavigationControllerDelegate
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
                patientImageView.image = imageselected
                    
                
                
            picker.dismiss(animated: true) {}
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:  true, completion: nil)
    }

}
//MARK: DateTime Picker
extension AddWorkerVC
{
//    func setupDatePicker() {
//           datePicker.datePickerMode = .date
//            datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
//           ageTF.inputView = datePicker
//           datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
////        datePicker.frame = CGRect(x: UIScreen.main.bounds.width * 0.7, y: UIScreen.main.bounds.height * 0.7, width: 150, height: 40)
////         view.addSubview(datePicker)
//       }

       @objc func dateChanged() {
           let dateFormatter = DateFormatter()
           dateFormatter.dateStyle = .medium
           dobTF.text = dateFormatter.string(from: datePicker.date)
       }

}
