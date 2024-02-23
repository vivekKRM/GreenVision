//
//  AdminDashTVC.swift
//  Cleansing
//
//  Created by uis on 10/01/24.
//

import UIKit

class AdminDashTVC: UITableViewCell {

    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var leftTitle: UILabel!
    @IBOutlet weak var leftValue: UILabel!
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var rightTitle: UILabel!
    @IBOutlet weak var rightValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftView.dropShadowWithBlackColor()
        rightView.dropShadowWithBlackColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
