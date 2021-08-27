//
//  GetProfileImageResponse.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/08.
//

struct GetProfileImageResponse: Decodable {
    var check: Bool
    var code: Int
    var message: String
    var content: String
}
