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

extension SettingViewController: SettingView {
    
}
