//  MyPostContract.swift
//  TeamSB
//  Created by 구본의 on 2021/08/10.

protocol MyPostView {
    func stopRefreshControl()
    func startLoading()
    func stopLoading()
    func goArticle()
}
