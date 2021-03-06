//  MyPostDataManager.swift
//  TeamSB
//  Created by κ΅¬λ³Έμ on 2021/08/10.

import Foundation
import UIKit
import Alamofire


class MyPostDataManager {
    
    private let view: MyPostView
    
    init(view: MyPostView){
        self.view = view
    }
    
    
    
    func postMyArticle(_ parameters: MyPostRequest,viewController: MyPostViewController, page: Int) {
        view.startLoading()
        viewController.currentPage += 1
        
        guard viewController.isLoadedAllData == false
        else {
            view.stopLoading()
            return
        }
        
        AF.request("\(ConstantURL.BASE_URL)/myArticlelist?page=\(viewController.currentPage)", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: MyPostResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/myArticlelist?page=\(viewController.currentPage)")
                    view.stopRefreshControl()
                    view.stopLoading()
                    
                    if response.check == true, let result = response.content {
                        print(">>π λ΄κ° μμ±ν κ²μκΈ λͺ©λ‘ κ°μ Έμ€κΈ° μ±κ³΅")
                        
                        guard result.count > 0 else {
                            view.stopLoading()
                            print(">>π λμ΄μ μ½μ΄μ¬ κ²μκΈ μμ. λͺ¨λ  κ²μκΈμ λΆλ¬μμ΅λλ€.")
                            print(">>π μ΄ μ½μ΄μ¨ κ²μκΈ κ°μ = \(viewController.myPost.count)")
                            viewController.mainCollectionView.reloadData()
                            viewController.isLoadedAllData = true
                            return
                        }
                        
                        for i in 0..<result.count {
                            viewController.myPost.append(result[i])
                        }
                        
                        print(">>π μ½μ΄μ¨ κ²μκΈμ κ°μ: \(result.count), νμ¬ νμ΄μ§\(viewController.currentPage)")
                        view.stopRefreshControl()
                        
                        
                        usleep(500000)
                        viewController.mainCollectionView.reloadData()
                    } else {
                        print(">>π­ λ΄κ° μ΄ κ²μκΈ λͺ©λ‘μ λΆλ¬μ€μ§ λͺ»νμ΅λλ€.")
                        
                    }
                case .failure(let error):
                    view.stopRefreshControl()
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/myArticlelist?page=\(page)")
                    print(">>π± \(error.localizedDescription)")
                    print(">>π± \(error)")
            }
        }
    }
    
    func postExist(_ parameters: ExistsArticleRequest, viewController: MyPostViewController) {
        AF.request("\(ConstantURL.BASE_URL)/accessArticle/detail", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: ExistsArticleResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/accessArticle/detail")
                    view.stopLoading()
                    if response.check == true {
                        print(">>π ν΄λΉ κ²μκΈμ μ‘΄μ¬νλ κ²μκΈμλλ€. κ²μκΈ μμΈν λ³΄κΈ° νλ©΄μΌλ‘ λμ΄κ°λλ€.")
                        view.goArticle()
                    } else {
                        print(">>π­ μ­μ  λλ μ κ³  λ κΈμ΄λ―λ‘ ν΄λΉ κΈμ μ κ·Όν  μ μμ΅λλ€.")
                        viewController.presentAlert(title: response.message)
                    }
                case .failure(let error):
                    view.stopLoading()
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/accessArticle/detail")
                    print(">>π± \(error.localizedDescription)")
            }
        }
    }
}
