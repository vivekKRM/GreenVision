//
//  ProjectHourTVC.swift
//  Cleansing
//
//  Created by UIS on 07/11/23.
//

import UIKit

class ProjectHourTVC: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        topView.dropShadowWithBlackColor()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
