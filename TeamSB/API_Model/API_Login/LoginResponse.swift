//  LoginResponse.swift
//  TeamSB
//  Created by 구본의 on 2021/07/29.

struct LoginResponse: Decodable {
    var check: Bool
    var code: Int
    var nickname: Bool?
    var message: String
}
