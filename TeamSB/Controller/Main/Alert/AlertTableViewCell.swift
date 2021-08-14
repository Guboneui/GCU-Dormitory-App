//
//  AlertTableViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/14.
//

import UIKit

class AlertTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userAlertTextLabel: UILabel!
    @IBOutlet weak var alertTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userProfileImage.layer.cornerRadius = userProfileImage.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
