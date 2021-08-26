//
//  LaundryContract.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/30.

import Foundation

protocol RoomMateView {
    func stopRefreshControl()
    func startLoading()
    func stopLoading()
    func goArticle()
    func notDate()
}
