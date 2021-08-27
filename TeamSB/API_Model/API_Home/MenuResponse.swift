//  MenuResponse.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.

struct MenuResponse: Decodable {
    var check: Bool
    var code: Int
    var menu: [Menu]?
}

struct Menu: Decodable {
    var 일자: String
    var 아침: [[String]] = [[]]
    var 점심: [[String]] = [[]]
    var 저녁: [[String]] = [[]]
}


