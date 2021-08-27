//
//  ReadNoticeRequest.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/14.

struct ReadNoticeRequest: Encodable {
    var curUser: String
    var notification_no: Int
}
