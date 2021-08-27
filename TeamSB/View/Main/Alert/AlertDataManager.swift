//  AlertDataManager.swift
//  TeamSB
//  Created by 구본의 on 2021/08/14.


import Foundation
import Alamofire

class AlertDataManager {
    
    private let view: AlertView
    
    init(view: AlertView){
        self.view = view
    }
    
    func postUserNotification(_ parameters: UserAlertRequest, viewController: AlertViewController, page: Int) {
        view.startLoading()
        viewController.currentPage += 1
        
        guard viewController.isLoadedAllData == false
        else {
            view.stopLoading()
            return
        }
        
        
        AF.request("\(ConstantURL.BASE_URL)/notification/list?page=\(viewController.currentPage)", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: UserAlertResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/notification/list?page=\(viewController.currentPage)")
                    view.stopRefreshControl()
                    view.stopLoading()
                    
                    if response.check == true, let result = response.content {
                        print(">>😎 나의 댓글 알림 불러오기 성공")
                        
                        guard result.count > 0 else {
                            view.stopLoading()
                            print(">>😎 더이상 읽어올 알림 없음")
                            print(">>😎 총 읽어온 알림 개수 = \(viewController.alertPost.count)")
                            viewController.isLoadedAllData = true
                            return
                        }
                        
                        for i in 0..<result.count {
                            viewController.alertPost.append(result[i])
                        }
                        print(">>😎 읽어온 알림 개수: \(result.count), 현재 페이지\(viewController.currentPage)")
                        
                        viewController.mainTableView.reloadData()
                    } else {
                        print(">>😭 나의 댓글 알림 불러오기 실패")
                        
                    }
                case .failure(let error):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/notification/list?page=\(viewController.currentPage)")
                    print(">>😱 \(error.localizedDescription)")
            }
        }
    }
    
    func postReadAllNotice(_ parameters: ReadAllNoticeRequest, viewController: AlertViewController) {
        view.startLoading()
        
        AF.request("\(ConstantURL.BASE_URL)/notification/read/all", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: ReadAllNoticeResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/notification/read/all")
                    
                    view.stopLoading()
                    
                    if response.check == true {
                        print(">>😎 댓글 알림 전체 읽기 성공")
                        //viewController.mainTableView.reloadData()
                        view.reloadTableview()
                    } else {
                        print(">>😭 나의 댓글 알림 전체 읽기 실패")
                    }
                case .failure(let error):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/notification/read/all")
                    print(">>😱 \(error.localizedDescription)")
            }
        }
    }
    
    func postReadNotice(_ parameters: ReadNoticeRequest, viewController: AlertViewController) {
        //view.startLoading()
        
        AF.request("\(ConstantURL.BASE_URL)/notification/read", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: ReadNoticeReponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/notification/read")
                    
                    //view.stopLoading()
                    
                    if response.check == true {
                        print(">>😎 알림 읽음 처리 성공")
                        //viewController.mainTableView.reloadData()
                        //view.reloadTableview()
                    } else {
                        print(">>😭 알림 읽음 처리 실패")
                    }
                case .failure(let error):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/notification/read")
                    print(">>😱 \(error.localizedDescription)")
            }
        }
    }
    
    func postExist(_ parameters: ExistsArticleRequest, viewController: AlertViewController) {
        AF.request("\(ConstantURL.BASE_URL)/accessArticle/detail", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: ExistsArticleResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/accessArticle/detail")
                    view.stopLoading()
                    if response.check == true {
                        print(">>😎 존재하는 글입니다. 해당 게시글로 이동합니다.")
                        let data = response.content![0]
                        view.goArticle(no: data.no, title: data.title, category: data.category, timeStamp: data.timeStamp, userNickname: data.userNickname, text: data.text, viewCount: data.viewCount, userId: data.userId, hash: data.hash, imageSource: data.imageSource)
                    } else {
                        print(">>😭 삭제 또는 신고 된 글이므로 접근할 수 없습니다.")
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
