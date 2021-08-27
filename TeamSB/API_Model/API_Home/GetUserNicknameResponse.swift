//  GetUserNicknameResponse.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.

struct GetUserNicknameResponse: Decodable {
    var check: Bool
    var code: Int
    var message: String
    var content: String?
}
