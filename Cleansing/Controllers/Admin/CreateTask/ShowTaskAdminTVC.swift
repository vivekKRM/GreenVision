//
//  ShowTaskAdminTVC.swift
//  Cleansing
//
//  Created by UIS on 08/11/23.
//

import UIKit

class ShowTaskAdminTVC: UITableViewCell {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var taskDate: UILabel!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskAddress: UILabel!
    @IBOutlet weak var taskStatus: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var checkListCount: UILabel!
    @IBOutlet weak var notesCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topView.dropShadowWithBlackColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
