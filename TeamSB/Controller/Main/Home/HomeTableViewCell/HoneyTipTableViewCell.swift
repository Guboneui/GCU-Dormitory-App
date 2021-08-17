//
//  HoneyTipTableViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/18.
//

import UIKit

class HoneyTipTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.layer.cornerRadius = 9
        baseView.layer.borderWidth = 3
        baseView.layer.borderColor = #colorLiteral(red: 0.9764705882, green: 0.8549019608, blue: 0.4705882353, alpha: 1)
        
        
        let userText = "더보기"
        let textRange = NSRange(location: 0, length: userText.count)
        let attributedText = NSMutableAttributedString(string: userText)
        attributedText.addAttribute(.underlineStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        showMoreButton.titleLabel!.attributedText = attributedText
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
