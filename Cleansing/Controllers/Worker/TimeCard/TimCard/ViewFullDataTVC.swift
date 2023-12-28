//
//  ViewFullDataTVC.swift
//  Cleansing
//
//  Created by uis on 13/12/23.
//

import UIKit

class ViewFullDataTVC: UITableViewCell {

    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var dayNumber: UILabel!
    @IBOutlet weak var breakDuration: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var finishTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topView.dropShadowWithBlackColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
