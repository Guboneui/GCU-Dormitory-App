//
//  CustomLoader.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/20.
//

import UIKit

class CustomLoader: UIView {

    static let instance = CustomLoader()
    
    
    lazy var transparentView: UIView = {
        let transparentView = UIView(frame: UIScreen.main.bounds)
        transparentView.backgroundColor = UIColor.clear
        transparentView.isUserInteractionEnabled = false
        return transparentView
    }()
    
    lazy var gifImage: UIImageView = {
       let gifImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        gifImage.contentMode = .scaleToFill
        gifImage.layer.cornerRadius = gifImage.frame.height / 2
        gifImage.center = transparentView.center
        gifImage.isUserInteractionEnabled = false
        gifImage.loadGif(name: "LoadingGIF")
        return gifImage
    }()
    
    func showLoader() {
        print(">>🐣 로딩 시작")
        self.addSubview(transparentView)
        self.transparentView.addSubview(gifImage)
        self.transparentView.bringSubviewToFront(self.gifImage)
        UIApplication.shared.keyWindow?.addSubview(transparentView)
    }
    
    func hideLoader() {
        print(">>🐣 로딩 종료")
        self.transparentView.removeFromSuperview()
    }

}
