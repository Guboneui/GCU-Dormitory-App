//
//  BaseAlamofire.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/11.
//

import Foundation
import UIKit
import Alamofire


class RequestAPI: NSObject {
    static func post(resource:String, param: Dictionary<String, Any>, responseData: String, completion: @escaping (_ result: Bool,_ resultDic: Any)->()){
        var resultData: Any = ()
        
        let hostURL = "13.209.10.30:3000"
        let requestURL = hostURL + resource
        let requestParam: Parameters = param

        let sendRequest = AF.request(requestURL, method: .post, parameters: requestParam, encoding: JSONEncoding.default).validate()
        NSLog("►request start◀︎")
        NSLog("URL: \(requestURL), PARAMETERS: \(requestParam)")
        
        sendRequest.responseJSON() { response in
            switch response.result {
            case .success(let value): //통신만 확인
                completion(true, value)
            case .failure(let error):
                NSLog("►request failed◀︎")
                NSLog("Alamo request failed, error description: \(error)")
                
                if error.isInvalidURLError {
                    NSLog("is Invalid URL")
                }
                completion(false, ["error":error])
            }
        }
    }
}

