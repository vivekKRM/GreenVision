//
//  ProfileTVC.swift
//  Cleansing
//
//  Created by United It Services on 22/08/23.
//

import UIKit

class ProfileTVC: UITableViewCell {

    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var settingImage: UIImageView!
    @IBOutlet weak var settingText: UILabel!
    
    @IBOutlet weak var langugaeBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settingView.dropShadowWithBlackColor()
//        settingImage.backgroundColor = UIColor(hexString: "ffecb4")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
