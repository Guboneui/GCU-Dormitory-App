//  MainDataManager.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.

import Foundation
import Alamofire

class MainDataManager {
    
    private let view: MainView
    
    init(view: MainView){
        self.view = view
    }
    
    func postNickName(_ parameters: GetUserNicknameRequest, viewController: MainBaseViewController) {
        AF.request("\(ConstantURL.BASE_URL)/getUser/nickname", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: GetUserNicknameResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/getUser/nickname")
                    if response.check == true {
                        print(">>😎 유저 닉네임 새로고침 성공")
                        view.setUserNickname(nickname: response.content!)
                    } else {
                        print(">>😭 유저 닉네임 새로고침 실패")
                    }
                case .failure(let error):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/getUser/nickname")
                    print(">>😱 \(error.localizedDescription)")
            }
        }
    }
    
    func getCalMenu(viewController: MainBaseViewController) {
        AF.request("\(ConstantURL.BASE_URL)/calmenu", method: .get, parameters: nil)
            .validate()
            .responseDecodable(of: MenuResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/calmenu")
                    if response.check == true, let result = response.menu {
                        print(">>😎 식단 가져오기 성공")
                        viewController.calMenu = result
                        view.setTodayMenu()
                        viewController.baseTableView.reloadData()
                    } else {
                        print(">>😭 식단 가져오기 실패")
                        
                    }
                case .failure(let error):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/calmenu")
                    print(">>😱 \(error.localizedDescription)")
            }
        }
    }
    
    
    func getRecentPost(view: RecentPostViewTableViewCell, viewController: MainBaseViewController) {
        AF.request("\(ConstantURL.BASE_URL)/home/recentPost", method: .get, parameters: nil)
            .validate()
            .responseDecodable(of: RecentPostResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/home/recentPost")
                    if response.check == true, let result = response.content {
                        print(">>😎 최근 게시글 가져오기 성공")
                        view.recentPost = result
                        view.recentPostTableView.reloadData()
                        
                    } else {
                        print(">>😭 최근 게시글 가져오기 실패")
                        
                    }
                    //viewController.loading.stopAnimating()
                    CustomLoader.instance.hideLoader()
                case .failure(let error):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/home/recentPost")
                    print(">>😱 \(error.localizedDescription)")
            }
        }
        
        
    }
    
    
    func postProfileImage(_ parameters: GetProfileImageRequest, viewController: MainBaseViewController) {
        AF.request("\(ConstantURL.BASE_URL)/getUser/profile_image", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: GetProfileImageResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/getUser/profile_image")
                    if response.check == true {
                        print(">>😎 유저 프로필 이미지 가져오기 성공")
                        let stringImage = response.content
                        UserDefaults.standard.set(stringImage, forKey: "userProfileImage")
                    } else {
                        print(">>😭 유저프로필 이미지 가져오기 실패")
                    }
                case .failure(let error):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/getUser/profile_image")
                    print(">>😱 \(error.localizedDescription)")
            }
        }
    }
    
    func fcmToken(_ parameters: FCMRequest, viewController: MainBaseViewController) {
        AF.request("\(ConstantURL.BASE_URL)/getToken", method: .post, parameters: parameters, encoder: JSONParameterEncoder())
            .validate()
            .responseDecodable(of: FCMResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/getToken")
                    if response.check == true {
                        print(">>😎 FCM 토큰 전달 성공")
                        print(response.message)
                    } else {
                        print(">>😭 FCM 토큰 전달 실패")
                        print(response.message)
                    }
                case .failure(let error):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/getToken")
                    print(">>😱 \(error.localizedDescription)")
            }
        }
    }
    
    func getCheckUserAlert(_ parameters: CheckUserAlertRequest, viewController: MainBaseViewController) {
        viewController.baseTableView.refreshControl?.endRefreshing()
        AF.request("\(ConstantURL.BASE_URL)/notification/check", method: .post, parameters: parameters, encoder: JSONParameterEncoder())
            .validate()
            .responseDecodable(of: CheckUserAlertResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/notification/check")
                    if response.check == true {
                        print(">>😎 유저 알림 정보 통신 성공")
                        print(">>😎 유저가 읽지 않은 알림 개수는 \(String(describing: response.notificationCount))개 입니다")
                        print(response.message)
                        view.setNoticeColor(notificationCount: response.notificationCount!)
                    } else {
                        print(">>😭 유저 알림 정보 통신 실패")
                        print(response.message)
                    }
                    
                case .failure(let error):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/notification/check")
                    print(">>😱 \(error.localizedDescription)")
                    print(">>😱 유저 알림 정보 통신 에러")
            }
        }
    }
    
    func getBanner(viewController: AutoScrollNoticeTableViewCell) {
        AF.request("\(ConstantURL.BASE_URL)/topBanner", method: .get)
            .validate()
            .responseDecodable(of: GetBannerResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/topBanner")
                    if response.check == true {
                        print(">>😎 상단 배너 가져오기 성공")
                        viewController.notice = response.topBannerList
                        viewController.mainCollectionView.reloadData()
                    } else {
                       print(">>😭 상단 배너 가져오기 실패")
                    }
                    
                case .failure(let error):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/topBanner")
                    print(">>😱 \(error.localizedDescription)")
                    print(">>😱 \(error)")
            }
        }
    }
    
    func getGuide(viewController: MainBaseViewController) {
        viewController.baseTableView.refreshControl?.endRefreshing()
        AF.request("\(ConstantURL.BASE_URL)/guide/list", method: .get)
            .validate()
            .responseDecodable(of: GetGuideResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/guide/list")
                    if response.check == true, let result = response.content {
                        print(">>😎 기숙사 이용 가이드 불러오기 성공")
                        viewController.guideList = result
                        viewController.baseTableView.reloadRows(at: [[0, 3]], with: .automatic)
                        
                    } else {
                       print(">>😭 기숙사 이용 가이드 불러오기 실패")
                    }
                    
                case .failure(let error):
                    print(">>🧲 URL: \(ConstantURL.BASE_URL)/guide/list")
                    print(">>😱 \(error.localizedDescription)")
                    print(">>😱 기숙사 이용 가이드 불러오기 통신 에러")
                    print(">>😱 error")
                    
            }
        }
    }
}
