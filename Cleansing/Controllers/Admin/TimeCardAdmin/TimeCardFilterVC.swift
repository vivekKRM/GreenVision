//
//  TimeCardFilterVC.swift
//  Cleansing
//
//  Created by uis on 19/02/24.
//

import UIKit
import Alamofire

class TimeCardFilterVC: UIViewController {

    
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    
    @IBOutlet weak var statuss: UILabel!
    @IBOutlet weak var timeapprover: UILabel!
    @IBOutlet weak var worker: UILabel!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    
    @IBOutlet weak var updateBtn: UIButton!
    
    @IBOutlet weak var resetbtn: UIButton!
    
    
    var dataCompletion: (([String]) -> Void)?
    var respArr:[String] = ["","",""]
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
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func firstBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TimeCardSelectionVC") as? TimeCardSelectionVC{
            if let presentationController = VC.presentationController as? UISheetPresentationController {
                presentationController.detents = [.large()]
            }
            VC.dataCompletion = { data in
                print("Received data:", data)
//                for (key, value) in data {
//                    print("Key:", key, "Value:", value)
//                }
                let values = Array(data.values)
                let commaSeparatedString = values.joined(separator: ",")
                self.firstLabel.text = commaSeparatedString
                
                let keys = Array(data.keys)
                let commaSeparatedKey = keys.joined(separator: ",")
                self.respArr.insert(commaSeparatedKey, at: 0)
               
                UserDefaults.standard.setValue(commaSeparatedKey == "" ? "all" : commaSeparatedKey, forKey: "statusT")
            }
            VC.calledType = "Status"
            self.present(VC, animated: true)
        }
    }
    
    
    @IBAction func secondBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TimeCardSelectionVC") as? TimeCardSelectionVC{
            if let presentationController = VC.presentationController as? UISheetPresentationController {
                presentationController.detents = [.large()]
            }
            VC.dataCompletion = { data in
                print("Received data:", data)
//                for (key, value) in data {
//                    print("Key:", key, "Value:", value)
//                }
                let values = Array(data.values)
                let commaSeparatedString = values.joined(separator: ",")
                self.secondLabel.text = commaSeparatedString
                
                let keys = Array(data.keys)
                let commaSeparatedKey = keys.joined(separator: ",")
                self.respArr.insert(commaSeparatedKey, at: 1)
                UserDefaults.standard.setValue(commaSeparatedKey == "" ? "" : commaSeparatedKey, forKey: "approverT")
            }
            VC.calledType = "Manager"
            self.present(VC, animated: true)
        }
    }
    
    
    @IBAction func thirdBtnTap(_ sender: UIButton) {
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TimeCardSelectionVC") as? TimeCardSelectionVC{
            if let presentationController = VC.presentationController as? UISheetPresentationController {
                presentationController.detents = [.large()]
            }
            VC.dataCompletion = { data in
                print("Received data:", data)
//                for (key, value) in data {
//                    print("Key:", key, "Value:", value)
//                }
                let values = Array(data.values)
                let commaSeparatedString = values.joined(separator: ",")
                self.thirdLabel.text = commaSeparatedString
                
                let keys = Array(data.keys)
                let commaSeparatedKey = keys.joined(separator: ",")
                self.respArr.insert(commaSeparatedKey, at: 2)
                UserDefaults.standard.setValue(commaSeparatedKey, forKey: "workerT")
                UserDefaults.standard.setValue(commaSeparatedString, forKey: "workerV")
            }
            VC.calledType = "Worker"
            self.present(VC, animated: true)
        }
    }
    
    
    @IBAction func updateBtnTap(_ sender: UIButton) {
        print(respArr)
        dataCompletion?(respArr)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func resetBtnTap(_ sender: UIButton) {
        UserDefaults.standard.setValue( "", forKey: "workerT")
        UserDefaults.standard.setValue( "all", forKey: "statusT")
        UserDefaults.standard.setValue("", forKey: "workerV")
        UserDefaults.standard.setValue("", forKey: "statusV")
        UserDefaults.standard.setValue("", forKey: "approverV")
        UserDefaults.standard.setValue("", forKey: "approverT")
        self.navigationController?.popViewController(animated: true)
    }
    
    
  
}
//MARK: First Call
extension TimeCardFilterVC{
    
    func firstCall(){
        lang = UserDefaults.standard.string(forKey: "Lang") ?? "en"
        filterLabel.text = "Filters".localizeString(string: lang)
        addTopAndBottomBorder(to: firstView, color: UIColor.lightGray, thickness: 1.0)
//        addTopAndBottomBorder(to: secondView, color: UIColor.lightGray, thickness: 1.0)
        addTopAndBottomBorder(to: thirdView, color: UIColor.lightGray, thickness: 1.0)
        statuss.text = "Status".localizeString(string: lang)
        timeapprover.text = "Time approver".localizeString(string: lang)
        worker.text = "Worker".localizeString(string: lang)
        updateBtn.setTitle("APPLY".localizeString(string: lang), for: .normal)
        resetbtn.setTitle("RESET TO DEAFULT".localizeString(string: lang), for: .normal)
        updateBtn.roundedButton()
        resetbtn.roundedButton()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(firstTap(_:)))
        firstView.addGestureRecognizer(tapGestureRecognizer)
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(secondTap(_:)))
        secondView.addGestureRecognizer(tapGestureRecognizer1)
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(thirdTap(_:)))
        thirdView.addGestureRecognizer(tapGestureRecognizer2)
        
        firstLabel.text = UserDefaults.standard.string(forKey: "statusV") == "" ? "All" : UserDefaults.standard.string(forKey: "statusV")
        thirdLabel.text = UserDefaults.standard.string(forKey: "workerV") == "" ? "All" : UserDefaults.standard.string(forKey: "workerV")
        secondLabel.text = UserDefaults.standard.string(forKey: "approverV") == "" ? "All" : UserDefaults.standard.string(forKey: "approverV")

    }
    
    func addTopAndBottomBorder(to view: UIView, color: UIColor, thickness: CGFloat) {
           // Add top border
           let topBorder = CALayer()
           topBorder.backgroundColor = color.cgColor
           topBorder.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: thickness)
           view.layer.addSublayer(topBorder)
           
           // Add bottom border
           let bottomBorder = CALayer()
           bottomBorder.backgroundColor = color.cgColor
           bottomBorder.frame = CGRect(x: 0, y: view.frame.size.height - thickness, width: view.frame.size.width, height: thickness)
           view.layer.addSublayer(bottomBorder)
       }
    
    
    @objc func firstTap(_ sender: UITapGestureRecognizer){
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TimeCardSelectionVC") as? TimeCardSelectionVC{
            if let presentationController = VC.presentationController as? UISheetPresentationController {
                presentationController.detents = [.large()]
            }
            VC.dataCompletion = { data in
                print("Received data:", data)
//                for (key, value) in data {
//                    print("Key:", key, "Value:", value)
//                    // Handle each key-value pair as needed
//                }
                let values = Array(data.values)
                let commaSeparatedString = values.joined(separator: ",")
                self.firstLabel.text = commaSeparatedString
                
                let keys = Array(data.keys)
                let commaSeparatedKey = keys.joined(separator: ",")
                self.respArr.insert(commaSeparatedKey, at: 0)
                UserDefaults.standard.setValue( commaSeparatedKey, forKey: "statusT")
                UserDefaults.standard.setValue(commaSeparatedString, forKey: "statusV")
            }
            VC.calledType = "Status"
            self.present(VC, animated: true)
        }
    }
    
    @objc func secondTap(_ sender: UITapGestureRecognizer){
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TimeCardSelectionVC") as? TimeCardSelectionVC{
            if let presentationController = VC.presentationController as? UISheetPresentationController {
                presentationController.detents = [.large()]
            }
            VC.dataCompletion = { data in
                print("Received data:", data)
//                for (key, value) in data {
//                    print("Key:", key, "Value:", value)
//                    // Handle each key-value pair as needed
//                }
                let values = Array(data.values)
                let commaSeparatedString = values.joined(separator: ",")
                self.secondLabel.text = commaSeparatedString
                
                let keys = Array(data.keys)
                let commaSeparatedKey = keys.joined(separator: ",")
                self.respArr.insert(commaSeparatedKey, at: 1)
                UserDefaults.standard.setValue(commaSeparatedKey == "" ? "" : commaSeparatedKey, forKey: "approverT")
                UserDefaults.standard.setValue(commaSeparatedString, forKey: "approverV")
            }
            VC.calledType = "Manager"
            self.present(VC, animated: true)
        }
    }
    @objc func thirdTap(_ sender: UITapGestureRecognizer){
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TimeCardSelectionVC") as? TimeCardSelectionVC{
            if let presentationController = VC.presentationController as? UISheetPresentationController {
                presentationController.detents = [.large()]
            }
            VC.dataCompletion = { data in
                print("Received data:", data)
//                for (key, value) in data {
//                    print("Key:", key, "Value:", value)
//                }
                let values = Array(data.values)
                let commaSeparatedString = values.joined(separator: ",")
                self.thirdLabel.text = commaSeparatedString
                
                let keys = Array(data.keys)
                let commaSeparatedKey = keys.joined(separator: ",")
                self.respArr.insert(commaSeparatedKey, at: 2)
                UserDefaults.standard.setValue(commaSeparatedKey, forKey: "workerT")
                UserDefaults.standard.setValue(commaSeparatedString, forKey: "workerV")
            }
            VC.calledType = "Worker"
            self.present(VC, animated: true)
        }
    }
    
    
}
