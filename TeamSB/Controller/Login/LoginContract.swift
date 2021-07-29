//
//  LoginContract.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/29.
//

import Foundation

protocol LoginView {
    func goNicknameView()
    func goMainView()
    func checkAutoLogin()
    func addUserInfo(nicknameExist: Bool)
    func showAlert(message: String)
    func stopLoading()
}
