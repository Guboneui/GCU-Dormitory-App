//
//  MainPostTableViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/27.
//

import UIKit

class MainPostTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var adminLabel: UILabel!
    
    @IBOutlet weak var guideLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setDesign()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
//MARK: -기본 UI함수
    func setDesign() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        guideLineView.backgroundColor = UIColor.SBColor.SB_DarkGray
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
