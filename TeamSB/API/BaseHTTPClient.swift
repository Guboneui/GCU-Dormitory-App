////
////  BaseHTTPClient.swift
////  WEKIT
////
////  Created by Yonghyun on 2021/01/04.
////
//
//import Foundation
//import Alamofire
//import RxAlamofire
//import RxSwift
//
//class BaseHTTPClient {
//    static let instance = BaseHTTPClient()
//    static var fullApiRouteURL: String?
//    
//    private init() {
//        #if DEBUG
//            BaseHTTPClient.fullApiRouteURL = URLConsts.CURR_URL
//        #else
//            BaseHTTPClient.fullApiRouteURL = URLConsts.CURR_URL
//        #endif
//    }
//    
//    func requestJSON(_ method: Alamofire.HTTPMethod,
//                     _ apiRouteURL: String,
//                     addHeader: [String: String]?,
//                     parameter: [String: Any]?) -> Observable<(HTTPURLResponse, String)> {
//        
////        let requestURL = setHostURLOn(apiRouteURL)
//        
//        let requestURL = apiRouteURL
//        var jsonRequestHeader: HTTPHeaders = ["Accept": "application/json"]
//        jsonRequestHeader.update(addHeader)
//        
//        return SessionManager.default.rx.request(method, requestURL, parameters: parameter, encoding: JSONEncoding.default, headers: jsonRequestHeader)
//            .validate(statusCode: 200 ..< 300)
//            .responseString()
//    }
//    
//    func requestRawJSON(_ method: Alamofire.HTTPMethod,
//                     _ apiRouteURL: String,
//                     addHeader: [String: String]?,
//                     nickname: String) -> Observable<(HTTPURLResponse, String)> {
//        
////        let requestURL = setHostURLOn(apiRouteURL)
//        
//        let requestURL = apiRouteURL
//        var jsonRequestHeader: HTTPHeaders = ["Accept": "application/json"]
//        jsonRequestHeader.update(addHeader)
//        
//        return SessionManager.default.rx.request(method, requestURL, parameters: [:], encoding: nickname, headers: jsonRequestHeader)
//            .validate(statusCode: 200 ..< 300)
//            .responseString()
//    }
//    
//    func requestGetQueryJSON(_ method: Alamofire.HTTPMethod,
//                        _ apiRouteURL: String,
//                        addHeader: [String: String]?,
//                        parameter: [String: Any]?) -> Observable<(HTTPURLResponse, String)> {
//        
////        let requestURL = setHostURLOn(apiRouteURL)
//        
//        let requestURL = apiRouteURL
//        var jsonRequestHeader: HTTPHeaders = ["Accept": "application/json"]
//        jsonRequestHeader.update(addHeader)
//                
//        return SessionManager.default.rx.request(method, requestURL, parameters: parameter, encoding: URLEncoding(arrayEncoding: .noBrackets), headers: jsonRequestHeader)
//            .validate(statusCode: 200 ..< 300)
//            .responseString()
//    }
//    
//    func requestGetJSON(_ method: Alamofire.HTTPMethod,
//                        _ apiRouteURL: String,
//                        addHeader: [String: String]?,
//                        parameter: [String: Any]) -> Observable<(HTTPURLResponse, String)> {
//        
////        let requestURL = setHostURLOn(apiRouteURL)
//        
//        let requestURL = apiRouteURL
//        var jsonRequestHeader: HTTPHeaders = ["Accept": "application/json"]
//        jsonRequestHeader.update(addHeader)
//        
//        return SessionManager.default.rx.request(method, requestURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, parameters: parameter, headers: jsonRequestHeader)
//            .validate(statusCode: 200 ..< 300)
//            .responseString()
//    }
//    
//    func requestFileUpload(_ img: Data,
//                           _ apiRouteURL: String,
//                           addHeader: [String: String]?,
//                           parameter: [String: Any]) -> Observable<UploadRequest> {
//        
////        let requestURL = setHostURLOn(apiRouteURL)
//        let requestURL = apiRouteURL
//        
//        return SessionManager.default.rx.upload(img, urlRequest: try! RxAlamofire.urlRequest(.put, requestURL))
//            .observeOn(MainScheduler.instance)
//    }
//    
//    func setHostURLOn(_ apiRouteURL: String) -> String {
//        var fullApi: String
//        #if DEBUG
//            fullApi = BaseHTTPClient.fullApiRouteURL! + apiRouteURL
//        #else
//            fullApi = BaseHTTPClient.fullApiRouteURL! + apiRouteURL
//        #endif
//        
//        return fullApi
//    }
//}
//
//extension Dictionary {
//    mutating func update(_ addHeader : Dictionary?) {
//        guard addHeader == nil else {
//            for (key,value) in addHeader! {
//                self.updateValue(value, forKey:key)
//            }
//            
//            return
//        }
//    }
//}
//
//extension String: ParameterEncoding {
//    
//    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
//        var request = try urlRequest.asURLRequest()
//        request.httpBody = data(using: .utf8, allowLossyConversion: false)
//        return request
//    }
//    
//}
