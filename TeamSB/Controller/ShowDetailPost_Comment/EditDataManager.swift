//
//  EditDataManager.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/08.
//

import Foundation
import Alamofire


class EditDataManager {
    private let view: EditView
    
    init(view: EditView){
        self.view = view
    }
    
    func changeArticle(_ parameters: EditArticleRequest, viewController: EditViewController) {
        AF.request("\(ConstantURL.BASE_URL)/modifyArticle", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: EditArticleResponse.self) { [self] response in
                print(response)
                switch response.result {
                case .success(let response):
                    print("t성공")
                    
                case .failure(let error):
                    print(">> URL: \(ConstantURL.BASE_URL)/modifyArticle")
                    print(">> \(error.localizedDescription)")
            }
        }
    }
}
