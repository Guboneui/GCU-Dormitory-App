//
//  MyPostCollectionViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/10.
//

import UIKit

class MyPostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
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
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
    }

}
