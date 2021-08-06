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
    @IBOutlet weak var guideLineView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //baseView.backgroundColor = UIColor.SBColor.SB_BaseYellow
        
        guideLineView.backgroundColor = UIColor.SBColor.SB_LightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
