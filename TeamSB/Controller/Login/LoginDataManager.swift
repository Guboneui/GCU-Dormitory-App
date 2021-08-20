//  LoginDataManager.swift
//  TeamSB
//  Created by 구본의 on 2021/07/29.

import Foundation
import Alamofire

class LoginDataManager {
    
    private let view: LoginView
    
    init(view: LoginView){
        self.view = view
    }
    
    func postLogin(_ parameters: LoginRequest, viewController: LoginViewController) {
        AF.request("\(ConstantURL.BASE_URL)/login", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: LoginResponse.self) { [self] response in
                switch response.result {
                
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/login")
                    view.stopLoading()
                    if response.check == true {
                        print(">>😎 로그인 성공")
                        if response.nickname! {
                            view.goMainView()

                        } else {
                            view.goNicknameView()
                        }
                        view.checkAutoLogin()
                        view.addUserInfo(nicknameExist: response.nickname!)
                    } else {
                        print(">>😭 로그인 실패")
                        view.showAlert(message: response.message)
                    }
                case .failure(let error):
                    view.stopLoading()
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/login")
                    print(">>😱 \(error.localizedDescription)")
                    print(">>😱 \(error)")
            }
        }
    }
}
