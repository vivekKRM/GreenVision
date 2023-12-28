//
//  TimeCardTVC.swift
//  Cleansing
//
//  Created by United It Services on 04/09/23.
//

import UIKit

class TimeCardTVC: UITableViewCell {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topName: UILabel!
    @IBOutlet weak var topDate: UILabel!
    @IBOutlet weak var checkType: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var routeBtn: UIButton!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var carLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topView.dropShadowWithBlackColor()
        detailsBtn.roundedButton()
        routeBtn.roundedButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
