//
//  StepTwoVC.swift
//  Cleansing
//
//  Created by United It Services on 30/08/23.
//

import UIKit

class StepTwoVC: UIViewController {
    
    @IBOutlet weak var workerCV: UICollectionView!
    @IBOutlet weak var addProjectBtn: UIButton!
    
    var selectedIndexPath: IndexPath?
    var workerData = [showWorker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstCall()
    }
    

    @IBAction func addProjectBtnTap(_ sender: UIButton) {
    }
    

}

extension StepTwoVC{
    
    func firstCall()
    {
        self.title = "Add Project"
        addProjectBtn.roundedButton()
        workerData.append(showWorker.init(wName: ["Adam","John Smith","Alexander","Brad Hoc","David","Messy"], wService: ["Living Room","Bathroom Cleaning","Bedroom Cleaning","Kitchen Cleaning","Dining Cleaning","Fullhome Cleaning"], wHeader: ["Choose Workers","Choose Services"]))
        workerCV.delegate = self
        workerCV.dataSource = self
        workerCV.reloadData()
    }
}

//MARK: COLLECTION VIEW DELEGATES
extension StepTwoVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.workerData[0].wHeader.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.workerData[0].wName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let workerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cwCell", for: indexPath) as! StepTwoCVC
        workerCell.topView.dropShadowWithBlackColor()
        
        if indexPath.section == 0{
            workerCell.nameLabel.text = self.workerData[0].wName[indexPath.row]
        }else{
            workerCell.nameLabel.text = self.workerData[0].wService[indexPath.row]
        }
        return workerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.scrollDirection = .vertical
        let numberOfItemsperRow:CGFloat = 4
        let itemWidth = (collectionView.bounds.width - layout.minimumLineSpacing) / numberOfItemsperRow
        return CGSize(width: itemWidth + 30, height: itemWidth  )//itemWidth
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        if let cell = collectionView.cellForItem(at: indexPath) as? StepTwoCVC {
            
            if let selected = selectedIndexPath, selected == indexPath {
                print("1")
                selectedIndexPath = nil
                cell.topView.backgroundColor = UIColor.white
                cell.nameLabel.textColor = .black
            } else {
                selectedIndexPath = indexPath
                cell.topView.backgroundColor = UIColor(hexString: "ce4969")
                cell.nameLabel.textColor = .white
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "shCell", for: indexPath) as? SectionHeader{
            sectionHeader.headerLabel.text = self.workerData[0].wHeader[indexPath.section]
            return sectionHeader
        }
        return UICollectionReusableView()
    }
}
