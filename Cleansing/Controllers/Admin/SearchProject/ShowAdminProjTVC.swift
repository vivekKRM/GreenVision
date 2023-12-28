//
//  ShowAdminProjTVC.swift
//  Cleansing
//
//  Created by UIS on 06/11/23.
//

import UIKit

class ShowAdminProjTVC: UITableViewCell {

    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var projectLocation: UILabel!
    @IBOutlet weak var projectTime: UILabel!
    @IBOutlet weak var projectEditBtn: UIButton!
    @IBOutlet weak var projectCost: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topView.dropShadowWithBlackColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
