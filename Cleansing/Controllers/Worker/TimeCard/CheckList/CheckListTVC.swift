//
//  CheckListTVC.swift
//  Cleansing
//
//  Created by United It Services on 13/10/23.
//

import UIKit

class CheckListTVC: UITableViewCell {

    
    
//    @IBOutlet weak var checkSV: UIStackView!
    @IBOutlet weak var firstView: UIView!
//    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var firstLabel: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!
    
//    @IBOutlet weak var secondButton: UIButton!
//    @IBOutlet weak var secondLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        firstView.dropShadowWithBlackColor()
//        secondView.dropShadowWithBlackColor()
//        secondView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
