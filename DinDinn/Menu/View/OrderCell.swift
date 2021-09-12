//
//  OrderCell.swift
//  DinDinn
//
//

import UIKit

class OrderCell: UITableViewCell {
    @IBOutlet var menuImage : UIImageView!
    @IBOutlet var menuLabel : UILabel!
    @IBOutlet var menuRate : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
