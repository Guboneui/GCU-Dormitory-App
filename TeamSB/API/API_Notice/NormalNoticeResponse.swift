//
//  NormalNoticeResponse.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/15.

struct NormalNoticeResponse: Decodable {
    var check: Bool
    var code: Int
    var message: String
    var content: [NormalNotice]?
}

struct NormalNotice: Decodable {
    var notice_no: Int
    var title: String
    var content: String
    var viewCount: Int
    var timeStamp: String
    var fixTop: Bool
}
