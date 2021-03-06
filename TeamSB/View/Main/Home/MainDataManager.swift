//  MainDataManager.swift
//  TeamSB
//  Created by ๊ตฌ๋ณธ์ on 2021/07/30.

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
                    print(">>๐งฒ URL: \(ConstantURL.BASE_URL)/getUser/nickname")
                    if response.check == true {
                        print(">>๐ ์ ์  ๋๋ค์ ์๋ก๊ณ ์นจ ์ฑ๊ณต")
                        view.setUserNickname(nickname: response.content!)
                    } else {
                        print(">>๐ญ ์ ์  ๋๋ค์ ์๋ก๊ณ ์นจ ์คํจ")
                    }
                case .failure(let error):
                    print(">>๐งฒ URL: \(ConstantURL.BASE_URL)/getUser/nickname")
                    print(">>๐ฑ \(error.localizedDescription)")
            }
        }
    }
    
    func getCalMenu(viewController: MainBaseViewController) {
        AF.request("\(ConstantURL.BASE_URL)/calmenu", method: .get, parameters: nil)
            .validate()
            .responseDecodable(of: MenuResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>๐งฒ URL: \(ConstantURL.BASE_URL)/calmenu")
                    if response.check == true, let result = response.menu {
                        print(">>๐ ์๋จ ๊ฐ์ ธ์ค๊ธฐ ์ฑ๊ณต")
                        viewController.calMenu = result
                        view.setTodayMenu()
                        viewController.baseTableView.reloadData()
                    } else {
                        print(">>๐ญ ์๋จ ๊ฐ์ ธ์ค๊ธฐ ์คํจ")
                        
                    }
                case .failure(let error):
                    print(">>๐งฒ URL: \(ConstantURL.BASE_URL)/calmenu")
                    print(">>๐ฑ \(error.localizedDescription)")
            }
        }
    }
    
    
    func getRecentPost(view: RecentPostViewTableViewCell, viewController: MainBaseViewController) {
        AF.request("\(ConstantURL.BASE_URL)/home/recentPost", method: .get, parameters: nil)
            .validate()
            .responseDecodable(of: RecentPostResponse.self) { response in
                switch response.result {
                case .success(let response):
                    print(">>๐งฒ URL: \(ConstantURL.BASE_URL)/home/recentPost")
                    if response.check == true, let result = response.content {
                        print(">>๐ ์ต๊ทผ ๊ฒ์๊ธ ๊ฐ์ ธ์ค๊ธฐ ์ฑ๊ณต")
                        view.recentPost = result
                        view.recentPostTableView.reloadData()
                        
                    } else {
                        print(">>๐ญ ์ต๊ทผ ๊ฒ์๊ธ ๊ฐ์ ธ์ค๊ธฐ ์คํจ")
                        
                    }
                    //viewController.loading.stopAnimating()
                    CustomLoader.instance.hideLoader()
                case .failure(let error):
                    print(">>๐งฒ URL: \(ConstantURL.BASE_URL)/home/recentPost")
                    print(">>๐ฑ \(error.localizedDescription)")
            }
        }
        
        
    }
    
    
    func postProfileImage(_ parameters: GetProfileImageRequest, viewController: MainBaseViewController) {
        AF.request("\(ConstantURL.BASE_URL)/getUser/profile_image", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: GetProfileImageResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>๐งฒ URL: \(ConstantURL.BASE_URL)/getUser/profile_image")
                    if response.check == true {
                        print(">>๐ ์ ์  ํ๋กํ ์ด๋ฏธ์ง ๊ฐ์ ธ์ค๊ธฐ ์ฑ๊ณต")
                        let stringImage = response.content
                        UserDefaults.standard.set(stringImage, forKey: "userProfileImage")
                    } else {
                        print(">>๐ญ ์ ์ ํ๋กํ ์ด๋ฏธ์ง ๊ฐ์ ธ์ค๊ธฐ ์คํจ")
                    }
                case .failure(let error):
                    print(">>๐งฒ URL: \(ConstantURL.BASE_URL)/getUser/profile_image")
                    print(">>๐ฑ \(error.localizedDescription)")
            }
        }
    }
    
    func fcmToken(_ parameters: FCMRequest, viewController: MainBaseViewController) {
        AF.request("\(ConstantURL.BASE_URL)/getToken", method: .post, parameters: parameters, encoder: JSONParameterEncoder())
            .validate()
            .responseDecodable(of: FCMResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>๐งฒ URL: \(ConstantURL.BASE_URL)/getToken")
                    if response.check == true {
                        print(">>๐ FCM ํ ํฐ ์ ๋ฌ ์ฑ๊ณต")
                        print(response.message)
                    } else {
                        print(">>๐ญ FCM ํ ํฐ ์ ๋ฌ ์คํจ")
                        print(response.message)
                    }
                case .failure(let error):
                    print(">>๐งฒ URL: \(ConstantURL.BASE_URL)/getToken")
                    print(">>๐ฑ \(error.localizedDescription)")
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
                    print(">>๐งฒ URL: \(ConstantURL.BASE_URL)/notification/check")
                    if response.check == true {
                        print(">>๐ ์ ์  ์๋ฆผ ์ ๋ณด ํต์  ์ฑ๊ณต")
                        print(">>๐ ์ ์ ๊ฐ ์ฝ์ง ์์ ์๋ฆผ ๊ฐ์๋ \(String(describing: response.notificationCount))๊ฐ ์๋๋ค")
                        print(response.message)
                        view.setNoticeColor(notificationCount: response.notificationCount!)
                    } else {
                        print(">>๐ญ ์ ์  ์๋ฆผ ์ ๋ณด ํต์  ์คํจ")
                        print(response.message)
                    }
                    
                case .failure(let error):
                    print(">>๐งฒ URL: \(ConstantURL.BASE_URL)/notification/check")
                    print(">>๐ฑ \(error.localizedDescription)")
                    print(">>๐ฑ ์ ์  ์๋ฆผ ์ ๋ณด ํต์  ์๋ฌ")
            }
        }
    }
    
    func getBanner(viewController: AutoScrollNoticeTableViewCell) {
        AF.request("\(ConstantURL.BASE_URL)/topBanner", method: .get)
            .validate()
            .responseDecodable(of: GetBannerResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>๐งฒ URL: \(ConstantURL.BASE_URL)/topBanner")
                    if response.check == true {
                        print(">>๐ ์๋จ ๋ฐฐ๋ ๊ฐ์ ธ์ค๊ธฐ ์ฑ๊ณต")
                        viewController.notice = response.topBannerList
                        viewController.mainCollectionView.reloadData()
                    } else {
                       print(">>๐ญ ์๋จ ๋ฐฐ๋ ๊ฐ์ ธ์ค๊ธฐ ์คํจ")
                    }
                    
                case .failure(let error):
                    print(">>๐งฒ URL: \(ConstantURL.BASE_URL)/topBanner")
                    print(">>๐ฑ \(error.localizedDescription)")
                    print(">>๐ฑ \(error)")
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
                    print(">>๐งฒ URL: \(ConstantURL.BASE_URL)/guide/list")
                    if response.check == true, let result = response.content {
                        print(">>๐ ๊ธฐ์์ฌ ์ด์ฉ ๊ฐ์ด๋ ๋ถ๋ฌ์ค๊ธฐ ์ฑ๊ณต")
                        viewController.guideList = result
                        viewController.baseTableView.reloadRows(at: [[0, 3]], with: .automatic)
                        
                    } else {
                       print(">>๐ญ ๊ธฐ์์ฌ ์ด์ฉ ๊ฐ์ด๋ ๋ถ๋ฌ์ค๊ธฐ ์คํจ")
                    }
                    
                case .failure(let error):
                    print(">>๐งฒ URL: \(ConstantURL.BASE_URL)/guide/list")
                    print(">>๐ฑ \(error.localizedDescription)")
                    print(">>๐ฑ ๊ธฐ์์ฌ ์ด์ฉ ๊ฐ์ด๋ ๋ถ๋ฌ์ค๊ธฐ ํต์  ์๋ฌ")
                    print(">>๐ฑ error")
                    
            }
        }
    }
}
