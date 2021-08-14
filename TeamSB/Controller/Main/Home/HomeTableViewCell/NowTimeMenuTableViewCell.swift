//
//  NotTimeMenuTableViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import Alamofire


class NowTimeMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var yellowBaseView: UIView!
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
        
        yellowBaseView.layer.cornerRadius = 10
        baseView.layer.cornerRadius = 10
        //baseView.layer.borderWidth = 0.5
        baseView.layer.borderColor = UIColor.SBColor.SB_DarkGray.cgColor
    }
    
//MARK: -API

}
