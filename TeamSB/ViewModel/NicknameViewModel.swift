//
//  NicknameViewModel.swift
//  TeamSB
//
//  Created by 구본의 on 2021/09/01.
//

import Foundation

class NicknameViewModel {
    
    let nicknameUseService = NicknameUseService()
    
    var showAlert: (_ message: String) -> Void = {_ in }
    var stopLoading: () -> Void = {}
    var setUserNickname: () -> Void = {}
    var setMainView: () -> Void = {}
    var useButton: () -> Void = {}
    var showAlertDismissKeyboard: (_ message: String) -> Void = {_ in }
    
    func postNicknameCheck(_ parameters: NicknameCheckRequest) {
        nicknameUseService.postNicknameCheck(parameters, onCompleted: { [weak self] model in
            guard let self = self else {return}
            self.stopLoading()
            if model.isSuccess == true {
                print(">>😎 닉네임 중복 체크 성공")
                self.showAlertDismissKeyboard(model.message)
                UserDefaults.standard.set(true, forKey: "userNicknameExist")
                self.useButton()
            } else {
                print(">>😭 닉네임 중복 체크 실패")
                self.showAlertDismissKeyboard(model.message)
            }
        }, onError: { _ in
            self.stopLoading()
            self.showAlert("네트워크를 확인 해주세요😭")
        })
    }
    
    func postNicknameSet(_ parameters: NicknameSetRequest) {
        nicknameUseService.postNicknameSet(parameters, onCompleted: { [weak self] model in
            guard let self = self else {return}
            self.setMainView()
            if model.isSuccess == true {
                print(">>😎 닉네임 설정 성공")
                self.setMainView()
                self.setUserNickname()
            } else {
                print(">>😭 닉네임 설정 실패")
                self.showAlert(model.message)
            }
        }, onError: { _ in
            self.stopLoading()
            self.showAlert("네트워크를 확인 해주세요😭")
        })
    }
}
