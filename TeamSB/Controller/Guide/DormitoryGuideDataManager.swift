//
//  DormitoryGuideDataManager.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/19.
//

import Foundation
import Alamofire

class DormitoryGuideDataManager {
    private let view: DormitoryView
    
    init(view: DormitoryView){
        self.view = view
    }
    
    func getGuide(viewController: DormitoryGuideViewController) {
        AF.request("\(ConstantURL.BASE_URL)/guide/list", method: .get)
            .validate()
            .responseDecodable(of: GetGuideResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">> URL: \(ConstantURL.BASE_URL)/guide/list")
                    if response.check == true, let result = response.content {
                        print(">> 기숙사 이용 가이드 불러오기 성공")
                        viewController.guideList = result
                        view.reloadTableView()
                        
                    } else {
                       print(">> 기숙사 이용 가이드 불러오기")
                    }
                    
                case .failure(let error):
                    print(">> URL: \(ConstantURL.BASE_URL)/guide/list")
                    print(">> \(error.localizedDescription)")
                    print(">> 기숙사 이용 가이드 불러오기 통신 에러")
                    print(error)
                    
            }
        }
    }
}
