//
//  LoginUseService.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/27.
//

import Foundation

class LoginUseService {
    let repository: LoginRepository = LoginRepository()
    var loginModel: LoginModel = LoginModel(isSuccess: false, existNickname: false, message: "")
    
    func postLogin(_ parameters: LoginRequest, onCompleted: @escaping (LoginModel) -> Void) {
        repository.postLogin(parameters, onCompleted: {[weak self] response in
            let data = LoginModel(isSuccess: response.check,existNickname: response.nickname, message: response.message)
            self?.loginModel = data
            onCompleted(data)
        })
    }
}
