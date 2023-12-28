//
//  SearchTVC.swift
//  surfers
//
//  Created by United It Services on 21/08/23.
//

import UIKit

class SearchTVC: UITableViewCell {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var topName: UILabel!
    @IBOutlet weak var topAmount: UILabel!
    @IBOutlet weak var topDate: UILabel!
    @IBOutlet weak var checkType: PaddingLabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topView.dropShadowWithBlackColor()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
