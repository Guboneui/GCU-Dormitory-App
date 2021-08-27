//
//  NoticeContract.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/15.
//

protocol NoticeView {
    func stopRefreshControl()
    func startLoading()
    func stopLoading()
    func goArticle()
    func reloadTableView()
}
