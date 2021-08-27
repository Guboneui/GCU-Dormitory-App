//
//  UserAlertResponse.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/14.
//

struct UserAlertResponse: Decodable {
    var check: Bool
    var code: Int
    var message: String
    var content: [AlertContent]?
    
}

struct AlertContent: Decodable {
    var notification_no: Int
    var article_no: Int
    var userId: String
    var curUser: String
    var nickname: String
    var title: String
    var content: String
    var check_read: Bool
    var timeStamp: String
    var imageSource: String
}

