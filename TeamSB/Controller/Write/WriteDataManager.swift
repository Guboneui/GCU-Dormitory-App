//  WriteDataManager.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.

import Foundation
import Alamofire

class WriteDataManager {
    
    private let view: WriteView
    
    init(view: WriteView){
        self.view = view
    }
    
    func postWriteArticle(_ parameters: WriteArticleRequest, viewController: WriteViewController) {
        AF.request("\(ConstantURL.BASE_URL)/writeArticle", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: LoginResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>URL: \(ConstantURL.BASE_URL)/writeArticle")
                    view.stopLoading()
                    if response.check == true {
                        view.popView(message: response.message)
                    } else {
                        view.showAlert(message: response.message)
                    }
                case .failure(let error):
                    view.stopLoading()
                    print(">>URL: \(ConstantURL.BASE_URL)/writeArticle")
                    view.showAlert(message: "서버 연결 실패")
                    print(">> \(error.localizedDescription)")
            }
        }
    }
}
