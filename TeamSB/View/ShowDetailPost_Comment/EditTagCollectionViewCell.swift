//
//  EditTagCollectionViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/08.
//

import UIKit

class EditTagCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tagRoundView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        tagRoundView.layer.cornerRadius = tagRoundView.frame.height / 2
        tagRoundView.backgroundColor = UIColor.SBColor.SB_BaseYellow
        tagLabel.layer.cornerRadius = 10
        tagLabel.layer.masksToBounds = true
        tagLabel.textColor = UIColor.SBColor.SB_LightGray
    }

}
