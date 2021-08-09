//
//  EditArticleRequest.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/08.
//

struct EditArticleRequest: Encodable {
    var curUser: String
    var title: String
    var category: String
    var text: String
    var hash: [String]
    var no: Int
}
