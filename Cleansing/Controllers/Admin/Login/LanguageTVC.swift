//
//  LanguageTVC.swift
//  Cleansing
//
//  Created by uis on 18/01/24.
//

import UIKit

class LanguageTVC: UITableViewCell {

    
    @IBOutlet weak var langBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topView.dropShadowWithBlackColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
//            if selected {
//                langBtn.setImage(UIImage(systemName: "circle.fill"), for: .normal)
//            } else {
//                langBtn.setImage(UIImage(systemName: "circle"), for: .normal)
//            }
        }

}
