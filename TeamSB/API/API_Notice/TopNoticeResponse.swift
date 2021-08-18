//
//  TopNoticeResponse.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/15.

struct TopNoticeResponse: Decodable {
    var check: Bool
    var code: Int
    var message: String
    var content: [TopNotice]?
}

struct TopNotice: Decodable {
    var notice_no: Int
    var title: String
    var timeStamp: String
    var content: String
    var fixTop: Bool
    var realTop: Bool
    var viewCount: Int
}


