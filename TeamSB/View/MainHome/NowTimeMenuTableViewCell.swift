//
//  NotTimeMenuTableViewCell.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import Alamofire


class NowTimeMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureDesign()
        getMenuAPI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

//MARK: -기본 UI함수 정리
    
    func configureDesign() {
        baseView.layer.cornerRadius = 10
        baseView.layer.borderWidth = 0.5
        baseView.layer.borderColor = UIColor.SBColor.SB_DarkGray.cgColor
    }
    
//MARK: -API
    func getMenuAPI() {
        let URL = "http://13.209.10.30:3000/calmenu"
        let alamo = AF.request(URL, method: .get, parameters: nil).validate(statusCode: 200...500)
        
        alamo.responseJSON { [self] (response) in
            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    print(">> \(URL)")
                    print(">> 식단 불러오기 API 호출 성공")
                    
                    let result = jsonObj.object(forKey: "check") as! Bool
                    
                    if result == true {
                        let menu = jsonObj.object(forKey: "menu") as! NSArray
                        
                        let hourFormatter        = DateFormatter()
                        hourFormatter.locale     = Locale(identifier: "ko_KR")
                        hourFormatter.dateFormat = "HH"
                        
                        let dateFormatter        = DateFormatter()
                        dateFormatter.locale     = Locale(identifier: "ko_KR")
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        
                        
                        let date: String = dateFormatter.string(from: Date())
                        
                        for i in 0..<menu.count {
                            let dateMenu = menu[i] as! NSDictionary
                            if dateMenu["일자"] as! String == date {
                                print(dateMenu)
                            }
                        }
                        
                        
                        
                        
                        //현재 시간 값을 받아옴
                        let today: String = hourFormatter.string(from: Date())
                        let nowTime: Int = Int(today)!
                  
                        
                        if nowTime >= 0 && nowTime < 9 {
                            print("아침이에요")
                        } else if nowTime >= 9 && nowTime < 14 {
                            print("점심이에요")
                        } else if nowTime >= 14 && nowTime < 20 {
                            print("저녁이에요")
                        } else {
                            print("오늘 메뉴는 어떠셨나요?")
                        }
                        
                        
                        
                        
                        
                    } else {
                        print("무엇인가 에러가 있음")
                        //Todo
                    }
                }
            case .failure(let error):
                if let jsonObj = error as? NSDictionary {
                    print("서버통신 실패")
                    print(jsonObj)
                }
            }
        }
    }

    
    
}
