//
//  LaundryDataManager.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/30.
//

import Foundation
import Alamofire

class RoomMateDataManager {
    
    private let view: RoomMateView

    init(view: RoomMateView) {
        self.view = view
    }

    func getRoomMatePost(viewController: RoomMateViewController, page: Int) {
        
        view.startLoading()
        viewController.currentPage += 1
        
        guard viewController.isLoadedAllData == false
        else {
            view.stopLoading()
            return
        }
        
        AF.request("\(ConstantURL.BASE_URL)/home/room-mate?page=\(viewController.currentPage)", method: .get, parameters: nil)
            .validate()
            .responseDecodable(of: RoomMateResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/home/room-mate?page=\(viewController.currentPage)")
                    view.stopRefreshControl()
                    view.stopLoading()
                    
                    if response.check == true, let result = response.content {
                        print(">>😎 룸메 게시글 가져오기 성공")
                        
                        guard result.count > 0 else {
                            view.stopLoading()
                            print(">>😎 더이상 읽어올 게시글 없음")
                            print(">>😎 총 읽어온 게시글 개수 = \(viewController.roommatePost.count)")
                            viewController.mainCollectionView.reloadData()
                            viewController.isLoadedAllData = true
                            return
                        }
                        
                        for i in 0..<result.count {
                            viewController.roommatePost.append(result[i])
                        }
                        print(">>😎 읽어온 게시글의 개수: \(result.count), 현재 페이지\(viewController.currentPage)")
                        
                        viewController.mainCollectionView.reloadData()
                    } else {
                        if response.code == 301 {
                            view.notDate()
                        }else {
                            print(response.code)
                            print(">>😭 룸메 게시글 가져오기 실패")
                        }
                        
                        
                    }
                case .failure(let error):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/home/room-mate?page=\(page)")
                    print(">>😱 \(error.localizedDescription)")
            }
        }
    }
    
    func postExist(_ parameters: ExistsArticleRequest, viewController: RoomMateViewController) {
        AF.request("\(ConstantURL.BASE_URL)/accessArticle/detail", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: ExistsArticleResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/accessArticle/detail")
                    view.stopLoading()
                    if response.check == true {
                        print(">>😎 존재하는 글입니다. 해당 게시글로 이동합니다.")
                        view.goArticle()
                    } else {
                        print(">>😭 삭제 또는 신고 된 글")
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

