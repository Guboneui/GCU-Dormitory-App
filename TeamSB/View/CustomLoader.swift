//
//  CustomLoader.swift
//  TeamSB
//
//  Created by κ΅¬λ³Έμ on 2021/08/20.
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
        print(">>π£ λ‘λ© μμ")
        self.addSubview(transparentView)
        self.transparentView.addSubview(gifImage)
        self.transparentView.bringSubviewToFront(self.gifImage)
        UIApplication.shared.keyWindow?.addSubview(transparentView)
    }
    
    func hideLoader() {
        print(">>π£ λ‘λ© μ’λ£")
        self.transparentView.removeFromSuperview()
    }

}
