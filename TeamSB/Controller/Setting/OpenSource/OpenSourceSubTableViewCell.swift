//
//  OpenSourceSubTableViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/19.
//

import UIKit

class OpenSourceSubTableViewCell: UITableViewCell {

    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var contentsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        linkButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
