//
//  GetBannerResponse.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/17.

struct GetBannerResponse: Decodable {
    var check: Bool
    var code: Int
    var topBannerList: [String]
}
