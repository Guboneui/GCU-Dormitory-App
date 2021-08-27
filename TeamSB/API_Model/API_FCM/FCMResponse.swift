//
//  FCMResponse.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/12.
//

import Foundation

struct FCMResponse: Decodable {
    var check: Bool
    var code: Int
    var message: String
}
