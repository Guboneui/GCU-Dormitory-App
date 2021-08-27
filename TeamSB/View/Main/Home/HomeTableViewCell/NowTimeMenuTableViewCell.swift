//
//  NotTimeMenuTableViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import Alamofire


class NowTimeMenuTableViewCell: UITableViewCell {

    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var subMenuLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureDesign()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

//MARK: -기본 UI함수 정리
    
    func configureDesign() {
        
        baseView.layer.shadowOffset = CGSize(width: 4, height: 4)
        baseView.layer.shadowOpacity = 0.2
        baseView.layer.cornerRadius = 9
        baseView.layer.borderWidth = 3
        baseView.layer.borderColor = #colorLiteral(red: 0.9983385205, green: 0.7219318748, blue: 0, alpha: 1)
    }
    
//MARK: -API

}
