//
//  GetGuideResponse.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/19.

struct GetGuideResponse: Decodable {
    var check: Bool
    var code: Int
    var massage: String?
    var content: [GuideList]?
}

struct GuideList: Decodable {
    var guide_no: Int
    var title: String
    var content: String
    var timeStamp: String
}
