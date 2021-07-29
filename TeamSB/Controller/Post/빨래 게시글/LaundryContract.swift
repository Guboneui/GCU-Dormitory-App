//
//  LaundryContract.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/30.

import Foundation

protocol LaundryView {
    func stopRefreshControl()
    func startLoading()
    func stopLoading()
}
