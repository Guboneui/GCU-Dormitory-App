//
//  MainBaseViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import Alamofire

class MainBaseViewController: UIViewController {

    @IBOutlet weak var baseTableView: UITableView!
    @IBOutlet weak var writeBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var settingBarButtonItem: UIBarButtonItem!
    
    
    @IBOutlet weak var topBarItem_setting: UIBarButtonItem!
    @IBOutlet weak var topBarItem_write: UIBarButtonItem!
    
    
    var firstMenu: [String] = []
    var firstMenuString = ""
    var secondMenu: [String] = []
    var secondMenuString = ""
    
    var firstTimeString = ""
    var secondTimeString = ""
    
    var todayAllMenu = [String: Any]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postUserNickname()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "홈"
        self.tabBarController?.tabBar.isHidden = false
        
        setDefault()
        baseTableView.reloadData()
        setNavigationItem()
        getMenuAPI()

    }
    
//MARK: -기본 UI 함수 설정
    func setDefault() {
        firstMenu.removeAll()
        firstMenuString = ""
        secondMenu.removeAll()
        secondMenuString = ""
        todayAllMenu.removeAll()
        
    }
    
    func setTableView() {
        baseTableView.delegate = self
        baseTableView.dataSource = self
        baseTableView.rowHeight = UITableView.automaticDimension
        baseTableView.estimatedRowHeight = 100
        baseTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        baseTableView.allowsSelection = false
    
        
        let searchButtonTableViewCellNib = UINib(nibName: "SearchButtonTableViewCell", bundle: nil)
        baseTableView.register(searchButtonTableViewCellNib, forCellReuseIdentifier: "SearchButtonTableViewCell")
        
        let categoryButtonTableViewCellNib = UINib(nibName: "CategoryButtonTableViewCell", bundle: nil)
        baseTableView.register(categoryButtonTableViewCellNib, forCellReuseIdentifier: "CategoryButtonTableViewCell")
        
        let recentPostViewTableViewCellNib = UINib(nibName: "RecentPostViewTableViewCell", bundle: nil)
        baseTableView.register(recentPostViewTableViewCellNib, forCellReuseIdentifier: "RecentPostViewTableViewCell")
        
        let nowTimeMenuTableViewCellNib = UINib(nibName: "NowTimeMenuTableViewCell", bundle: nil)
        baseTableView.register(nowTimeMenuTableViewCellNib, forCellReuseIdentifier: "NowTimeMenuTableViewCell")
    }
    
    func setNavigationItem() {  //중복 클릭 방지를 위한 세팅
        topBarItem_setting.isEnabled = true
        topBarItem_write.isEnabled = true
    }
    
//MARK: -API 함수 정리

    func postUserNickname() {
        let URL = "http://13.209.10.30:3000/getUser/nickname"
        let id = UserDefaults.standard.string(forKey: "userID")
        let PARAM: Parameters = [
            "id": id!
        ]
        let alamo = AF.request(URL, method: .post, parameters: PARAM).validate(statusCode: 200...500)
        
        alamo.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    print(">> \(URL)")
                    print(">> 유저 닉네임 API 호출 성공")
                    
                    let result = jsonObj.object(forKey: "check") as! Bool
                    if result == true {
                        let message = jsonObj.object(forKey: "message") as! String
                        print(">> \(message)")
                        let userNickname = jsonObj.object(forKey: "content") as! String
                        UserDefaults.standard.setValue(userNickname, forKey: "userNickname")
                        print(">> 유저 닉네임: \(UserDefaults.standard.string(forKey: "userNickname")!)")
                        print(">> 유저 닉네임 저장 성공")
                    } else {
                        //에러 코드 추가 필요
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
                        
                        
                        
                        //오늘에 해당하는 배열 인덱스 가져옴
                        for i in 0..<menu.count {
                            let dateMenu = menu[i] as! NSDictionary
                            if dateMenu["일자"] as! String == date {
                                todayAllMenu = dateMenu as! [String : Any]
                            }
                        }
                        
                        
                        //현재 시간 값을 받아옴
                        let today: String = hourFormatter.string(from: Date())
                        let nowTime: Int = Int(today)!
                  
                        
                        if nowTime >= 0 && nowTime < 9 {
                            print("아침이에요")
                            let morningMenu = todayAllMenu["아침"] as! NSArray
                            let firstMenu = morningMenu[0] as! NSArray
                
                            for i in 0..<firstMenu.count {
                                if i == firstMenu.count - 1 {
                                    firstMenuString += "\((firstMenu[i] as! String))"
                                } else {
                                    firstMenuString += "\((firstMenu[i] as! String))\n"
                                }
                                
                            }
                            firstTimeString = "아침"
                            
                            baseTableView.reloadRows(at: [[0, 3]], with: .automatic)

                        } else if nowTime >= 9 && nowTime < 14 {
                            print("점심이에요")
                            
                            let launchMenu = todayAllMenu["점심"] as! NSArray
                            
                            let firstMenu = launchMenu[0] as! NSArray
                            let secondMenu = launchMenu[1] as! NSArray
                            
                            for i in 0..<firstMenu.count {
                                if i == firstMenu.count - 1 {
                                    firstMenuString += "\((firstMenu[i] as! String))"
                                } else {
                                    firstMenuString += "\((firstMenu[i] as! String))\n"
                                }
                                
                            }
                            firstTimeString = "점심1"
                            
                            for i in 0..<secondMenu.count {
                                if i == secondMenu.count - 1 {
                                    secondMenuString += "\((secondMenu[i] as! String))"
                                } else {
                                    secondMenuString += "\((secondMenu[i] as! String))\n"
                                }
                                
                            }
                            secondTimeString = "점심2"
                            
                            baseTableView.reloadRows(at: [[0, 3]], with: .automatic)
                            baseTableView.reloadRows(at: [[0, 4]], with: .automatic)
                            
                            
                        } else if nowTime >= 14 && nowTime < 20 {
                            print("저녁이에요")
                            
                            let dinnerMenu = todayAllMenu["저녁"] as! NSArray
                            let firstMenu = dinnerMenu[0] as! NSArray
                            
                            for i in 0..<firstMenu.count {
                                if i == firstMenu.count - 1 {
                                    firstMenuString += "\((firstMenu[i] as! String))"
                                } else {
                                    firstMenuString += "\((firstMenu[i] as! String))\n"
                                }
                                
                            }
                            firstTimeString = "저녁"
                            
                            baseTableView.reloadRows(at: [[0, 3]], with: .automatic)
                            
                        } else {
                            
                            firstTimeString = "잘 시간 이에요"
                            firstMenuString = "오늘 메뉴는\n어떠셨나요??"
                            
                            baseTableView.reloadRows(at: [[0, 3]], with: .automatic)
                            
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
    

//MARK: -스토리보드 Action함수 정리
    @IBAction func writeBarButtonAction(_ sender: Any) {
        print("글쓰기 화면으로 이동합니다.")
        
        topBarItem_write.isEnabled = false
        topBarItem_setting.isEnabled = false
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "WriteViewController") as! WriteViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func settingBarButtonAction(_ sender: Any) {
        print("세팅 화면으로 이동합니다.")
        
        topBarItem_write.isEnabled = false
        topBarItem_setting.isEnabled = false
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainBaseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let hourFormatter        = DateFormatter()
        hourFormatter.locale     = Locale(identifier: "ko_KR")
        hourFormatter.dateFormat = "HH"
        
        //현재 시간 값을 받아옴
        let today: String = hourFormatter.string(from: Date())
        let nowTime: Int = Int(today)!
  

        // 점심에는 메뉴 2개, 아침 저녁 메뉴 1개
        if nowTime >= 9 && nowTime < 14 {
            return 5
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchButtonTableViewCell", for: indexPath) as! SearchButtonTableViewCell
            cell.searchButton.addTarget(self, action: #selector(goSearchView), for: .touchUpInside)
        
            return cell
            
        } else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryButtonTableViewCell", for: indexPath) as! CategoryButtonTableViewCell
            cell.delevaryButton.addTarget(self, action: #selector(goDelevaryView), for: .touchUpInside)
            cell.postButton.addTarget(self, action: #selector(goPostView), for: .touchUpInside)
            cell.taxiButton.addTarget(self, action: #selector(goTaxiView), for: .touchUpInside)
            cell.laundaryButton.addTarget(self, action: #selector(goLaundayView), for: .touchUpInside)
            
            return cell
            
        } else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentPostViewTableViewCell", for: indexPath) as! RecentPostViewTableViewCell
            
            cell.showMoreButton.addTarget(self, action: #selector(goShowMoreView), for: .touchUpInside)
            cell.getRecentPost()
            cell.delegate = self
            
            return cell
            
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NowTimeMenuTableViewCell", for: indexPath) as! NowTimeMenuTableViewCell
            

            cell.timeLabel.text = firstTimeString
            cell.menuLabel.text = firstMenuString
            
            
            return cell
        }
        
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NowTimeMenuTableViewCell", for: indexPath) as! NowTimeMenuTableViewCell
    
            cell.timeLabel.text = secondTimeString
            cell.menuLabel.text = secondMenuString
            
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func goSearchView() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goDelevaryView() {
        let storyBoard = UIStoryboard(name: "Post", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DeleveryViewController") as! DeleveryViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func goPostView() {
        let storyBoard = UIStoryboard(name: "Post", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ParcelViewController") as! ParcelViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func goTaxiView() {
        let storyBoard = UIStoryboard(name: "Post", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TaxiViewController") as! TaxiViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func goLaundayView() {
        let storyBoard = UIStoryboard(name: "Post", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "LaundryViewController") as! LaundryViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    @objc func goShowMoreView() {
        let storyBoard = UIStoryboard(name: "Post", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ShowMoreViewController") as! ShowMoreViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


extension MainBaseViewController: TBCellDelegate {
    func selectedTBCell(postNumber: Int, title: String, category: String, time: String, userID: String, nickname: String, contents: String, showCount: Int) {
        print("프로토콜 연결 성공")
        
        guard let vc = UIStoryboard(name: "In_Post", bundle: nil).instantiateViewController(withIdentifier: "DetailPostViewController") as? DetailPostViewController else {
            return
        }
        
        vc.getPostNumber = postNumber
        vc.getTitle = title
        vc.getCategory = category
        vc.getTime = time
        vc.getUserID = userID
        vc.getNickname = nickname
        vc.getContents = contents
        vc.getShowCount = showCount
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
}
