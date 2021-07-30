//
//  TaxiDataManager.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/30.
//

import Foundation
import Alamofire

class TaxiDataManager {
    
    private let view: TaxiView

    init(view: TaxiView) {
        self.view = view
    }

    func getTaxiPost(viewController: TaxiViewController, page: Int) {
        
        view.startLoading()
        viewController.currentPage += 1
        
        guard viewController.isLoadedAllData == false
        else {
            view.stopLoading()
            return
        }
        
        AF.request("\(ConstantURL.BASE_URL)/home/taxi?page=\(viewController.currentPage)", method: .get, parameters: nil)
            .validate()
            .responseDecodable(of: TaxiResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">> URL: \(ConstantURL.BASE_URL)/home/taxi?page=\(viewController.currentPage)")
                    view.stopRefreshControl()
                    view.stopLoading()
                    
                    if response.check == true, let result = response.content {
                        print(">> 택시 게시글 가져오기 성공")
                        
                        guard result.count > 0 else {
                            view.stopLoading()
                            print(">> 더이상 읽어올 게시글 없음")
                            print(">> 총 읽어온 게시글 개수 = \(viewController.taxiPost.count)")
                            viewController.isLoadedAllData = true
                            return
                        }
                        
                        for i in 0..<result.count {
                            viewController.taxiPost.append(result[i])
                        }
                        print(">> 읽어온 게시글의 개수: \(result.count), 현재 페이지\(viewController.currentPage)")
                        
                        viewController.mainTableView.reloadData()
                    } else {
                        print(">> 택시 게시글 가져오기 실패")
                        
                    }
                case .failure(let error):
                    print(">> URL: \(ConstantURL.BASE_URL)/home/taxi?page=\(page)")
                    print(">> \(error.localizedDescription)")
            }
        }
    }
    
    func postExist(_ parameters: ExistsArticleRequest, viewController: TaxiViewController) {
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

