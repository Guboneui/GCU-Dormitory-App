//
//  SplashDataManager.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/25.
//

import Foundation
import UIKit
import Alamofire

class SplashDataManager {
    
    private let view: splashView
    
    init(view: splashView){
        self.view = view
    }
    
    func getVersion(version: String, viewController: SplashViewController) {
        print(">> 앱 버전을 확인합니다.")
        AF.request("\(ConstantURL.BASE_URL)/getVersion/ios", method: .get, headers: nil)
            .validate()
            .responseDecodable(of: getVersionResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">>URL: \(ConstantURL.BASE_URL)/getVersion/ios")
                    if response.check == true {
                        print(">>😎 버전 정보를 얻어왔어요!")
                        if response.curVersion == version {
                            print(">> 최신 버전을 사용중입니다.")
                            view.changeView()
                        } else {
                            print(">> 최신 버전으로 업데이트가 필요합니다.")
                            let alert = UIAlertController(title: "업데이트", message: "최신 버전이 출시 되었어요~🥳", preferredStyle: .alert)
                            let cancelButton = UIAlertAction(title: "나중에", style: .cancel, handler: { _ in
                                print(">> 나중에 업데이트 할래요")
                                view.changeView()
                            })
                            let okButton = UIAlertAction(title: "업데이트", style: .default, handler: { _ in
                                print(">> 지금 업데이트 할래요")
                                viewController.check = true
                                if let appStore = URL(string: "https://apps.apple.com/kr/app/%EA%B0%80%EC%B2%9C-%EA%B8%B0%EC%88%99%EC%82%AC/id1578277392") {
                                    UIApplication.shared.open(appStore, options: [:], completionHandler: nil)
                                }
                            })
                            
                            okButton.setValue(UIColor(displayP3Red: 66/255, green: 66/255, blue: 66/255, alpha: 1), forKey: "titleTextColor")
                            cancelButton.setValue(UIColor(displayP3Red: 255/255, green: 63/255, blue: 63/255, alpha: 1), forKey: "titleTextColor")
                            alert.addAction(cancelButton)
                            alert.addAction(okButton)
                            viewController.present(alert, animated: true, completion: nil)
                            
                        }
                        
                       
                    } else {
                        print(">>😭 왜 에러가 뜰까요 ㅠㅠ")
                    
                    }
                case .failure(let error):
                    print(">>URL: \(ConstantURL.BASE_URL)/getVersion/ios")
                    print(">> \(error.localizedDescription)")
                    print(">>😱 \(error)")
            }
        }
    }
    
    
}
