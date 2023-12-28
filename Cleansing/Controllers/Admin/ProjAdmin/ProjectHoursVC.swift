//
//  ProjectHoursVC.swift
//  Cleansing
//
//  Created by UIS on 07/11/23.
//

import UIKit

class ProjectHoursVC: UIViewController {

    @IBOutlet weak var projectHourTV: UITableView!
    
    var pickerView: UIPickerView!
    var showData = [showFilter]()
    var selectedIndex:Int = 0
    var alertController: UIAlertController!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstCall()
    }

}

extension ProjectHoursVC {
    
    func firstCall()
    {
        projectPicker()
        self.showData.append(showFilter.init(id: [[0,1,2],[0,1,2],[0,1,2]], name: [["Hour type","Person & hour type","Cost code & hour type"],["Hour type","Person & hour type","Cost code & hour type"], ["Hour type","Person & hour type","Cost code & hour type"]], titl: ["Summary","By Period","Cumulative"], selected: ["Hour type","Hour type","Hour type"]))
        projectHourTV.delegate = self
        projectHourTV.dataSource = self
        projectHourTV.reloadData()
    }
    
    //MARK: Project Picker
    func projectPicker()
    {
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        // Create a UIAlertController with a UIPickerView
        alertController = UIAlertController(title: "Select an Option", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        // Add the UIPickerView to the UIAlertController
        alertController.view.addSubview(pickerView)
        
        // Define actions for the UIAlertController
        //                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let selectAction = UIAlertAction(title: "Submit", style: .default) { [weak self] (action) in
            if let selectedRow = self?.pickerView.selectedRow(inComponent: 0) {
                let selectedOption = self?.showData[0].name[self?.selectedIndex ?? 0][selectedRow] ?? ""
                self?.showData[0].selected.remove(at: self?.selectedIndex ?? 0)
                self?.showData[0].selected.insert(selectedOption, at: self?.selectedIndex ?? 0)
//                self?.filterBtn.setTitle(selectedOption, for: .normal)//to be set in cell
                print(selectedOption ?? "" + "Hello")
//                self?.project_id = self?.showData[selectedRow].id ?? 0
                self?.projectHourTV.reloadData()
            }
        }
        // Add actions to the UIAlertController
        //                alertController.addAction(cancelAction)
        alertController.addAction(selectAction)
        // Configure the UIPickerView
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -40).isActive = true
        pickerView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 10).isActive = true
    }
}

extension ProjectHoursVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showData[0].titl.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "phCell", for: indexPath) as! ProjectHourTVC
        cell.topLabel.text =  showData[0].titl[indexPath.row]
        cell.hourTypeBtn.tag = indexPath.row
        cell.hourTypeBtn.setTitle(showData[0].selected[indexPath.row], for: .normal)
        cell.hourTypeBtn.addTarget(self, action: #selector(selectBtnTap(_:)), for: .touchUpInside)
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
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAdminProjVC") as? DetailAdminProjVC{
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @objc func selectBtnTap(_ sender: UIButton){
        let tag = sender.tag
        selectedIndex = tag
        present(alertController, animated: true)
    }
    
    @objc func segmentTap(_ sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
          
           
        }else if sender.selectedSegmentIndex == 1{
         
        }else{
    
        }
        
    }
    
}
extension ProjectHoursVC: UIPickerViewDelegate, UIPickerViewDataSource {
    // UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return showData[0].name.count
    }
    
    // UIPickerViewDelegate methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return showData[0].name[selectedIndex][row]
    }
}
