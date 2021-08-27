//  NicknameDataManager.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.

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
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/nicknameCheck")
                    view.stopLoading()
                    if response.check == true {
                        print(">>😎 닉네임 중복 체크 성공")
                        view.showAlertDismissKeyboard(message: response.message)
                        UserDefaults.standard.set(true, forKey: "userNicknameExist")
                        view.useButton()
                    } else {
                        print(">>😭 닉네임 중복 체크 실패")
                        view.showAlertDismissKeyboard(message: response.message)
                    }
                    
                case .failure(let error):
                    view.stopLoading()
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/nicknameCheck")
                    view.showAlert(message: "서버 연결 실패")
                    print(">>😱 \(error.localizedDescription)")
                    print(">>😱 \(error)")
            }
        }
    }
    
    func postNicknameSet(_ parameters: NicknameSetRequest, viewController: NickNameViewController) {
        AF.request("\(ConstantURL.BASE_URL)/nicknameSet", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: NicknameSetResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/nicknameSet")
                    view.stopLoading()
                    if response.check == true {
                        print(">>😎 닉네임 설정 성공")
                        view.setMainView()
                        view.setUserNickname()
                    } else {
                        print(">>😭 닉네임 설정 실패")
                        view.showAlert(message: response.message)
                    }
                    
                case .failure(let error):
                    view.stopLoading()
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/nicknameSet")
                    view.showAlert(message: "서버 연결 실패")
                    print(">>😱 \(error.localizedDescription)")
                    print(">>😱 \(error)")
            }
        }
    }
}
