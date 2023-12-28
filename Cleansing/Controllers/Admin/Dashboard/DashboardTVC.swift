//
//  DashboardTVC.swift
//  Cleansing
//
//  Created by United It Services on 22/08/23.
//

import UIKit

class DashboardTVC: UITableViewCell {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var dashImage: UIImageView!
    @IBOutlet weak var dashTitle: UILabel!
    @IBOutlet weak var dashCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topView.dropShadowWithBlackColor()
        topView.backgroundColor = .white
        dashImage.layer.masksToBounds = true
        dashImage.layer.cornerRadius = dashImage.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
