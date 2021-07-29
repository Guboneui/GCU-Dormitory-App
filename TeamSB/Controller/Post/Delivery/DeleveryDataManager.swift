//  DeleveryDataManager.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.

import Foundation
import Alamofire

class DeleveryDataManager {
    
    private let view: DeleveryView

    init(view: DeleveryView) {
        self.view = view
    }

    func getDeleveryPost(viewController: DeleveryViewController, page: Int) {
        
        view.startLoading()
        viewController.currentPage += 1
        
        guard viewController.isLoadedAllData == false
        else {
            view.stopLoading()
            return
        }
        
        AF.request("\(ConstantURL.BASE_URL)/home/delivery?page=\(viewController.currentPage)", method: .get, parameters: nil)
            .validate()
            .responseDecodable(of: DeleveryResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">> URL: \(ConstantURL.BASE_URL)/home/delivery?page=\(viewController.currentPage)")
                    view.stopRefreshControl()
                    view.stopLoading()
                    
                    if response.check == true, let result = response.content {
                        print(">> 배달 게시글 가져오기 성공")
                        
                        guard result.count > 0 else {
                            view.stopLoading()
                            print(">> 더이상 읽어올 게시글 없음")
                            print(">> 총 읽어온 게시글 개수 = \(viewController.deleveryPost.count)")
                            viewController.isLoadedAllData = true
                            return
                        }
                        
                        for i in 0..<result.count {
                            viewController.deleveryPost.append(result[i])
                        }
                        print(">> 읽어온 게시글의 개수: \(result.count), 현재 페이지\(viewController.currentPage)")
                        
                        viewController.mainTableView.reloadData()
                    } else {
                        print(">> 배달 게시글 가져오기 실패")
                        
                    }
                case .failure(let error):
                    print(">>URL: \(ConstantURL.BASE_URL)/home/delivery?page=\(page)")
                    print(">> \(error.localizedDescription)")
            }
        }
    }
}