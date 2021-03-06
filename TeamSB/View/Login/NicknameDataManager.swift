//  NicknameDataManager.swift
//  TeamSB
//  Created by κ΅¬λ³Έμ on 2021/07/30.

import Foundation
import Alamofire

class NicknameDataManager {
    
    private let view: NicknameView
    
    init(view: NicknameView) {
        self.view = view
    }
    
    func postNicknameCheck(_ parameters: NicknameCheckRequest, viewController: NickNameViewController) {
        AF.request("\(ConstantURL.BASE_URL)/nicknameCheck", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: NicknameSetResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/nicknameCheck")
                    view.stopLoading()
                    if response.check == true {
                        print(">>π λλ€μ μ€λ³΅ μ²΄ν¬ μ±κ³΅")
                        view.showAlertDismissKeyboard(message: response.message)
                        UserDefaults.standard.set(true, forKey: "userNicknameExist")
                        view.useButton()
                    } else {
                        print(">>π­ λλ€μ μ€λ³΅ μ²΄ν¬ μ€ν¨")
                        view.showAlertDismissKeyboard(message: response.message)
                    }
                    
                case .failure(let error):
                    view.stopLoading()
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/nicknameCheck")
                    view.showAlert(message: "μλ² μ°κ²° μ€ν¨")
                    print(">>π± \(error.localizedDescription)")
                    print(">>π± \(error)")
            }
        }
    }
    
    func postNicknameSet(_ parameters: NicknameSetRequest, viewController: NickNameViewController) {
        AF.request("\(ConstantURL.BASE_URL)/nicknameSet", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: NicknameSetResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/nicknameSet")
                    view.stopLoading()
                    if response.check == true {
                        print(">>π λλ€μ μ€μ  μ±κ³΅")
                        view.setMainView()
                        view.setUserNickname()
                    } else {
                        print(">>π­ λλ€μ μ€μ  μ€ν¨")
                        view.showAlert(message: response.message)
                    }
                    
                case .failure(let error):
                    view.stopLoading()
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/nicknameSet")
                    view.showAlert(message: "μλ² μ°κ²° μ€ν¨")
                    print(">>π± \(error.localizedDescription)")
                    print(">>π± \(error)")
            }
        }
    }
}
