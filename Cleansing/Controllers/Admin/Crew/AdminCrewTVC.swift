//
//  AdminCrewTVC.swift
//  Cleansing
//
//  Created by UIS on 16/11/23.
//

import UIKit

class AdminCrewTVC: UITableViewCell {
    
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
