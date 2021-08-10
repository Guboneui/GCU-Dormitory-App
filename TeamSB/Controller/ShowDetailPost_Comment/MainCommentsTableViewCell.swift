//
//  MainCommentsTableViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/27.
//

import UIKit

class MainCommentsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //baseView.backgroundColor = UIColor.SBColor.SB_BaseYellow
        
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 20, bottom: 13, right: 20))
//    }
    
}
