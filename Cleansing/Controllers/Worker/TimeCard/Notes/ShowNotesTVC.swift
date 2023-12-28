//
//  ShowNotesTVC.swift
//  Cleansing
//
//  Created by United It Services on 04/09/23.
//

import UIKit

class ShowNotesTVC: UITableViewCell {

    @IBOutlet weak var notesDate: UILabel!
    @IBOutlet weak var notesTitle: UILabel!
    @IBOutlet weak var viewBtn: UIButton!
    @IBOutlet weak var showNotesCV: UICollectionView!
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    
    
    var section: Int = 0
    var row: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        personImage.layer.cornerRadius = 10
        personImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
