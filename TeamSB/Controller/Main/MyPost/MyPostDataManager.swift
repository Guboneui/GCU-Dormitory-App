//  MyPostDataManager.swift
//  TeamSB
//  Created by 구본의 on 2021/08/10.

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
                    print(">> URL: \(ConstantURL.BASE_URL)/myArticlelist?page=\(viewController.currentPage)")
                    view.stopRefreshControl()
                    view.stopLoading()
                    
                    if response.check == true, let result = response.content {
                        print(">> 전체 게시글 가져오기 성공")
                        
                        guard result.count > 0 else {
                            view.stopLoading()
                            print(">> 더이상 읽어올 게시글 없음")
                            print(">> 총 읽어온 게시글 개수 = \(viewController.myPost.count)")
                            viewController.mainCollectionView.reloadData()
                            viewController.isLoadedAllData = true
                            return
                        }
                        
                        for i in 0..<result.count {
                            viewController.myPost.append(result[i])
                        }
                        
                        print(">> 읽어온 게시글의 개수: \(result.count), 현재 페이지\(viewController.currentPage)")
                        view.stopRefreshControl()
                        
                        
                        usleep(500000)
                        viewController.mainCollectionView.reloadData()
                    } else {
                        print(">> 전체 게시글 가져오기 실패")
                        
                    }
                case .failure(let error):
                    view.stopRefreshControl()
                    print(">> URL: \(ConstantURL.BASE_URL)/myArticlelist?page=\(page)")
                    print(">> \(error.localizedDescription)")
                    print(">> \(error)")
            }
        }
    }
    
    func postExist(_ parameters: ExistsArticleRequest, viewController: MyPostViewController) {
        AF.request("\(ConstantURL.BASE_URL)/accessArticle/detail", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: ExistsArticleResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">> URL: \(ConstantURL.BASE_URL)/accessArticle/detail")
                    view.stopLoading()
                    if response.check == true {
                        print(">> 존재하는 글")
                        view.goArticle()
                    } else {
                        print(">> 삭제 또는 신고 된 글")
                        viewController.presentAlert(title: response.message)
                    }
                case .failure(let error):
                    view.stopLoading()
                    print(">> URL: \(ConstantURL.BASE_URL)/accessArticle/detail")
                    print(">> \(error.localizedDescription)")
            }
        }
    }
}
