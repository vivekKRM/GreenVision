//
//  AdminInviteTVC.swift
//  Cleansing
//
//  Created by UIS on 16/11/23.
//

import UIKit

class AdminInviteTVC: UITableViewCell {

    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var inviteLabel: UILabel!
    @IBOutlet weak var inviteBtn: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topView.dropShadowWithBlackColor()
        inviteBtn.roundedButton()
        inviteBtn.backgroundColor = UIColor.init(hexString: "3CDACA")
        bottomView.addTopRoundedCorner(radius: 10)
        inviteBtn.setTitle("Invite".localizeString(string: lang), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
