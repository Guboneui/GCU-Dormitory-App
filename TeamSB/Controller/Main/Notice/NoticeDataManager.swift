//
//  NoticeDataManager.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/15.
//
import Foundation
import Alamofire

class NoticeDataManager {
    
    private let view: NoticeView
    
    init(view: NoticeView){
        self.view = view
    }
    
    func getTopNotice(viewController: NoticeViewController) {
        view.startLoading()
        
        
        AF.request("\(ConstantURL.BASE_URL)/notice/list/top", method: .get)
            .validate()
            .responseDecodable(of: TopNoticeResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/notice/list/top?page=\(viewController.currentPage)")
                    view.stopRefreshControl()
                    view.stopLoading()
                    
                    if response.check == true, let result = response.content {
                        print(">>😎 공지사항 고정된 게시글 불러오기 성공")
                    
                        for i in 0..<result.count {
                            viewController.noticeArray.append(result[i])
                        }
                        print(">>😎 읽어온 알림 개수: \(result.count), 현재 페이지\(viewController.currentPage)")
                        
                        viewController.mainTableView.reloadData()
                        getNormalNotice(viewController: NoticeViewController(), page: viewController.currentNormalPage)
                        
                    } else {
                        print(">>😭 공지사항 고정된 게시글 불러오기 실패")
                        
                    }
                case .failure(let error):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/notice/list/top?page=\(viewController.currentPage)")
                    print(">>😱 \(error.localizedDescription)")
                    print(">>😱 \(error)")
            }
        }
    }
    
    func getNormalNotice(viewController: NoticeViewController, page: Int) {
        view.startLoading()
        viewController.currentNormalPage += 1
        
        guard viewController.isLoadedAllNormalData == false
        else {
            view.stopLoading()
            return
        }
        
        
        AF.request("\(ConstantURL.BASE_URL)/notice/list?page=\(viewController.currentNormalPage)", method: .get)
            .validate()
            .responseDecodable(of: NormalNoticeResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/notice/list?page=\(viewController.currentNormalPage)")
                    view.stopRefreshControl()
                    view.stopLoading()
                    
                    if response.check == true, let result = response.content {
                        print(">>😎 일반 공지사항 불러오기 성공")
                        
                        guard result.count > 0 else {
                            view.stopLoading()
                            print(">>😎 더이상 읽어올 일반 공지사항 없음")
                            print(">>😎 총 읽어온 공지사항 개수 = \(viewController.noticeArray.count)")
                            viewController.isLoadedAllNormalData = true
                            return
                        }
                        
                        for i in 0..<result.count {
                            viewController.noticeArray.append(result[i])
                        }
                        print(">>😎 읽어온 일반 공지사항 개수: \(result.count), 현재 페이지\(viewController.currentNormalPage)")
                        
                        view.reloadTableView()
                    } else {
                        print(">>😭 일반 공지사항 불러오기 실패")
                        
                    }
                case .failure(let error):
                    print(">> URL: \(ConstantURL.BASE_URL)/notice/list?page=\(viewController.currentNormalPage)")
                    print(">> \(error.localizedDescription)")
                    print(error)
            }
        }
    }
}
