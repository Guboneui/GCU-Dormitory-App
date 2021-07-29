//  ParcelResponse.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.

import Foundation

struct ParcelResponse: Decodable {
    var check: Bool
    var code: Int
    var message: String
    var content: [Parcel]?
}

struct Parcel: Decodable {
    var no: Int
    var title: String
    var category: String
    var timeStamp: String
    var mod_timeStamp: String
    var userId: String
    var userNickname: String
    var text: String
    var viewCount: Int
    var reportCount: Int
    var hash: [String]
}
