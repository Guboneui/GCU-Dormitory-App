//  DetailPostViewDataManager.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.

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
                    print(">>URL: \(ConstantURL.BASE_URL)/accessArticle")
                    if response.check == true{
                        print(response.message)
                        
                    } else {
                        print(">> 조회수 증가 실패")
                    }
                case .failure(let error):
                    print(">>URL: \(ConstantURL.BASE_URL)/accessArticle")
                    print(">> \(error.localizedDescription)")
            }
        }
    }
    
    func postDeleteArticleCount(_ parameters: DeleteArticleRequest, viewController: DetailPostViewController) {
        AF.request("\(ConstantURL.BASE_URL)/deleteArticle", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: DeleteArticleResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>URL: \(ConstantURL.BASE_URL)/deleteArticle")
                    if response.check == true{
                        print(response.message)
                        view.popView()
                    } else {
                        print(">> 게시글 삭제 실패")
                    }
                case .failure(let error):
                    print(">>URL: \(ConstantURL.BASE_URL)/deleteArticle")
                    print(">> \(error.localizedDescription)")
            }
        }
    }
    
    func postBanArticleCount(_ parameters: BanArticleRequest, viewController: BanPopUPViewController) {
        AF.request("\(ConstantURL.BASE_URL)/report", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: BanArticleResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>URL: \(ConstantURL.BASE_URL)/report")
                    if response.check == true{
                        print(response.message)
                        view.popView()
                    } else {
                        print(">> 게시글 신고 실패")
                    }
                case .failure(let error):
                    print(">>URL: \(ConstantURL.BASE_URL)/report")
                    print(">> \(error.localizedDescription)")
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
                    print(">>URL: \(ConstantURL.BASE_URL)/reply/list?page=\(viewController.currentPage)")
                    view.stopRefreshControl()
                    if response.check == true, let result = response.content{
                        
                        guard result.count > 0 else {
                            
                            print(">> 더이상 읽어올 게시글 없음")
                            print(">> 총 읽어온 댓글 개수 = \(viewController.comment.count)")
                            viewController.isLoadedAllData = true
                            return
                        }
                        for i in 0..<result.count {
                            viewController.comment.append(result[i])
                        }
                        
                        print(">> 읽어온 댓글 개수: \(result.count), 현재 페이지\(viewController.currentPage)")
                        viewController.mainTableView.reloadData()
                        
                        
                        print(response.message)
        
                    } else {
                        print(">> 댓글 읽기 실패")
                    }
                case .failure(let error):
                    print(">>URL: \(ConstantURL.BASE_URL)/reply/list?page=\(viewController.currentPage)")
                    print(">> \(error.localizedDescription)")
            }
        }
    }
    
    func postSendArticleComment(_ parameters: PostCommentRequest, viewController: DetailPostViewController) {
        AF.request("\(ConstantURL.BASE_URL)/reply/write", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: PostCommentResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>URL: \(ConstantURL.BASE_URL)/reply/write")
                    if response.check == true{
                        print(response.message)
                        view.successPost()
                        
                        view.updateTableView()
                       
                    } else {
                        print(">> 댓글 작성 실패")
                    }
                case .failure(let error):
                    print(">>URL: \(ConstantURL.BASE_URL)/reply/write")
                    print(">> \(error.localizedDescription)")
            }
        }
    }
    
}
