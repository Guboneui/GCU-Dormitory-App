//
//  RemoveFcmTokenResponse.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/15.

struct RemoveFcmTokenResponse: Decodable {
    var check: Bool
    var code: Int
    var message: String
}
