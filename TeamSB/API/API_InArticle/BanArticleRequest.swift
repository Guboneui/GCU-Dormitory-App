//  BanArticleRequest.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.

struct BanArticleRequest: Encodable {
    var curUser: String
    var article_no: Int
    var content: String
}
