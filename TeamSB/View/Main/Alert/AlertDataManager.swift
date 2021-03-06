//  AlertDataManager.swift
//  TeamSB
//  Created by κ΅¬λ³Έμ on 2021/08/14.


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
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/notification/list?page=\(viewController.currentPage)")
                    view.stopRefreshControl()
                    view.stopLoading()
                    
                    if response.check == true, let result = response.content {
                        print(">>π λμ λκΈ μλ¦Ό λΆλ¬μ€κΈ° μ±κ³΅")
                        
                        guard result.count > 0 else {
                            view.stopLoading()
                            print(">>π λμ΄μ μ½μ΄μ¬ μλ¦Ό μμ")
                            print(">>π μ΄ μ½μ΄μ¨ μλ¦Ό κ°μ = \(viewController.alertPost.count)")
                            viewController.isLoadedAllData = true
                            return
                        }
                        
                        for i in 0..<result.count {
                            viewController.alertPost.append(result[i])
                        }
                        print(">>π μ½μ΄μ¨ μλ¦Ό κ°μ: \(result.count), νμ¬ νμ΄μ§\(viewController.currentPage)")
                        
                        viewController.mainTableView.reloadData()
                    } else {
                        print(">>π­ λμ λκΈ μλ¦Ό λΆλ¬μ€κΈ° μ€ν¨")
                        
                    }
                case .failure(let error):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/notification/list?page=\(viewController.currentPage)")
                    print(">>π± \(error.localizedDescription)")
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
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/notification/read/all")
                    
                    view.stopLoading()
                    
                    if response.check == true {
                        print(">>π λκΈ μλ¦Ό μ μ²΄ μ½κΈ° μ±κ³΅")
                        //viewController.mainTableView.reloadData()
                        view.reloadTableview()
                    } else {
                        print(">>π­ λμ λκΈ μλ¦Ό μ μ²΄ μ½κΈ° μ€ν¨")
                    }
                case .failure(let error):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/notification/read/all")
                    print(">>π± \(error.localizedDescription)")
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
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/notification/read")
                    
                    //view.stopLoading()
                    
                    if response.check == true {
                        print(">>π μλ¦Ό μ½μ μ²λ¦¬ μ±κ³΅")
                        //viewController.mainTableView.reloadData()
                        //view.reloadTableview()
                    } else {
                        print(">>π­ μλ¦Ό μ½μ μ²λ¦¬ μ€ν¨")
                    }
                case .failure(let error):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/notification/read")
                    print(">>π± \(error.localizedDescription)")
            }
        }
    }
    
    func postExist(_ parameters: ExistsArticleRequest, viewController: AlertViewController) {
        AF.request("\(ConstantURL.BASE_URL)/accessArticle/detail", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: ExistsArticleResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/accessArticle/detail")
                    view.stopLoading()
                    if response.check == true {
                        print(">>π μ‘΄μ¬νλ κΈμλλ€. ν΄λΉ κ²μκΈλ‘ μ΄λν©λλ€.")
                        let data = response.content![0]
                        view.goArticle(no: data.no, title: data.title, category: data.category, timeStamp: data.timeStamp, userNickname: data.userNickname, text: data.text, viewCount: data.viewCount, userId: data.userId, hash: data.hash, imageSource: data.imageSource)
                    } else {
                        print(">>π­ μ­μ  λλ μ κ³  λ κΈμ΄λ―λ‘ μ κ·Όν  μ μμ΅λλ€.")
                        viewController.presentAlert(title: response.message)
                    }
                case .failure(let error):
                    view.stopLoading()
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/accessArticle/detail")
                    print(">>π± \(error.localizedDescription)")
            }
        }
    }
    
    
}
