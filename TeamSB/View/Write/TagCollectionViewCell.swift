//
//  TagCollectionViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/25.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tagRoundView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tagRoundView.layer.cornerRadius = tagRoundView.frame.height / 2
        tagRoundView.backgroundColor = UIColor.SBColor.SB_BaseYellow
        //tagLabel.layer.cornerRadius = 10
        tagLabel.layer.masksToBounds = true
        tagLabel.textColor = UIColor.white
        
        tagLabel.font = UIFont.boldSystemFont(ofSize: 13)
        
    }
}
