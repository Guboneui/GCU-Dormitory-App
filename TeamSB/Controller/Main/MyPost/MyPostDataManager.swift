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
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/myArticlelist?page=\(viewController.currentPage)")
                    view.stopRefreshControl()
                    view.stopLoading()
                    
                    if response.check == true, let result = response.content {
                        print(">>😎 내가 작성한 게시글 목록 가져오기 성공")
                        
                        guard result.count > 0 else {
                            view.stopLoading()
                            print(">>😎 더이상 읽어올 게시글 없음. 모든 게시글을 불러왓습니다.")
                            print(">>😎 총 읽어온 게시글 개수 = \(viewController.myPost.count)")
                            viewController.mainCollectionView.reloadData()
                            viewController.isLoadedAllData = true
                            return
                        }
                        
                        for i in 0..<result.count {
                            viewController.myPost.append(result[i])
                        }
                        
                        print(">>😎 읽어온 게시글의 개수: \(result.count), 현재 페이지\(viewController.currentPage)")
                        view.stopRefreshControl()
                        
                        
                        usleep(500000)
                        viewController.mainCollectionView.reloadData()
                    } else {
                        print(">>😭 내가 쓴 게시글 목록을 불러오지 못했습니다.")
                        
                    }
                case .failure(let error):
                    view.stopRefreshControl()
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/myArticlelist?page=\(page)")
                    print(">>😱 \(error.localizedDescription)")
                    print(">>😱 \(error)")
            }
        }
    }
    
    func postExist(_ parameters: ExistsArticleRequest, viewController: MyPostViewController) {
        AF.request("\(ConstantURL.BASE_URL)/accessArticle/detail", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: ExistsArticleResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/accessArticle/detail")
                    view.stopLoading()
                    if response.check == true {
                        print(">>😎 해당 게시글은 존재하는 게시글입니다. 게시글 자세히 보기 화면으로 넘어갑니다.")
                        view.goArticle()
                    } else {
                        print(">>😭 삭제 또는 신고 된 글이므로 해당 글에 접근할 수 없습니다.")
                        viewController.presentAlert(title: response.message)
                    }
                case .failure(let error):
                    view.stopLoading()
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/accessArticle/detail")
                    print(">>😱 \(error.localizedDescription)")
            }
        }
    }
}
