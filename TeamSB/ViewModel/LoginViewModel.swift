//
//  LoginViewModel.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/27.
//

import Foundation


class LoginViewModel {
    var onUpdated: () -> Void = {}
    var viewController: LoginViewController = LoginViewController()
    //var delegate: showAlert!
    let loginUseService = LoginUseService()
    
    private let view: LoginView!
    init(view: LoginView){
        self.view = view
    }
    
//    var goNicknameView: () -> Void = {}
//    var goMainView: () -> Void = {}
//    var checkAutoLogin: () -> Void = {}
//    var addUserInfo: (_ nicknameExist: Bool) -> Void = {_ in }
//    var showAlert: (_ message: String) -> Void = {_ in }
//    var stopLoading: () -> Void = {}

    var test: () -> Void = {}
    func postLogin(_ parameters: LoginRequest){
        loginUseService.postLogin(parameters, onCompleted: { [weak self] model in
            guard let self = self else {return}
            let existNickname = model.existNickname
            let message = model.message
            self.view.stopLoading()
            if model.isSuccess == true {
                if existNickname == false {
                    print("닉네임 설정이 필요합니다.")
                    self.view.goNicknameView()
                } else {
                    print("홈화면으로 이동합니다.")
                    self.view.goMainView()
                }
                self.view.checkAutoLogin()
                self.view.addUserInfo(nicknameExist: existNickname!)
            } else {
                print(message)
                self.view.showAlert(message: message)
            }
        }, onError: {_ in
            self.view.stopLoading()
            self.view.showAlert(message: "네트워크를 확인 해주세요😭")
        })
    }
}
