//
//  ChangeUserNickname.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/07.
//

import Foundation


struct ChangeUserNicknameRequest: Encodable {
    var curId: String
    var nickname: String
}
