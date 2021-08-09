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
                switch response.result {
                case .success(let response):
                    print(">> URL: \(ConstantURL.BASE_URL)/modifyArticle")
                    view.stopLoading()
                    if response.check == true {
                        view.popView(message: response.message)
                        print(">> 글 수정 완료")
                    } else {
                        view.showAlert(message: response.message)
                    }
                case .failure(let error):
                    view.stopLoading()
                    print(">> URL: \(ConstantURL.BASE_URL)/modifyArticle")
                    view.showAlert(message: "서버 연결 실패")
                    print(">> \(error.localizedDescription)")
            }
        }
    }
}
