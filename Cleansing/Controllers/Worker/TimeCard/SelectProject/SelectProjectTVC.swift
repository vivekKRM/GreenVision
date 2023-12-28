//
//  SelectProjectTVC.swift
//  Cleansing
//
//  Created by United It Services on 27/10/23.
//

import UIKit

class SelectProjectTVC: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskLocation: UILabel!
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

