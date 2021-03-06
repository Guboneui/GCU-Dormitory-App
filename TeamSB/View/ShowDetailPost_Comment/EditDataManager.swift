//
//  EditDataManager.swift
//  TeamSB
//
//  Created by κ΅¬λ³Έμ on 2021/08/08.
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
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/modifyArticle")
                    view.stopLoading()
                    if response.check == true {
                        view.popView(message: response.message)
                        print(">>π κΈ μμ  μλ£")
                    } else {
                        print(">>π­ κΈ μμ  μ€ν¨")
                        view.showAlert(message: response.message)
                    }
                case .failure(let error):
                    view.stopLoading()
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/modifyArticle")
                    view.showAlert(message: "μλ² μ°κ²° μ€ν¨")
                    print(">>π± \(error.localizedDescription)")
            }
        }
    }
}
