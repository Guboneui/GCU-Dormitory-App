//
//  LoginRepository.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/27.
//

import Foundation
import Alamofire

class LoginRepository {
    
    func postLogin(_ parameters: LoginRequest,onCompleted: @escaping (LoginResponse) -> Void, onError: @escaping (String) -> Void) {
        AF.request("\(ConstantURL.BASE_URL)/login", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/login")
                    onCompleted(response)
                case .failure(let error):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/login")
                    print(">>😱 \(error.localizedDescription)")
                    print(">>😱 \(error)")
                    onError("error")
            }
        }
    }
    
    
}
