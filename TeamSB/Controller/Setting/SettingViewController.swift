//
//  SettingViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import Alamofire

class SettingViewController: UIViewController {

    lazy var dataManager: SettingDataManager = SettingDataManager(view: self)
    var userInfo: [UserInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let id = UserDefaults.standard.string(forKey: "userID")!
        let param = GetUserInfoRequest(id: id)
        dataManager.postSearch(param, viewController: self)
        
        DispatchQueue.global().asyncAfter(deadline: .now()+3, execute: { [self] in
            let data = userInfo[0]
            print(data.id)
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "설정"
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.tabBar.isHidden = true
    }
   
}

//MARK: -스토리보드 액션 함수
extension SettingViewController {
    @IBAction func logOutAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "로그아웃 하시겠어요?", message: "", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: {_ in
            let storyBoard = UIStoryboard(name: "Login", bundle: nil)
            let loginVC = storyBoard.instantiateViewController(identifier: "LoginNavigationVC")
            
            UserDefaults.standard.set(nil, forKey: "userID")
            UserDefaults.standard.set(nil, forKey: "userNicknameExist")
            UserDefaults.standard.set(nil, forKey: "userNickname")
            UserDefaults.standard.set(false, forKey: "autoLoginState")
            
            self.changeRootViewController(loginVC)
            
        })
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

extension SettingViewController: SettingView {
    
}
