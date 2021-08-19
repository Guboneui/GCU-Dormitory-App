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
            .responseDecodable(of: GetUserInfoResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">> URL: \(ConstantURL.BASE_URL)/getUser")
                    if response.check == true, let result = response.content {
                        let data = result[0]
                        view.settingNickname(nickname: data.nickname)
                        
                    } else {
                        print(">> 유저 정보 가져오기 실패")
                    }
                case .failure(let error):
                    print(">> URL: \(ConstantURL.BASE_URL)/getUser")
                    print(">> \(error.localizedDescription)")
            }
        }
    }
    
    func postChangeProfileImage(_ parameters: ChangeProfileImageRequest, viewController: EditProfileViewViewController) {
        AF.request("\(ConstantURL.BASE_URL)/profileSet", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: ChangeProfileImageResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">> URL: \(ConstantURL.BASE_URL)/profileSet")
                    if response.check == true {
                        //viewController.presentAlert(title: "프로필 이미지 변경 성공")
                        view.dismissProfileView()
                    } else {
                        print(">> 프로필 이미지 변경 실패")
                        viewController.presentAlert(title: response.message)
                    }
                case .failure(let error):
                    print(">> URL: \(ConstantURL.BASE_URL)/profileSet")
                    print(">> \(error.localizedDescription)")
            }
        }
    }
    
    func postChangeNickname(_ parameters: ChangeUserNicknameRequest, viewController: ChangeNicknameViewController) {
        AF.request("\(ConstantURL.BASE_URL)/nicknameSet", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: ChangeUserNicknameResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">> URL: \(ConstantURL.BASE_URL)/nicknameSet")
                    if response.check == true {
                        print("닉네임 변경 성공")
                        view.successChangeNickname()
                    } else {
                        print(">> 닉네임 변경 실패")
                        viewController.presentAlert(title: response.message)
                        
                    }
                case .failure(let error):
                    print(">> URL: \(ConstantURL.BASE_URL)/nicknameSet")
                    print(">> \(error.localizedDescription)")
                    print(error)
            }
        }
    }
    
    func removeFcmToken(_ parameters: RemoveFcmTokenRequest, viewController: SettingViewController) {
        AF.request("\(ConstantURL.BASE_URL)/deleteToken", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: RemoveFcmTokenResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">> URL: \(ConstantURL.BASE_URL)/deleteToken")
                    if response.check == true {
                        print("토큰 제거 성공")
                        
                    } else {
                        print(">> 토큰 제거 실패")
                        viewController.presentAlert(title: response.message)
                        
                    }
                case .failure(let error):
                    print(">> URL: \(ConstantURL.BASE_URL)/deleteToken")
                    print(">> \(error.localizedDescription)")
                    print(error)
            }
        }
    }
    
    
    func removeUserProfile(_ parameters: DeleteUserProfileImageRequest, viewController: SettingViewController) {
        AF.request("\(ConstantURL.BASE_URL)/profileSet/delete", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: DeleteUserProfileImageResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">> URL: \(ConstantURL.BASE_URL)/profileSet/delete")
                    if response.check == true {
                        print(">> 프로필 이미지 삭제 성공")
                        UserDefaults.standard.set("", forKey: "userProfileImage")
                        viewController.presentAlert(title: "프로필이 수정되었습니다.")
                        viewController.getProfileImage()
                    } else {
                        print(">> 프로필 이미지 삭제 실패")
                        viewController.presentAlert(title: response.message)
                        
                    }
                case .failure(let error):
                    print(">> URL: \(ConstantURL.BASE_URL)/profileSet/delete")
                    print(">> \(error.localizedDescription)")
                    print(error)
            }
        }
    }
    
    
    func postFeedback(_ parameters: FeedbackReqeust, viewController: SettingViewController) {
        AF.request("\(ConstantURL.BASE_URL)/feedback", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: FeedbackResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">> URL: \(ConstantURL.BASE_URL)/feedback")
                    if response.check == true {
                        print("피드백 전달 성공")
                        viewController.presentAlert(title: "🥰소중한 의견 감사합니다🥰")
                    } else {
                        print(">> 피드백 전송 실패")
                        viewController.presentAlert(title: response.message)
                        
                    }
                case .failure(let error):
                    print(">> URL: \(ConstantURL.BASE_URL)/feedback")
                    print(">> \(error.localizedDescription)")
                    print(error)
            }
        }
    }
    
    
    
}

