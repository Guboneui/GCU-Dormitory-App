//  MainBaseViewController.swift
//  TeamSB
//  Created by 구본의 on 2021/07/14.

import UIKit
import Alamofire

class MainBaseViewController: UIViewController {

    @IBOutlet weak var baseTableView: UITableView!
    @IBOutlet weak var writeBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var settingBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var topBarItem_setting: UIBarButtonItem!
    @IBOutlet weak var topBarItem_write: UIBarButtonItem!
    
    var firstMenuString = ""
    var secondMenuString = ""
    var firstTimeString = ""
    var secondTimeString = ""
    
    var calMenu: [Menu] = []
    lazy var dataManager: MainDataManager = MainDataManager(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManagerSetNickname()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "홈"
        self.tabBarController?.tabBar.isHidden = false
        
        setDefault()
        setNavigationItem()
        baseTableView.reloadData()
        dataManager.getCalMenu(viewController: self)

    }
}

//MARK: -기본 UI 함수 설정
extension MainBaseViewController {
   
    func dataManagerSetNickname() {
        let id = UserDefaults.standard.string(forKey: "userID")!
        let param = GetUserNicknameRequest(id: id)
        dataManager.postNickName(param, viewController: self)
    }
    
    func setDefault() {
        calMenu.removeAll()
        firstMenuString = ""
        secondMenuString = ""
    }
    
    func setTableView() {
        baseTableView.delegate = self
        baseTableView.dataSource = self
        baseTableView.rowHeight = UITableView.automaticDimension
        baseTableView.estimatedRowHeight = 100
        baseTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        baseTableView.allowsSelection = false
        
        
        let noticeAutoScrollCellNib = UINib(nibName: "AutoScrollNoticeTableViewCell", bundle: nil)
        baseTableView.register(noticeAutoScrollCellNib, forCellReuseIdentifier: "AutoScrollNoticeTableViewCell")
        
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
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        tabBarController?.tabBar.barTintColor = .white
    }

}

//MARK: -스토리보드 Action함수 정리
extension MainBaseViewController {
    
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

//MARK: -테이블뷰 세팅
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "AutoScrollNoticeTableViewCell", for: indexPath) as! AutoScrollNoticeTableViewCell
            //cell.searchButton.addTarget(self, action: #selector(goSearchView), for: .touchUpInside)
        
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
            dataManager.getRecentPost(view: cell)
            cell.delegate = self
            
            return cell
            
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NowTimeMenuTableViewCell", for: indexPath) as! NowTimeMenuTableViewCell
            
            cell.timeLabel.text = firstTimeString
            cell.menuLabel.text = firstMenuString
            
            return cell
        } else {
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

//MARK: -TBCellDelegate 선언 부분
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

//MARK: -DataManager 연결 함수
extension MainBaseViewController: MainView {
    func setUserNickname(nickname: String) {
        UserDefaults.standard.setValue(nickname, forKey: "userNickname")
    }
    
    func setTodayMenu() {
        
        let hourFormatter        = DateFormatter()
        hourFormatter.locale     = Locale(identifier: "ko_KR")
        hourFormatter.dateFormat = "HH"
        
        let dateFormatter        = DateFormatter()
        dateFormatter.locale     = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        let date: String = dateFormatter.string(from: Date())
        let today: String = hourFormatter.string(from: Date())
        let nowTime: Int = Int(today)!
        
        
        //오늘에 해당하는 배열 인덱스 가져옴
        for i in 0..<calMenu.count {
            let dateMenu = calMenu[i]
            if dateMenu.일자 == date {
                if nowTime >= 0 && nowTime < 9 {
                    for i in 0..<dateMenu.아침[0].count {
                        if i == dateMenu.아침[0].count - 1 {
                            firstMenuString += "\(dateMenu.아침[0][i])"
                        } else {
                            firstMenuString += "\(dateMenu.아침[0][i])\n"
                        }
                    }
                    firstTimeString = "아침"
                    baseTableView.reloadRows(at: [[0, 3]], with: .automatic)

                } else if nowTime >= 9 && nowTime < 14 {
                    for i in 0..<dateMenu.점심[0].count {
                        if i == dateMenu.점심[0].count - 1 {
                            firstMenuString += "\(dateMenu.점심[0][i])"
                        } else {
                            firstMenuString += "\(dateMenu.점심[0][i])\n"
                        }
                    }
                    firstTimeString = "점심1"
                    
                    
                    for i in 0..<dateMenu.점심[1].count {
                        if i == dateMenu.점심[1].count - 1 {
                            secondMenuString += "\(dateMenu.점심[1][i])"
                        } else {
                            secondMenuString += "\(dateMenu.점심[1][i])\n"
                        }
                    }
                    secondTimeString = "점심2"
        
                    baseTableView.reloadRows(at: [[0, 3]], with: .automatic)
                    baseTableView.reloadRows(at: [[0, 4]], with: .automatic)
        
        
                } else if nowTime >= 14 && nowTime < 20 {
                    for i in 0..<dateMenu.저녁[0].count {
                        if i == dateMenu.저녁[0].count - 1 {
                            firstMenuString += "\(dateMenu.저녁[0][i])"
                        } else {
                            firstMenuString += "\(dateMenu.저녁[0][i])\n"
                        }
                    }
                    firstTimeString = "저녁"
                    baseTableView.reloadRows(at: [[0, 3]], with: .automatic)


                } else {
                    firstTimeString = "하루를 마무리 할 시간이에요"
                    firstMenuString = "오늘 메뉴는\n어떠셨나요??"
                    baseTableView.reloadRows(at: [[0, 3]], with: .automatic)
        
                }
                
            }
        }
    }
}
