//  SearchDataManager.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.

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
                    print(">> 카테고리가 선택된 게시글 검색")
                    print(">>URL: \(ConstantURL.BASE_URL)/search?page=\(viewController.currentPage)")
                    view.stopLoading()
                    if response.check == true, let result = response.content {
                        if viewController.currentPage == 1 && result.count == 0 {
                            view.noSearchResult()
                        }
                        guard result.count > 0 else {
                            view.stopLoading()
                            print(">> 더이상 읽어올 게시글 없음")
                            print(">> 총 읽어온 게시글 개수 = \(viewController.searchArray.count)")
                            viewController.isLoadedAllData = true
                            return
                        }
                        
                        for i in 0..<result.count {
                            viewController.searchArray.append(result[i])
                        }
                        print(">> 읽어온 게시글의 개수: \(result.count), 현재 페이지\(viewController.currentPage)")
                        viewController.mainTableView.reloadData()
                        
                    } else {
                        print(">> 검색 실패")
                    }
                case .failure(let error):
                    view.stopLoading()
                    print(">>URL: \(ConstantURL.BASE_URL)/search?page=\(viewController.currentPage)")
                    print(">> \(error.localizedDescription)")
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
                    print(">> 전체 검색")
                    print(">>URL: \(ConstantURL.BASE_URL)/search?page=\(viewController.currentPage)")
                    view.stopLoading()
                    if response.check == true, let result = response.content {
                        if viewController.currentPage == 1 && result.count == 0 {
                            view.noSearchResult()
                        }
                        guard result.count > 0 else {
                            view.stopLoading()
                            print(">> 더이상 읽어올 게시글 없음")
                            print(">> 총 읽어온 게시글 개수 = \(viewController.searchArray.count)")
                            viewController.isLoadedAllData = true
                            return
                        }
                        
                        for i in 0..<result.count {
                            viewController.searchArray.append(result[i])
                        }
                        print(">> 읽어온 게시글의 개수: \(result.count), 현재 페이지\(viewController.currentPage)")
                        viewController.mainTableView.reloadData()
                        
                    } else {
                        print(">> 검색 실패")
                    }
                case .failure(let error):
                    view.stopLoading()
                    print(">>URL: \(ConstantURL.BASE_URL)/search?page=\(viewController.currentPage)")
                    print(">> \(error.localizedDescription)")
            }
        }
    }
}
