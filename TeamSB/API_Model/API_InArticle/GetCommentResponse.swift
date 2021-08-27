//  GetCommentResponse.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.

struct GetCommentResponse: Decodable {
    var check: Bool
    var code: Int
    var message: String
    var content: [Comment]?
}

struct Comment: Decodable {
    var reply_no: Int
    var article_no: Int
    var content: String
    var userId: String
    var userNickname: String
    var timeStamp: String
    var mod_timeStamp: String
    var right: Bool
    var imageSource: String
}
