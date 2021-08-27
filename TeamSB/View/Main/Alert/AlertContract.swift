//
//  AlertContract.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/14.
//

protocol AlertView {
    func stopRefreshControl()
    func startLoading()
    func stopLoading()
    func goArticle(no: Int, title: String, category: String, timeStamp: String, userNickname: String, text: String, viewCount: Int, userId: String, hash: [String], imageSource: String)
    func reloadTableview()
}
