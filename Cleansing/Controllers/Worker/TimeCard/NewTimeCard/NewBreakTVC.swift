//
//  NewBreakTVC.swift
//  Cleansing
//
//  Created by United It Services on 25/10/23.
//

import UIKit

class NewBreakTVC: UITableViewCell {

    
    @IBOutlet weak var startTime: UIButton!
    @IBOutlet weak var endTime: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    
        var onBreakStartTapped: (() -> Void)?
        var onBreakEndTapped: (() -> Void)?

        @IBAction func breakStartTapped(_ sender: Any) {
            onBreakStartTapped?()
        }

        @IBAction func breakEndTapped(_ sender: Any) {
            onBreakEndTapped?()
        }

        var onDeleteButtonTapped: (() -> Void)?

        @IBAction func deleteButtonTapped(_ sender: Any) {
            onDeleteButtonTapped?()
        }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
