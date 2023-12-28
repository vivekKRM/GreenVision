//
//  MyWorkerTVC.swift
//  Cleansing
//
//  Created by United It Services on 30/08/23.
//

import UIKit

class MyWorkerTVC: UITableViewCell {
    
    @IBOutlet weak var workerName: UILabel!
    @IBOutlet weak var workerDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
