//  CalendarDataManager.swift
//  TeamSB
//  Created by 구본의 on 2021/07/30.
import Foundation
import Alamofire

class CalendarDataManager {
    
    private let view: CalendarView
    
    init(view: CalendarView){
        self.view = view
    }
    
   
    func getCalMenu(viewController: CalendarViewController) {
        AF.request("\(ConstantURL.BASE_URL)/calmenu", method: .get, parameters: nil)
            .validate()
            .responseDecodable(of: MenuResponse.self) { [self] response in
                switch response.result {
                case .success(let response):
                    print(">> URL: \(ConstantURL.BASE_URL)/calmenu")
                    if response.check == true, let result = response.menu {
                        print(">> 식단 가져오기 성공")
                        viewController.calMenu = result
                        view.setSelectedMenu()
                    } else {
                        print(">> 식단 가져오기 실패")
                        
                    }
                case .failure(let error):
                    print(">> URL: \(ConstantURL.BASE_URL)/calmenu")
                    print(">> \(error.localizedDescription)")
            }
        }
    }
}
