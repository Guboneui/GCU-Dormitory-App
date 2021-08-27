//
//  FeedbackResponse.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/19.

struct FeedbackResponse: Decodable {
    var check: Bool
    var code: Int
    var message: String
}
