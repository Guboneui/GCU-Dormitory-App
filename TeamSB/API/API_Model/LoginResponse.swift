//
//  LoginResponse.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/11.
//

import Foundation
import ObjectMapper

class LoginResponse: Mappable {
    var check: Bool?
    var code: Int?
    var id: String?
    var password: String?
    var nickname: Bool?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        check <- map["check"]
        code <- map["code"]
        id <- map["id"]
        password <- map["password"]
        nickname <- map["nickname"]
    }
    
}
