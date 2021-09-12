//
//  MenuCell.swift
//  DinDinn
//
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet var menuImage : UIImageView!
    @IBOutlet var menuLabel : UILabel!
    @IBOutlet var menuDesc : UILabel!
    @IBOutlet var menuWeight : UILabel!
    @IBOutlet var menuButton : UIButton!
    @IBOutlet var menuCard : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.menuImage.roundCorners([.topRight,.topLeft], radius: 10)
            self.menuImage.layer.masksToBounds = true
//            self.menuCard.backgroundColor = .white
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UIImageView {
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
