//
//  WriteContract.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/30.
//

import Foundation

protocol WriteView {
    func popView(message: String)
    func showAlert(message: String)
    func stopLoading()
}
