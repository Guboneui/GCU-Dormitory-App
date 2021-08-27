//
//  CheckUserAlertResponse.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/14.

struct CheckUserAlertResponse: Decodable {
    var check: Bool
    var code: Int
    var message: String
    var notificationCount: Int?
}
