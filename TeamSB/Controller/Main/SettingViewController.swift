//
//  SettingViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import Alamofire

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postUser()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "설정"
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.tabBar.isHidden = true
    }
    

    
    func postUser() {
        let URL = "http://13.209.10.30:3000/getUser"
        let userID = UserDefaults.standard.string(forKey: "userID")!
        
        let PARAM: Parameters = [
            "id": userID
        ]
        
        let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200...500)
        
        alamo.responseJSON{ [self](response) in
            
            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    print(">> \(URL)")
                    print(">> 유저 상세 조회 API 호출 성공")
                    
                    let result = jsonObj.object(forKey: "check") as! Bool
                    
                    if result == true {
                        let message = jsonObj.object(forKey: "message") as! String
                        print(">> \(message)")
                        
                        let content = jsonObj.object(forKey: "content") as! NSArray
                        
                        print(">> 사용자의 정보를 호출합니다.")
                        print(content)
                        
                        
                        
                        
                        
                    } else {
                        let message = jsonObj.object(forKey: "message") as! String
                        
                        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                }
                
                
                
            case .failure(let error) :
                if let jsonObj = error as? NSDictionary {
                    print("서버통신 실패")
                    print(error)
                }
            }
        }
    }
    
    
    
}
