//
//  ContactUsVC.swift
//  Cleansing
//
//  Created by United It Services on 22/08/23.
//

import UIKit

class ContactUsVC: UIViewController {


    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ContactUs"
        firstCall()
    }

    
    @IBAction func submitBtnTap(_ sender: UIButton) {
        self.view.endEditing(true)
        if checkAll() {
            //Call API
        }
    }
    

}
extension ContactUsVC {
    
    func firstCall()
    {
        messageTV.textColor = UIColor.lightGray
        messageTV.delegate = self
        addBlackBorder(to: emailTF)
        addBlackBorder(to: nameTF)
        submitBtn.roundedButton()
        messageTV.layer.borderColor = UIColor.buttonColor().cgColor
        messageTV.layer.borderWidth = 1.0
        messageTV.layer.cornerRadius = 10
        emailTF.inputView = UIView()
        emailTF.inputAccessoryView = UIView()
        emailTF.tintColor = .white
        nameTF.inputView = UIView()
        nameTF.inputAccessoryView = UIView()
        nameTF.tintColor = .white
    }
}

extension ContactUsVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Message*"
            textView.textColor = UIColor.lightGray
        }
    }
}

extension ContactUsVC{
    
    func checkAll() -> Bool {
        
        if nameTF.text == " " || nameTF.text?.count ?? 0 < 3{
            _ = SweetAlert().showAlert("", subTitle: "Please enter the name", style: AlertStyle.warning,buttonTitle:"OK")
            return false
        }else if emailTF.text == " "{
            _ = SweetAlert().showAlert("", subTitle: "Please enter the email address", style: AlertStyle.warning,buttonTitle:"OK")
            return false
        }else if isValidEmailAddress(emailAddressString: emailTF.text ?? "") == false{
            _ = SweetAlert().showAlert("", subTitle: "Please enter the valid email address", style: AlertStyle.warning,buttonTitle:"OK")
            return false
        }else  if messageTV.text == " " || messageTV.text == "Enter Message*"{
            _ = SweetAlert().showAlert("", subTitle: "Please enter the message", style: AlertStyle.warning,buttonTitle:"OK")
            return false
        }else{
            return true
        }
    }
    
}
