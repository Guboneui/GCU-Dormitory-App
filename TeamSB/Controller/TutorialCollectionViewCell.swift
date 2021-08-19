//
//  TutorialCollectionViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/20.
//

import UIKit

class TutorialCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var tutorialImage: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    var pages = [Page(imageName: "tutorial_home", last: true), Page(imageName: "tutorial_post", last: true), Page(imageName: "tutorial_search", last: false)]
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.layer.cornerRadius = 5
        baseView.backgroundColor = UIColor.SBColor.SB_BaseYellow
        
        
        
    }
    
    public func configure(index: Int){
        let page: Page = pages[index]
        
        tutorialImage.image = UIImage(named: page.imageName)
        
        
        
        baseView.isHidden = page.last
        startLabel.isHidden = page.last
        startButton.isHidden = page.last
        startButton.isEnabled = !page.last
    }
    
    

}
