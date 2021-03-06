//
//  LaundryDataManager.swift
//  TeamSB
//
//  Created by κ΅¬λ³Έμ on 2021/07/30.
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
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/home/room-mate?page=\(viewController.currentPage)")
                    view.stopRefreshControl()
                    view.stopLoading()
                    
                    if response.check == true, let result = response.content {
                        print(">>π λ£Έλ© κ²μκΈ κ°μ Έμ€κΈ° μ±κ³΅")
                        
                        guard result.count > 0 else {
                            view.stopLoading()
                            print(">>π λμ΄μ μ½μ΄μ¬ κ²μκΈ μμ")
                            print(">>π μ΄ μ½μ΄μ¨ κ²μκΈ κ°μ = \(viewController.roommatePost.count)")
                            viewController.mainCollectionView.reloadData()
                            viewController.isLoadedAllData = true
                            return
                        }
                        
                        for i in 0..<result.count {
                            viewController.roommatePost.append(result[i])
                        }
                        print(">>π μ½μ΄μ¨ κ²μκΈμ κ°μ: \(result.count), νμ¬ νμ΄μ§\(viewController.currentPage)")
                        
                        viewController.mainCollectionView.reloadData()
                    } else {
                        if response.code == 301 {
                            view.notDate()
                        }else {
                            print(response.code)
                            print(">>π­ λ£Έλ© κ²μκΈ κ°μ Έμ€κΈ° μ€ν¨")
                        }
                        
                        
                    }
                case .failure(let error):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/home/room-mate?page=\(page)")
                    print(">>π± \(error.localizedDescription)")
            }
        }
    }
    
    func postExist(_ parameters: ExistsArticleRequest, viewController: RoomMateViewController) {
        AF.request("\(ConstantURL.BASE_URL)/accessArticle/detail", method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: ExistsArticleResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>π§² URL: \(ConstantURL.BASE_URL)/accessArticle/detail")
                    view.stopLoading()
                    if response.check == true {
                        print(">>π μ‘΄μ¬νλ κΈμλλ€. ν΄λΉ κ²μκΈλ‘ μ΄λν©λλ€.")
                        view.goArticle()
                    } else {
                        print(">>π­ μ­μ  λλ μ κ³  λ κΈ")
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

