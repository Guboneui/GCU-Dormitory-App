//
//  ParcelCollectionViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/08.
//

import UIKit

class ParcelCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tagLabel0: UILabel!
    @IBOutlet weak var tagLabel1: UILabel!
    @IBOutlet weak var tagLabel2: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configDesign()
    }
    
    func configDesign() {
        baseView.layer.cornerRadius = 5
        baseView.layer.borderWidth = 2
        baseView.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.layer.borderWidth = 0.25
        profileImage.layer.borderColor = UIColor.SBColor.SB_DarkGray.cgColor
    }

}
