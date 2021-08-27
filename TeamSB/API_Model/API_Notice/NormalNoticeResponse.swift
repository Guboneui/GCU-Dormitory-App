//
//  NormalNoticeResponse.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/15.

struct NormalNoticeResponse: Decodable {
    var check: Bool
    var code: Int
    var message: String
    var content: [TopNotice]?
}
