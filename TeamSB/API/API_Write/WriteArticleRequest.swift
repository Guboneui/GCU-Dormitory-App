//  WriteArticleRequest.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.

import Foundation

struct WriteArticleRequest: Encodable {
    var title: String
    var category: String
    var userId: String
    var text: String
    var hash: [String]?
    
}
