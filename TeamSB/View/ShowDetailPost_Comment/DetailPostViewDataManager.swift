//  DetailPostViewDataManager.swift
//  TeamSB
//  Created by κ΅¬λ³Έμ on 2021/07/30.

import Foundation
import Alamofire

class DetailPostViewDataManager {
    
    private let view: DetailPostView
    
    init(view: DetailPostView){
        self.view = view
    }
    
    func postAddArticleCount(_ parameters: AddArticleCountRequest, viewController: DetailPostViewController) {
        AF.request("\(ConstantURL.BASE_URL)/accessArticle", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: AddArticleCountResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/accessArticle")
                    if response.check == true{
                        print(">>π κ²μκΈ μ‘°νμ μ¦κ° μ±κ³΅")
                    } else {
                        print(">>π­ μ‘°νμ μ¦κ° μ€ν¨")
                    }
                case .failure(let error):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/accessArticle")
                    print(">>π± \(error.localizedDescription)")
            }
        }
    }
    
    func postDeleteArticleCount(_ parameters: DeleteArticleRequest, viewController: DetailPostViewController) {
        AF.request("\(ConstantURL.BASE_URL)/deleteArticle", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: DeleteArticleResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/deleteArticle")
                    if response.check == true{
                        print(">>π \(response.message)")
                        view.popView(message: response.message)
                    } else {
                        print(">>π­ κ²μκΈ μ­μ  μ€ν¨")
                        view.popView(message: response.message)
                    }
                case .failure(let error):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/deleteArticle")
                    print(">>π± \(error.localizedDescription)")
            }
        }
    }
    
    func postBanArticleCount(_ parameters: BanArticleRequest, viewController: BanPopUPViewController) {
        AF.request("\(ConstantURL.BASE_URL)/report", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: BanArticleResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/report")
                    if response.check == true{
                        print(">>π \(response.message)")
                        view.popView(message: response.message)
                    } else {
                        print(">>π­ κ²μκΈ μ κ³  μ€ν¨")
                        view.popView(message: response.message)
                    }
                case .failure(let error):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/report")
                    print(">>π± \(error.localizedDescription)")
            }
        }
    }
    
    
    func postGetArticleComment(_ parameters: GetCommentRequest, viewController: DetailPostViewController, page: Int) {
       
        viewController.currentPage += 1
        
        guard viewController.isLoadedAllData == false
        else { return }
        
        AF.request("\(ConstantURL.BASE_URL)/reply/list?page=\(viewController.currentPage)", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: GetCommentResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/reply/list?page=\(viewController.currentPage)")
                    view.stopRefreshControl()
                    if response.check == true, let result = response.content{
                        print(">>π λκΈ μ½μ΄μ€κΈ° μ±κ³΅")
                        
                        guard result.count > 0 else {
                            
                            print(">>π λμ΄μ μ½μ΄μ¬ λκΈ μμ")
                            print(">>π μ΄ μ½μ΄μ¨ λκΈ κ°μ = \(viewController.comment.count)")
                            viewController.isLoadedAllData = true
                            return
                        }
                        for i in 0..<result.count {
                            viewController.comment.append(result[i])
                        }
                        
                        print(">>π μ½μ΄μ¨ λκΈ κ°μ: \(result.count), νμ¬ νμ΄μ§\(viewController.currentPage)")
                        viewController.mainTableView.reloadData()
        
                    } else {
                        print(">>π­ λκΈ μ½κΈ° μ€ν¨")
                    }
                case .failure(let error):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/reply/list?page=\(viewController.currentPage)")
                    print(">>π± \(error.localizedDescription)")
            }
        }
    }
    
    func postSendArticleComment(_ parameters: PostCommentRequest, viewController: DetailPostViewController) {
        AF.request("\(ConstantURL.BASE_URL)/reply/write", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: PostCommentResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/reply/write")
                    if response.check == true{
                        print(">>π \(response.message)")
                        view.successPost()
                        
                        view.updateTableView()
                       
                    } else {
                        print(">>π­ λκΈ μμ± μ€ν¨")
                        view.popView(message: response.message)
                    }
                case .failure(let error):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/reply/write")
                    print(">>π± \(error.localizedDescription)")
                    print(error)
            }
        }
    }
    
    
    func repostArticle(_ parameters: RePostRequest, viewCcntroller: DetailPostViewController) {
        AF.request("\(ConstantURL.BASE_URL)/accessArticle/detail", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: RePostResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/accessArticle/detail")
                    print(">>π§² κ²μκΈ μμ  ν κ²μκΈ λ€μ λΆλ¬μ€κΈ°")
                    if response.check == true, let result = response.content{
                        print(">>π \(response.message)")
                        viewCcntroller.post = result
                        view.reloadPost()
                       
                    } else {
                        print(">>π­ \(response.message)")
                        view.popView(message: response.message)
                    }
                case .failure(let error):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/accessArticle/detail")
                    print(">>π± \(error.localizedDescription)")
            }
        }
    }
    
    
}
