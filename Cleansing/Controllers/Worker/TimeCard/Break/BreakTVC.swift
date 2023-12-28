//
//  BreakTVC.swift
//  Cleansing
//
//  Created by United It Services on 25/09/23.
//

import UIKit

class BreakTVC: UITableViewCell {
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
