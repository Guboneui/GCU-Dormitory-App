//
//  MenuTableViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/25.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var subMenuLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDesign() {
//        menuLabel.layer.cornerRadius = 10
//        menuLabel.layer.borderWidth = 0.8
//        menuLabel.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
    }
    
}
