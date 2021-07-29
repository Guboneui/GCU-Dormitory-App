//  GetUserInfoResponse.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.

struct GetUserInfoResponse: Decodable {
    var check: Bool
    var code: Int
    var message: String
    var content: [UserInfo]?
}

struct UserInfo: Decodable {
    var no: Int
    var id: String
    var user_no: String
    var certified: Int
    var nickname: String
    var article_count: Int
}

