//
//  AdminCrewTVC.swift
//  Cleansing
//
//  Created by UIS on 16/11/23.
//

import UIKit

class AdminCrewTVC: UITableViewCell {
    
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var activeView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectView.dropShadowWithBlackColor()
//        activeView.dropShadowWithBlackColor()
        activeView.layer.masksToBounds = true
        activeView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
