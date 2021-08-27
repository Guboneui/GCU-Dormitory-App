//
//  NoticeMainTableViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/15.
//

import UIKit
import ExpyTableView

class NoticeMainTableViewCell: UITableViewCell, ExpyTableViewHeaderCell {
   
    

    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dropImage: UIImageView!
    
    @IBOutlet weak var topStateImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.layer.borderWidth = 1.5
        mainView.layer.borderColor = UIColor.SBColor.SB_BaseYellow.cgColor
        mainView.layer.cornerRadius = 4
        
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func changeState(_ state: ExpyState, cellReuseStatus cellReuse: Bool) {
        //print("main-notice - state: \(state)")
        
        
        
        switch  state {
        case .willExpand:
            //print("펼쳐질 예정")
            self.arrowDown(animated: false)
        case .willCollapse:
            //print("접힐 예정")
            self.arrowUp(animated: false)
        case .didExpand:
            
            break
        case .didCollapse:
            break
        }
    }
    
    fileprivate func arrowDown(animated: Bool) {
        UIView.animate(withDuration: (animated ? 0.3 : 0), animations: {
            self.dropImage.transform = CGAffineTransform(rotationAngle: (CGFloat.pi))
        })
        self.background.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
    }
    
    fileprivate func arrowUp(animated: Bool) {
        UIView.animate(withDuration: (animated ? 0.3 : 0), animations: {
            self.dropImage.transform = CGAffineTransform(rotationAngle: 0)
        })
        self.background.backgroundColor = .white
    }
    
}
