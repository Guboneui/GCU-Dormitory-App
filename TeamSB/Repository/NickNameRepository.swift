//
//  NickNameRepository.swift
//  TeamSB
//
//  Created by 구본의 on 2021/09/01.
//

import Foundation
import Alamofire

class NickNameRepository {
    
    func postNicknameCheck(_ parameters: NicknameCheckRequest, onCompleted: @escaping (NicknameCheckResponse) -> Void, onError: @escaping (String) -> Void) {
        AF.request("\(ConstantURL.BASE_URL)/nicknameCheck", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: NicknameCheckResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/nicknameCheck")
                    onCompleted(response)
                case .failure(let error):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/nicknameCheck")
                    print(">>😱 \(error.localizedDescription)")
                    print(">>😱 \(error)")
                    onError("error")
            }
        }
    }
    
    func postNicknameSet(_ parameters: NicknameSetRequest, onCompleted: @escaping (NicknameSetResponse) -> Void, onError: @escaping (String) -> Void) {
        AF.request("\(ConstantURL.BASE_URL)/nicknameSet", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: NicknameSetResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/nicknameSet")
                    onCompleted(response)
                case .failure(let error):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/nicknameSet")
                    print(">>😱 \(error.localizedDescription)")
                    print(">>😱 \(error)")
                    onError("error")
                }
            }
    }
}
