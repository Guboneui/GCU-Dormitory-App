//  MainBaseViewController.swift
//  TeamSB
//  Created by κ΅¬λ³Έμ on 2021/07/14.

import UIKit
import Alamofire
import NVActivityIndicatorView
import Photos

class MainBaseViewController: UIViewController {

    @IBOutlet weak var baseTableView: UITableView!
    
    @IBOutlet weak var settomgBarButtonItem: UIButton!
    @IBOutlet weak var searchBarButtonItem: UIButton!
    @IBOutlet weak var noticeBarButtonItem: UIButton!
    @IBOutlet weak var noticeImage: UIImageView!
    
   
    
    var firstMenuString: String? = ""
    var secondMenuString: String? = ""
    var firstTimeString = ""
    var secondTimeString = ""
    var currentPage = 0
    
    var guideList: [GuideList] = []
    
    var loading: NVActivityIndicatorView!

    var bannerList: [String] = []
    var calMenu: [Menu] = []
    lazy var dataManager: MainDataManager = MainDataManager(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        UIApplication.shared.registerForRemoteNotifications()
        setLoading()
        getProfileImage()
        dataManagerSetNickname()
        setTableView()
        
        
        let id = UserDefaults.standard.string(forKey: "userID")!
        let token = UserDefaults.standard.string(forKey: "FCMToken")!
        let param = FCMRequest(curUser: id, token: token)
        dataManager.fcmToken(param, viewController: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            if UserDefaults.standard.bool(forKey: "tutorial") != true {
                print(">>π€ μ± μ΅μ΄ μ μμ μ΄λ―λ‘ νν λ¦¬μΌ νλ©΄μΌλ‘ μ΄λν©λλ€.")
                let storyBoard = UIStoryboard(name: "Login", bundle: nil)
                let tutorialVC = storyBoard.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
                tutorialVC.delegate = self
                tutorialVC.modalPresentationStyle = .fullScreen
                self.present(tutorialVC, animated: true, completion: nil)
                UserDefaults.standard.set(true, forKey: "tutorial")
            } else {
                print(">>π€ νν λ¦¬μΌμ μ΄λ―Έ λ³Έ μ μ μλλ€.")
            }
            
        })
       
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "ν"
        self.tabBarController?.tabBar.isHidden = true
        
        //loading.startAnimating()
        CustomLoader.instance.showLoader()
        
        setDefault()
        setNavigationItem()
        baseTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        baseTableView.reloadData()
        dataManager.getCalMenu(viewController: self)
        checkUserAlertCount()
        
        guideList.removeAll()
        dataManager.getGuide(viewController: self)
        
        print("π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½π½")
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        print("π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦π¦")
    }
    
}

//MARK: -κΈ°λ³Έ UI ν¨μ μ€μ 
extension MainBaseViewController {
    func setLoading() {
        loading = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: UIColor.SBColor.SB_BaseYellow, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 60),
            loading.heightAnchor.constraint(equalToConstant: 60),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func checkUserAlertCount() {
        let id = UserDefaults.standard.string(forKey: "userID")!
        let param = CheckUserAlertRequest(curUser: id)
        dataManager.getCheckUserAlert(param, viewController: self)
    }
    
   
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
        baseTableView.estimatedRowHeight = 75
        baseTableView.refreshControl = UIRefreshControl()
        baseTableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
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
        
        let honeyTipTableViewCellNib = UINib(nibName: "HoneyTipTableViewCell", bundle: nil)
        baseTableView.register(honeyTipTableViewCellNib, forCellReuseIdentifier: "HoneyTipTableViewCell")
        
        let nowTimeMenuTableViewCellNib = UINib(nibName: "NowTimeMenuTableViewCell", bundle: nil)
        baseTableView.register(nowTimeMenuTableViewCellNib, forCellReuseIdentifier: "NowTimeMenuTableViewCell")
    }
    
    func setNavigationItem() {  //μ€λ³΅ ν΄λ¦­ λ°©μ§λ₯Ό μν μΈν
        settomgBarButtonItem.isEnabled = true
        searchBarButtonItem.isEnabled = true
        noticeBarButtonItem.isEnabled = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        tabBarController?.tabBar.barTintColor = .white
    }
    
    func getProfileImage() {
        let id = UserDefaults.standard.string(forKey: "userID")!
        let param = GetProfileImageRequest(curId: id)
        dataManager.postProfileImage(param, viewController: self)
    }

}



//MARK: -μ€ν λ¦¬λ³΄λ Actionν¨μ μ λ¦¬
extension MainBaseViewController {
    
    @objc func refreshData() {
        print(">> μλ¨ μλ‘κ³ μΉ¨")
        checkUserAlertCount()
        
        guideList.removeAll()
        dataManager.getGuide(viewController: self)
        
        calMenu.removeAll()
        firstMenuString = ""
        secondMenuString = ""
        dataManager.getCalMenu(viewController: self)
        
        baseTableView.reloadData()
    }
    
    @IBAction func searchBarButtonAction(_ sender: UIButton) {
        print("κ²μ νλ©΄μΌλ‘ μ΄λν©λλ€.")
        
        settomgBarButtonItem.isEnabled = false
        searchBarButtonItem.isEnabled = false
        noticeBarButtonItem.isEnabled = false
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func settingBarButtonAction(_ sender: UIButton) {
        print("μΈν νλ©΄μΌλ‘ μ΄λν©λλ€.")
        
        settomgBarButtonItem.isEnabled = false
        searchBarButtonItem.isEnabled = false
        noticeBarButtonItem.isEnabled = false
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func noticeBarButtonAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
}

//MARK: -νμ΄λΈλ·° μΈν
extension MainBaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
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
            cell.roommateButton.addTarget(self, action: #selector(goLaundayView), for: .touchUpInside)
            
            
            return cell
            
        } else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentPostViewTableViewCell", for: indexPath) as! RecentPostViewTableViewCell
            cell.showMoreButton.addTarget(self, action: #selector(goShowMoreView), for: .touchUpInside)
            dataManager.getRecentPost(view: cell, viewController: self)
            cell.delegate = self
            return cell
            
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HoneyTipTableViewCell", for: indexPath) as! HoneyTipTableViewCell

            cell.showMoreButton.addTarget(self, action: #selector(showMoreGuide), for: .touchUpInside)
            
            if guideList.count == 0 {
                cell.titleLabel.text = ""
                cell.contentsLabel.text = ""
            } else {
                let number = Int.random(in: 0..<guideList.count)
                let data = guideList[number]
                cell.titleLabel.text = data.title
                cell.contentsLabel.text = data.content
            }
            
            
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NowTimeMenuTableViewCell", for: indexPath) as! NowTimeMenuTableViewCell
            
            cell.timeLabel.text = firstTimeString
            cell.menuLabel.text = firstMenuString
            cell.subMenuLabel.text = secondMenuString
            
            return cell
        }else {
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
        let vc = storyBoard.instantiateViewController(withIdentifier: "RoomMateViewController") as! RoomMateViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    @objc func goShowMoreView() {
        let storyBoard = UIStoryboard(name: "Post", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ShowMoreViewController") as! ShowMoreViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func showMoreGuide() {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DormitoryGuideViewController") as! DormitoryGuideViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
}



//MARK: -TBCellDelegate μ μΈ λΆλΆ
extension MainBaseViewController: TBCellDelegate {
    func selectedTBCell(postNumber: Int, title: String, category: String, time: String, userID: String, nickname: String, contents: String, showCount: Int, hash: [String], imageSource: String, replyCount: Int) {
        print("νλ‘ν μ½ μ°κ²° μ±κ³΅")
        
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
        vc.getHash = hash
        vc.getMainTitle = category
        vc.getImage = imageSource
//        vc.getReplyCount = replyCount
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
}

//MARK: -DataManager μ°κ²° ν¨μ
extension MainBaseViewController: MainView {
    func setNoticeColor(notificationCount: Int) {
        if notificationCount == 0 {
            noticeImage.image = UIImage(named: "notice_icon")
        } else {
            noticeImage.image = UIImage(named: "exist_notice_icon")
        }
    }
    
    
   
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


        //μ€λμ ν΄λΉνλ λ°°μ΄ μΈλ±μ€ κ°μ Έμ΄
        for i in 0..<calMenu.count {
            let dateMenu = calMenu[i]
            if dateMenu.μΌμ == date {
                if nowTime >= 0 && nowTime < 9 {
                    for i in 0..<dateMenu.μμΉ¨[0].count {
                        if i == dateMenu.μμΉ¨[0].count - 1 {
                            firstMenuString! += "\(dateMenu.μμΉ¨[0][i])"
                        } else {
                            firstMenuString! += "\(dateMenu.μμΉ¨[0][i])\n"
                        }
                    }
                    firstTimeString = "μμΉ¨ (08:00~09:30)"
                    secondMenuString = "μ€λΉλ λ©λ΄κ°\nμμ΅λλ€."
                    baseTableView.reloadRows(at: [[0, 4]], with: .automatic)

                } else if nowTime >= 9 && nowTime < 14 {
                    for i in 0..<dateMenu.μ μ¬[0].count {
                        if i == dateMenu.μ μ¬[0].count - 1 {
                            firstMenuString! += "\(dateMenu.μ μ¬[0][i])"
                        } else {
                            firstMenuString! += "\(dateMenu.μ μ¬[0][i])\n"
                        }
                    }
                    firstTimeString = "μ μ¬ (11:45~14:00)"


                    for i in 0..<dateMenu.μ μ¬[1].count {
                        if i == dateMenu.μ μ¬[1].count - 1 {
                            secondMenuString! += "\(dateMenu.μ μ¬[1][i])"
                        } else {
                            secondMenuString! += "\(dateMenu.μ μ¬[1][i])\n"
                        }
                    }


                    firstMenuString = firstMenuString!
                    secondMenuString = secondMenuString!


                    //secondTimeString = "μ μ¬2"

                    baseTableView.reloadRows(at: [[0, 4]], with: .automatic)



                } else if nowTime >= 14 && nowTime < 20 {
                    for i in 0..<dateMenu.μ λ[0].count {
                        if i == dateMenu.μ λ[0].count - 1 {
                            firstMenuString! += "\(dateMenu.μ λ[0][i])"
                        } else {
                            firstMenuString! += "\(dateMenu.μ λ[0][i])\n"
                        }
                    }
                    firstTimeString = "μ λ (17:00~18:30)"
                    secondMenuString = "μ€λΉλ λ©λ΄κ°\nμμ΅λλ€."
                    baseTableView.reloadRows(at: [[0, 4]], with: .automatic)


                } else {
                    firstTimeString = "νλ£¨λ₯Ό λ§λ¬΄λ¦¬ ν  μκ°μ΄μμ"
                    firstMenuString = "μ€λ λ©λ΄λ\nμ΄λ μ¨λμ??"
                    secondMenuString = "μ€λ λ©λ΄λ\nμ΄λ μ¨λμ??" 
                    baseTableView.reloadRows(at: [[0, 4]], with: .automatic)

                }

            }
        }
    }
}


extension MainBaseViewController: PhotoAccess {
    func showPhotoAccess() {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { authorizationStatus in
                switch authorizationStatus {
                case .limited:
                    print("limited authorization granted") // μ νν μ¬μ§μ λν΄μλ§ νμ©.
                case .authorized:
                    print("authorization granted") // λͺ¨λ  κΆν νμ©.
                default: print("Unimplemented")
                    
                }
                
            }
        } else {
            PHPhotoLibrary.requestAuthorization { authorizationStatus in
                switch authorizationStatus {
                case .limited:
                    print("limited authorization granted") // μ νν μ¬μ§μ λν΄μλ§ νμ©.
                case .authorized:
                    print("authorization granted") // λͺ¨λ  κΆν νμ©.
                default: print("Unimplemented")
                    
                }
                
            }
        }
    }
    
    
}
