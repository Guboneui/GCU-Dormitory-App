//
//  NicknameUseService.swift
//  TeamSB
//
//  Created by 구본의 on 2021/09/01.
//

import Foundation

class NicknameUseService {
    let repository: NickNameRepository = NickNameRepository()
    var nicknameCheckModel: NicknameCheckModel = NicknameCheckModel(isSuccess: false, message: "")
    var nicknameSetModel: NicknameSetModel = NicknameSetModel(isSuccess: false, message: "")
    
    func postNicknameCheck(_ parameters: NicknameCheckRequest, onCompleted: @escaping (NicknameCheckModel) -> Void, onError: @escaping (String) -> Void) {
        repository.postNicknameCheck(parameters, onCompleted: { [weak self] response in
            let data = NicknameCheckModel(isSuccess: response.check, message: response.message)
            self?.nicknameCheckModel = data
            onCompleted(data)
        }, onError: onError)
    }
    
    func postNicknameSet(_ parameters: NicknameSetRequest, onCompleted: @escaping (NicknameSetModel) -> Void, onError: @escaping (String) -> Void) {
        repository.postNicknameSet(parameters, onCompleted: { [weak self] response in
            let data = NicknameSetModel(isSuccess: response.check, message: response.message)
            self?.nicknameSetModel = data
            onCompleted(data)
        }, onError: onError)
    }
}
