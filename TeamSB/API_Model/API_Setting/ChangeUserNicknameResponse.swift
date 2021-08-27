//
//  ChangeUserNicknameResponse.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/07.
//

import Foundation

struct ChangeUserNicknameResponse: Decodable{
    var check: Bool
    var code: Int
    var message: String
}
