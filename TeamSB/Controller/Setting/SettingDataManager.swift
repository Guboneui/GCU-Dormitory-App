//  SettingDataManager.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.

import Foundation
import Alamofire

class SettingDataManager {
    
    private let view: SettingView
    
    init(view: SettingView){
        self.view = view
    }
    
    func postSearch(_ parameters: GetUserInfoRequest, viewController: SettingViewController) {
        AF.request("\(ConstantURL.BASE_URL)/getUser", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: GetUserInfoResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print(">>URL: \(ConstantURL.BASE_URL)/getUser")
                    if response.check == true{
                        viewController.userInfo = response.content!
                        
                    } else {
                        print(">> 유저 정보 가져오기 실패")
                    }
                case .failure(let error):
                    print(">>URL: \(ConstantURL.BASE_URL)/getUser")
                    print(">> \(error.localizedDescription)")
            }
        }
    }
}

