//  DetailPostViewContract.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.

protocol DetailPostView {
    func popView(message: String)
    func stopRefreshControl()
    func successPost()
    func updateTableView()
    func reloadPost()
}
