//  SearchDataManager.swift
//  TeamSB
//  Created by κ΅¬λ³Έμ on 2021/07/30.

import Foundation
import Alamofire

class SearchDataManager {
    
    private let view: SearchView
    
    init(view: SearchView){
        self.view = view
    }
    
    func postSearch(_ parameters: SearchRequest, viewController: SearchViewController, page: Int) {
        
        view.startLoading()
        viewController.currentPage += 1
        
        guard viewController.isLoadedAllData == false
        else {
            view.stopLoading()
            return
        }
        
        AF.request("\(ConstantURL.BASE_URL)/search?page=\(viewController.currentPage)", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: SearchResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>π§² μΉ΄νκ³ λ¦¬κ° μ νλ κ²μκΈ κ²μ")
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/search?page=\(viewController.currentPage)")
                    view.stopLoading()
                    if response.check == true, let result = response.content {
                        if viewController.currentPage == 1 && result.count == 0 {
                            view.noSearchResult()
                        }
                        print(">>π κ²μκΈ κ²μ μ±κ³΅")
                        guard result.count > 0 else {
                            view.stopLoading()
                            print(">>π λμ΄μ μ½μ΄μ¬ κ²μκΈ μμ")
                            print(">>π μ΄ μ½μ΄μ¨ κ²μκΈ κ°μ = \(viewController.searchArray.count)")
                            viewController.isLoadedAllData = true
                            return
                        }
                        
                        for i in 0..<result.count {
                            viewController.searchArray.append(result[i])
                        }
                        print(">>π μ½μ΄μ¨ κ²μκΈμ κ°μ: \(result.count), νμ¬ νμ΄μ§\(viewController.currentPage)")
                        viewController.mainCollectionView.reloadData()
                        
                    } else {
                        print(">>π­ κ²μκΈ κ²μ μ€ν¨")
                    }
                case .failure(let error):
                    view.stopLoading()
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/search?page=\(viewController.currentPage)")
                    print(">>π± \(error.localizedDescription)")
            }
        }
    }
    
    func postSearchNoCategory(_ parameters: SearchRequestNoCategory, viewController: SearchViewController, page: Int) {
        
        view.startLoading()
        viewController.currentPage += 1
        
        guard viewController.isLoadedAllData == false
        else {
            view.stopLoading()
            return
        }
        
        AF.request("\(ConstantURL.BASE_URL)/search?page=\(viewController.currentPage)", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: SearchResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>π§² μ μ²΄(μΉ΄νκ³ λ¦¬ μ νx) κ²μ")
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/search?page=\(viewController.currentPage)")
                    view.stopLoading()
                    if response.check == true, let result = response.content {
                        if viewController.currentPage == 1 && result.count == 0 {
                            view.noSearchResult()
                        }
                        print(">>π κ²μκΈ κ²μ μ±κ³΅")
                        guard result.count > 0 else {
                            view.stopLoading()
                            print(">>π λμ΄μ μ½μ΄μ¬ κ²μκΈ μμ")
                            print(">>π μ΄ μ½μ΄μ¨ κ²μκΈ κ°μ = \(viewController.searchArray.count)")
                            viewController.isLoadedAllData = true
                            return
                        }
                        
                        for i in 0..<result.count {
                            viewController.searchArray.append(result[i])
                        }
                        print(">>π μ½μ΄μ¨ κ²μκΈμ κ°μ: \(result.count), νμ¬ νμ΄μ§\(viewController.currentPage)")
                        viewController.mainCollectionView.reloadData()
                        
                    } else {
                        print(">>π­ κ²μκΈ κ²μ μ€ν¨")
                    }
                case .failure(let error):
                    view.stopLoading()
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/search?page=\(viewController.currentPage)")
                    print(">>π± \(error.localizedDescription)")
            }
        }
    }
    
    
    func postExist(_ parameters: ExistsArticleRequest, viewController: SearchViewController) {
        AF.request("\(ConstantURL.BASE_URL)/accessArticle/detail", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: ExistsArticleResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/accessArticle/detail")
                    view.stopLoading()
                    if response.check == true {
                        print(">>π μ‘΄μ¬νλ κΈμλλ€. ν΄λΉ κ²μκΈλ‘ μ΄λν©λλ€.")
                        view.goArticle()
                    } else {
                        print(">>π­ μ­μ  λλ μ κ³  λ κΈ")
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
