//
//  ShowAdminNotesTVC.swift
//  Cleansing
//
//  Created by UIS on 03/11/23.
//

import UIKit

class ShowAdminNotesTVC: UITableViewCell {

    
    
    @IBOutlet weak var notesDate: UILabel!
    @IBOutlet weak var notesTitle: UILabel!
    @IBOutlet weak var viewBtn: UIButton!
    @IBOutlet weak var showNotesCV: UICollectionView!
    
    var row: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
