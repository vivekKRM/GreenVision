//
//  AddProjectVC.swift
//  Cleansing
//
//  Created by United It Services on 22/08/23.
//

import UIKit
import Fastis
class AddProjectVC: UIViewController {
    
    
    
    @IBOutlet weak var projectNameTF: UITextField!
    @IBOutlet weak var startDateRangeTF: UITextField!
    @IBOutlet weak var endDateRangeTF: UITextField!
    @IBOutlet weak var hourRateTF: UITextField!
    @IBOutlet weak var addProjectBtn: UIButton!
    @IBOutlet weak var enterPrice: UITextField!
    
    
    let datePicker = UIDatePicker()
    var pickerView = UIPickerView()
    let items = ["Hourly Costing", "Fixed Costing"]
    var choose: String = "S"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Project"
        self.navigationController?.isNavigationBarHidden = false
        firstCall()
    }
    
    
    @IBAction func addProjectBtnTap(_ sender: UIButton) {
//        if checkAll() {
            //call API
            if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StepTwoVC") as? StepTwoVC{
                     self.navigationController?.pushViewController(VC, animated: true)
                 }
//        }
    }
    
    
}
extension AddProjectVC {
    
    func firstCall()
    {
        addBlackBorder(to: projectNameTF)
        addBlackBorder(to: startDateRangeTF)
        addBlackBorder(to: endDateRangeTF)
        addBlackBorder(to: hourRateTF)
        addBlackBorder(to: enterPrice)
        addProjectBtn.roundedButton()
    }
    
    func configureDatePicker(textField: UITextField) {
            datePicker.datePickerMode = .dateAndTime
        textField.inputView = datePicker
        datePicker.minimumDate = Date()
            // Add a toolbar with a "Done" button to the keyboard
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
            toolbar.setItems([doneButton], animated: true)
        textField.inputAccessoryView = toolbar
        }
        
        @objc func doneButtonTapped() {
            let selectedDateTime = datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yy HH:mm"
            if choose == "St"{
                startDateRangeTF.text = dateFormatter.string(from: selectedDateTime)
                startDateRangeTF.resignFirstResponder()
            }else{
                endDateRangeTF.text = dateFormatter.string(from: selectedDateTime)
                endDateRangeTF.resignFirstResponder()
            }
          
        }
    
    
    func checkAll() -> Bool {
        if projectNameTF.text == "" || projectNameTF.text?.count ?? 0 < 7 {
            _ = SweetAlert().showAlert("", subTitle:  "Please enter project name", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if startDateRangeTF.text == "" || startDateRangeTF.text?.count ?? 0 < 7 {
            _ = SweetAlert().showAlert("", subTitle:  "Please select start date and time", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if endDateRangeTF.text == "" || endDateRangeTF.text?.count ?? 0 < 7 {
            _ = SweetAlert().showAlert("", subTitle:  "Please select end date and time", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if hourRateTF.text == "" || hourRateTF.text?.count ?? 0 < 10 {
            _ = SweetAlert().showAlert("", subTitle:  "Please select costing type", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else if enterPrice.text == "" || enterPrice.text?.count ?? 0 < 2 {
            _ = SweetAlert().showAlert("", subTitle:  "Please enter the project costing price in dollar", style: AlertStyle.none,buttonTitle:"OK")
            return false
        }else{
            return true
        }
    }
    
}
extension AddProjectVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == startDateRangeTF {
            choose = "St"
            textField.inputView = UIView()
            configureDatePicker(textField: textField)
        }else if  textField == endDateRangeTF {
            choose = "En"
            textField.inputView = UIView()
            configureDatePicker(textField: textField)
        }else if textField == hourRateTF{
            choose = "hw"
            textField.inputView = pickerView
            pickerView.delegate = self
            pickerView.dataSource = self
            
        }
    }
    
}
//MARK: Picker
extension AddProjectVC:  UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if  choose == "hw"{
            hourRateTF.text = items[row]
            hourRateTF.resignFirstResponder() // Close the picker
        }
    }
}
