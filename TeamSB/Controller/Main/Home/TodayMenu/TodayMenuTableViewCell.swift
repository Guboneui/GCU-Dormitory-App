//
//  TodayMenuTableViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/04.
//

import UIKit

class TodayMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.layer.cornerRadius = 10
        baseView.layer.borderWidth = 1
        baseView.layer.borderColor = UIColor.SBColor.SB_BaseYellow.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
