//
//  MyWorkerVC.swift
//  Cleansing
//
//  Created by United It Services on 30/08/23.
//

import UIKit

class MyWorkerVC: UIViewController {

    @IBOutlet weak var myWorkerTV: UITableView!
    
    var searchData = [search]()
    override func viewDidLoad() {
        super.viewDidLoad()
        firstCall()
        
    }

}
extension MyWorkerVC{
    
    func firstCall()
    {
        self.title = "My Workers"
//        searchData.append(search.init(clockType: ["COMPLETED", "ONGOING","UPCOMING"], name: ["David Richard","Kevin","John Armstrong"], dateRange: ["10 Aug - 25 Aug", "3 Sep - 12 Sep","22 Oct - 30 Oct"], startTime: ["12:05 PM","02:32 PM", "__:__ "], id: ["1","2","3"], amount: ["$ 100","$ 50","$75"], endTime: ["5:00 PM","__:__ ","__:__ "], breakTime: ["15 Min","30 Min","__ Min"]))
        //        myWorkerTV.delegate = self
        //        myWorkerTV.dataSource = self
        //        myWorkerTV.reloadData()
    }
    
}

extension MyWorkerVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData[section].dateRange.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sCell", for: indexPath) as! SearchTVC
//        cell.topName.text = searchData[indexPath.row].name
//        cell.topAmount.text = searchData[indexPath.section].amount[indexPath.row]
        cell.topDate.text = searchData[indexPath.row].dateRange
//        cell.breakTime.text = searchData[indexPath.section].breakTime[indexPath.row]
        cell.startTime.text = searchData[indexPath.row].startTime
        cell.endTime.text = searchData[indexPath.row].endTime
//        cell.checkType.text = searchData[indexPath.section].clockType[indexPath.row]
        if cell.checkType.text == "ONGOING"{
            cell.checkType.backgroundColor = .systemYellow
        }else if cell.checkType.text == "COMPLETED"{
            cell.checkType.backgroundColor = .systemGreen
        }else{
            cell.checkType.backgroundColor = .systemOrange
        }
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
        if let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProjectDetailVC") as? ProjectDetailVC{
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    
}
