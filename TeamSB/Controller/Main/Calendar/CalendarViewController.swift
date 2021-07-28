//
//  CalendarViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/04.
//

import UIKit
import FSCalendar
import Alamofire

//MARK: -캘린더 class
class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var menuTableView: UITableView!
  
    var selectedDate: String = ""
    var monthlyMenu: [AnyObject] = []
    var dailyMenu = [String: Any]()
    
    var morningArray: [Any] = []
    var firstLaunchArray: [Any] = []
    var secondLaunchArray: [Any] = []
    var dinnerArray: [Any] = []
    
    var morningString: String = ""
    var firstLaunchString: String = ""
    var secondLauchString: String = ""
    var dinnerString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setCalendar()
        
        
        let formatter        = DateFormatter()
        formatter.locale     = Locale(identifier: "ko_KR")
        formatter.dateFormat = "YYYY-MM-dd"
        
        selectedDate = formatter.string(from: Date())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "식단"
        getMenuAPI()
   
    }
    
//MARK: -기본 UI 설정 함수
    func setTableView() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
        let menuTableViewCellNib = UINib(nibName: "MenuTableViewCell", bundle: nil)
        menuTableView.register(menuTableViewCellNib, forCellReuseIdentifier: "MenuTableViewCell")
        
    }
    
    
    func setCalendar() {
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.placeholderType = .none
        calendar.backgroundColor = UIColor.SBColor.SB_LightGray
        calendar.appearance.weekdayTextColor = UIColor.black
        calendar.appearance.headerTitleColor = UIColor.black
        calendar.appearance.eventSelectionColor = UIColor.SBColor.SB_BaseYellow
        calendar.appearance.todayColor = UIColor.SBColor.SB_LightYellow
        calendar.appearance.todaySelectionColor = UIColor.SBColor.SB_LightYellow
        calendar.appearance.titleTodayColor = UIColor.black
        calendar.appearance.selectionColor = UIColor.SBColor.SB_BaseYellow
        calendar.headerHeight = 50
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        
    }
    
    
//MARK: -기본 함수 정리
    func setTodayMenu() {
        
        print(">> 화면에 들어왔을 때 오늘 식단을 표시해 줍니다.")
        menuTableView.reloadData()
        
    }
    
//MARK: -API 함수 정리
    
    func getMenuAPI() {
        dailyMenu.removeAll()
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
                        monthlyMenu = (jsonObj.object(forKey: "menu") as! NSArray) as [AnyObject]
                        
                        for i in 0..<monthlyMenu.count {
                            let data = monthlyMenu[i] as! NSDictionary
                            if data["일자"] as! String == selectedDate {
                                dailyMenu = data as! [String : Any]
                            }
                        }
                        
                        setTodayMenu()
                        
                        
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


extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell

        morningString = ""
        firstLaunchString = ""
        secondLauchString = ""
        dinnerString = ""
        
        if dailyMenu.count != 0 {
            let morning = dailyMenu["아침"] as! [NSArray]
            let launch = dailyMenu["점심"] as! [NSArray]
            let dinner = dailyMenu["저녁"] as! [NSArray]
            
            morningArray = morning[0] as! [Any]
            firstLaunchArray = launch[0] as! [Any]
            secondLaunchArray = launch[1] as! [Any]
            dinnerArray = dinner[0] as! [Any]
        }
       
        
        
        for i in 0..<morningArray.count {
            if i == morningArray.count - 1 {
                morningString += "\((morningArray[i] as! String))"
            } else {
                morningString += "\((morningArray[i] as! String))\n"
            }
        }
        
        
        for i in 0..<firstLaunchArray.count {
            if i == firstLaunchArray.count - 1 {
                firstLaunchString += "\((firstLaunchArray[i] as! String))"
            } else {
                firstLaunchString += "\((firstLaunchArray[i] as! String))\n"
            }
        }
        
        for i in 0..<secondLaunchArray.count {
            if i == secondLaunchArray.count - 1 {
                secondLauchString += "\((secondLaunchArray[i] as! String))"
            } else {
                secondLauchString += "\((secondLaunchArray[i] as! String))\n"
            }
        }
        
        for i in 0..<dinnerArray.count {
            if i == dinnerArray.count - 1 {
                dinnerString += "\((dinnerArray[i] as! String))"
            } else {
                dinnerString += "\((dinnerArray[i] as! String))\n"
            }
        }
        
        if indexPath.row == 0 {
            cell.timeLabel.text = "아침"
            cell.menuLabel.text = morningString
        } else if indexPath.row == 1 {
            cell.timeLabel.text = "점심1"
            cell.menuLabel.text = firstLaunchString
        } else if indexPath.row == 2 {
            cell.timeLabel.text = "점심2"
            cell.menuLabel.text = secondLauchString
        } else if indexPath.row == 3 {
            cell.timeLabel.text = "저녁"
            cell.menuLabel.text = dinnerString
        } else {
            cell.timeLabel.text = "메뉴 없음"
            cell.menuLabel.text = "메뉴 없음"
        }

        return cell
    }
}



extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dailyMenu.removeAll()
        morningString = ""
        firstLaunchString = ""
        secondLauchString = ""
        dinnerString = ""
        
        let formatter        = DateFormatter()
        formatter.locale     = Locale(identifier: "ko_KR")
        formatter.dateFormat = "YYYY-MM-dd"
        
        selectedDate = formatter.string(from: date)
        
        print("::LL \(selectedDate)")
        
    
        for i in 0..<monthlyMenu.count {
            let data = monthlyMenu[i] as! NSDictionary
            if data["일자"] as! String == selectedDate {
                dailyMenu = data as! [String : Any]
            }
        }
        
        menuTableView.reloadData()
        menuTableView.scrollToRow(at: [0, 0], at: .top, animated: true)
        
    }
    // 날짜 선택 해제 시 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //print("\(dateFormatter.string(from: date)) 해제됨")
    }
}
