//  AllPostDataManager.swift
//  TeamSB
//  Created by κ΅¬λ³Έμ on 2021/07/30.

import Foundation
import Alamofire

class AllPostDataManager {
    
    private let view: AllPostView
    
    init(view: AllPostView) {
        self.view = view
    }
    
    func getAllPost(viewController: ShowMoreViewController, page: Int) {
        
        view.startLoading()
        viewController.currentPage += 1
        
        guard viewController.isLoadedAllData == false
        else {
            view.stopLoading()
            return
        }
        
        AF.request("\(ConstantURL.BASE_URL)/home/all?page=\(viewController.currentPage)", method: .get, parameters: nil)
            .validate()
            .responseDecodable(of: AllPostResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/home/all?page=\(viewController.currentPage)")
                    view.stopRefreshControl()
                    view.stopLoading()
                    
                    if response.check == true, let result = response.content {
                        print(">>π μ μ²΄ κ²μκΈ κ°μ Έμ€κΈ° μ±κ³΅")
                        
                        guard result.count > 0 else {
                            view.stopLoading()
                            print(">>π λμ΄μ μ½μ΄μ¬ κ²μκΈ μμ")
                            print(">>π μ΄ μ½μ΄μ¨ κ²μκΈ κ°μ = \(viewController.allPost.count)")
                            viewController.allPostCollectionView.reloadData()
                            viewController.isLoadedAllData = true
                            return
                        }
                        
                        for i in 0..<result.count {
                            viewController.allPost.append(result[i])
                        }
                        
                        print(">>π μ½μ΄μ¨ κ²μκΈμ κ°μ: \(result.count), νμ¬ νμ΄μ§\(viewController.currentPage)")
                        
                        viewController.allPostCollectionView.reloadData()
                    } else {
                        print(">>π­ μ μ²΄ κ²μκΈ κ°μ Έμ€κΈ° μ€ν¨")
                        
                    }
                case .failure(let error):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/home/all?page=\(page)")
                    print(">>π± \(error.localizedDescription)")
            }
        }
    }
    
    func postExist(_ parameters: ExistsArticleRequest, viewController: ShowMoreViewController) {
        AF.request("\(ConstantURL.BASE_URL)/accessArticle/detail", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: ExistsArticleResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/accessArticle/detail")
                    view.stopLoading()
                    if response.check == true {
                        print(">>π μ‘΄μ¬νλ κΈ μ΄λ―λ‘ κ²μκΈλ‘ μ΄λν©λλ€.")
                        view.goArticle()
                    } else {
                        print(">>π­ μ­μ  λλ μ κ³  λ κΈλ‘ μ κ·Όν  μ μμ΅λλ€.")
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
