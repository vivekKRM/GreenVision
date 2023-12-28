//
//  ProjectHourTVC.swift
//  Cleansing
//
//  Created by UIS on 07/11/23.
//

import UIKit

class ProjectHourTVC: UITableViewCell {

    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var tipBtn: UIButton!
    @IBOutlet weak var hourTypeBtn: UIButton!
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var segmentCellControl: UISegmentedControl!
    
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var monthView: UIView!
    
    
    var underlineView = UIView()
    override func awakeFromNib() {
        super.awakeFromNib()
        customSegment()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK: Configure SegmentControl
    
    func customSegment()
    {
        let selectedAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "004080")]
        let unselectedAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        segmentCellControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        segmentCellControl.setTitleTextAttributes(unselectedAttributes, for: .normal)
        underlineView.backgroundColor = UIColor(hexString: "004080")
        segmentCellControl.addSubview(underlineView)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        underlineView.widthAnchor.constraint(equalTo: segmentCellControl.widthAnchor, multiplier: 1.0 / CGFloat(segmentCellControl.numberOfSegments)).isActive = true
        underlineView.topAnchor.constraint(equalTo: segmentCellControl.bottomAnchor).isActive = true
        underlineView.leadingAnchor.constraint(equalTo: segmentCellControl.leadingAnchor).isActive = true
    }

    
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        let segmentWidth = segmentCellControl.frame.width / CGFloat(segmentCellControl.numberOfSegments)
            let x = segmentWidth * CGFloat(sender.selectedSegmentIndex)
            UIView.animate(withDuration: 0.3) {
                self.underlineView.frame.origin.x = x
            }
        
        if sender.selectedSegmentIndex == 0{
            weekView.isHidden = true
            monthView.isHidden = true
            dayView.isHidden = false
        }else if sender.selectedSegmentIndex == 1{
            weekView.isHidden = false
            monthView.isHidden = true
            dayView.isHidden = true
        }else{
            weekView.isHidden = true
            monthView.isHidden = false
            dayView.isHidden = true
        }
    }
    
}
