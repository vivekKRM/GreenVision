//
//  TaskListTVC.swift
//  Cleansing
//
//  Created by United It Services on 26/10/23.
//

import UIKit

class TaskListTVC: UITableViewCell {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topName: UILabel!
    @IBOutlet weak var topDate: UILabel!
    @IBOutlet weak var checkType: UILabel!
    @IBOutlet weak var checkTypeView: UIView!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var manualgpsBtn: UIButton!
    @IBOutlet weak var breakDuration: UILabel!
    @IBOutlet weak var headNameView: UIView!
    @IBOutlet weak var headName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        topView.dropShadowWithBlackColor()
//        headNameView.dropShadowWithBlackColor()
        headNameView.dropShadowWithBlackColor()
        checkTypeView.dropShadowWithBlackColor()
        let cornerRadius = headNameView.frame.width / 2.0
        // Apply the corner radius to make it circular
        headNameView.layer.cornerRadius = cornerRadius
        headNameView.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
