//  WriteArticleResponse.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.

import Foundation

struct WriteArticleResponse: Decodable {
    var check: String
    var code: Int
    var message: String
}
