//
//  SearchButtonTableViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit

class SearchButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchImage: UIImageView!
    @IBOutlet weak var searchLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configureDesign() {
        searchButton.layer.cornerRadius = 10
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
        searchImage.tintColor = UIColor.SBColor.SB_LightGray
        searchLabel.textColor = UIColor.SBColor.SB_LightGray
        
    }
}
