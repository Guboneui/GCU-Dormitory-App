//  NicknameConstract.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.

import Foundation

protocol NicknameView {
    func showAlert(message: String)
    func stopLoading()
    func setUserNickname()
    func setMainView()
}
