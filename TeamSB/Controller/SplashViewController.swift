//
//  SplashViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/19.
//

import UIKit

class SplashViewController: UIViewController {

    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.image = UIImage(named: "splashLogo")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.backgroundColor = .white
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            self.animate()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
    }
    
    private func animate() {
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 2
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            
            self.imageView.frame = CGRect(x: -(diffX / 2), y: diffY / 2, width: size, height: size)
            
        })
        
        UIView.animate(withDuration: 1.25, animations: {
            self.imageView.alpha = 0
        }, completion: { [self] done in
            if done {
                
               
                
                if UserDefaults.standard.bool(forKey: "autoLoginState") == false {
                    let storyBoard = UIStoryboard(name: "Login", bundle: nil)
                    let loginVC = storyBoard.instantiateViewController(identifier: "LoginNavigationVC")
                    self.changeRootViewController(loginVC)

                } else {
                    if UserDefaults.standard.bool(forKey: "userNicknameExist") == false {
                        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
                        let nicknameVC = storyBoard.instantiateViewController(identifier: "NickNameViewController")
                        self.changeRootViewController(nicknameVC)

                    } else {
                        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                        let homeVC = storyBoard.instantiateViewController(identifier: "MainVC")
                        self.changeRootViewController(homeVC)
                    }
                }
            }
            
        })
    }
}
