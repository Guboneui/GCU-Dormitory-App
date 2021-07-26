//
//  MainPostTableViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/27.
//

import UIKit

class MainPostTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var adminLabel: UILabel!
    
    @IBOutlet weak var contentsTextView: UITextView!
    
    @IBOutlet weak var guideLineView: UIView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        contentsTextView.isEditable = false
        contentsTextView.isScrollEnabled = false
        
        contentsTextView.layer.cornerRadius = 1
        //contentsTextView.layer.borderWidth = 1
        //contentsTextView.layer.borderColor = UIColor.SBColor.SB_LightGray.cgColor
        
        guideLineView.backgroundColor = UIColor.SBColor.SB_DarkGray
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension UITableViewCell {
    /// Search up the view hierarchy of the table view cell to find the containing table view
    var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }

            return table as? UITableView
        }
    }
}
