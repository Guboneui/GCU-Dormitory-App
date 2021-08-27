//  SearchRequest.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.

import Foundation

struct SearchRequest: Encodable {
    var category: String
    var keyword: String
}

struct SearchRequestNoCategory: Encodable {
    var keyword: String
}
