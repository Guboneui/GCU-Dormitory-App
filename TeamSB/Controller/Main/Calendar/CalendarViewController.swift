//
//  CalendarViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/04.
//

import UIKit
import FSCalendar
import Alamofire

//MARK: -캘린더 API 구조 정리
struct Menu {
    var date: String = ""
    var morning: [[String]] = []
    var launch: [[String]] = []
    var dinner: [[String]] = []
}

class GetMenu {
    static var menuArray = GetMenu()
    var listData = [Menu]()
    private init() {}
}


//MARK: -캘린더 class
class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var menuTableView: UITableView!
    
    var menuArr = [AnyObject]()
    var menuData = GetMenu.menuArray
    var menuTableViewDataArray: [Menu] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setCalendar()
        getMenuAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "식단"
   
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
        calendar.locale = Locale(identifier: "ko_KR")
    }
    
    
//MARK: -기본 함수 정리
    func setTodayMenu() {
        
        print(">> 화면에 들어왔을 때 오늘 식단을 표시해 줍니다.")
        let formatter        = DateFormatter()
        formatter.locale     = Locale(identifier: "ko_KR")
        formatter.dateFormat = "YYYY-MM-dd"
        
        let today: String = formatter.string(from: Date())
        
        let data = menuData.listData
        
        for i in 0..<data.count {
            let menuData = data[i]
            if menuData.date == today {
                menuTableViewDataArray.append(Menu(date: menuData.date, morning: menuData.morning, launch: menuData.launch, dinner: menuData.dinner))
            }
        }
        
        menuTableView.reloadData()
        
    }
    
//MARK: -API 함수 정리
    
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
                        
                        for i in 0..<menu.count {
                            
                            let dateMenu = menu[i] as! NSDictionary
                            
                            let date = dateMenu["일자"] as! String
                            let morning = dateMenu["아침"] as! [[String]]
                            
                            let launch = dateMenu["점심"] as! [[String]]
                            let dinner = dateMenu["저녁"] as! [[String]]
                            
                            self.menuData.listData.append(Menu(date: date, morning: morning, launch: launch, dinner: dinner))
                        
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
        
        if menuTableViewDataArray.count == 0 {
            return 0
        } else {
            let data = menuTableViewDataArray[0]
            let morning = data.morning
            let launch = data.launch
            let dinner = data.dinner
            let totalCount: Int = morning.count + launch.count + dinner.count
            
            return totalCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        let data = menuTableViewDataArray[0]
    
        if data.morning.count == 1 {
            menuArr.append(data.morning[0] as AnyObject)
        } else {
            for i in 0..<data.morning.count {
                menuArr.append(data.morning[i] as AnyObject)
            }
        }
        
        if data.launch.count == 1 {
            menuArr.append(data.launch[0] as AnyObject)
        } else {
            for i in 0..<data.launch.count {
                menuArr.append(data.launch[i] as AnyObject)
            }
        }
        
        if data.dinner.count == 1 {
            menuArr.append(data.dinner[0] as AnyObject)
        } else {
            for i in 0..<data.dinner.count {
                menuArr.append(data.dinner[i] as AnyObject)
            }
        }
        
        var menuString = ""
        let k = menuArr[indexPath.row] as! NSArray
       
        for i in 0..<k.count {
            
            if i == k.count - 1 {
                menuString += "\((k[i] as! String))"
            } else {
                menuString += "\((k[i] as! String))\n"
            }
            
        }
        
        print(menuString)
        
        if indexPath.row == 0 {
            cell.timeLabel.text = "아침"
        } else if indexPath.row == 1 {
            cell.timeLabel.text = "점심1"
        } else if indexPath.row == 2 {
            cell.timeLabel.text = "점심2"
        } else if indexPath.row == 3 {
            cell.timeLabel.text = "저녁"
        } else {
            cell.timeLabel.text = "kkk"
        }
        
        cell.menuLabel.text = menuString
        
        return cell
    }
}



extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        menuTableViewDataArray.removeAll()
        
        let formatter        = DateFormatter()
        formatter.locale     = Locale(identifier: "ko_KR")
        formatter.dateFormat = "YYYY-MM-dd"
        
        let selectDate: String = formatter.string(from: date)
        
        let data = menuData.listData
        
        for i in 0..<data.count {
            let menuData = data[i]
            if menuData.date == selectDate {
                menuTableViewDataArray.append(Menu(date: menuData.date, morning: menuData.morning, launch: menuData.launch, dinner: menuData.dinner))
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
