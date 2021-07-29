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
            .responseDecodable(of: LoginResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>URL: \(ConstantURL.BASE_URL)/nicknameCheck")
                    if response.check == true {
                        view.showAlert(message: response.message)
                    } else {
                        view.showAlert(message: response.message)
                    }
                    
                case .failure(let error):
                    view.stopLoading()
                    print(">>URL: \(ConstantURL.BASE_URL)/nicknameCheck")
                    view.showAlert(message: "서버 연결 실패")
                    print(">> \(error.localizedDescription)")
            }
        }
    }
    
    func postNicknameSet(_ parameters: NicknameSetRequest, viewController: NickNameViewController) {
        AF.request("\(ConstantURL.BASE_URL)/nicknameSet", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: LoginResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>URL: \(ConstantURL.BASE_URL)/nicknameSet")
                    view.stopLoading()
                    if response.check == true {
                        view.setMainView()
                        view.setUserNickname()
                    } else {
                        view.showAlert(message: response.message)
                    }
                    
                case .failure(let error):
                    view.stopLoading()
                    print(">>URL: \(ConstantURL.BASE_URL)/nicknameSet")
                    view.showAlert(message: "서버 연결 실패")
                    print(">> \(error.localizedDescription)")
            }
        }
    }
}
