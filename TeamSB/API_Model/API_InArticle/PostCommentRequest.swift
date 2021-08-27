//  PostCommentRequest.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.


struct PostCommentRequest: Encodable {
    var article_no: Int
    var content: String
    var curUser: String
}
