//
//  EditArticleResponse.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/08.
//

import Foundation

struct EditArticleResponse: Decodable {
    var check: Bool
    var code: Int
    var message: String
}
