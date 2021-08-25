//
//  getVersion.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/25.
//

struct getVersionResponse: Decodable {
    var check: Bool
    var code: Int
    var message: String
    var curVersion: String
}
