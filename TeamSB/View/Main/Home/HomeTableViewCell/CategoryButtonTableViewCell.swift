//
//  CategoryButtonTableViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit

class CategoryButtonTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var delevaryButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var taxiButton: UIButton!
    @IBOutlet weak var roommateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.bringSubviewToFront(buttonStackView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
