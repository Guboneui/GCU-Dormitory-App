//  GetCommentRequest.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.

struct GetCommentRequest: Encodable {
    var curUser: String
    var article_no: Int
}
