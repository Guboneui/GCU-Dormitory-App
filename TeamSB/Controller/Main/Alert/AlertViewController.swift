//
//  AlertViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/08/14.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class AlertViewController: UIViewController {

    var currentPage = 0
    var isLoadedAllData = false
    var loading: NVActivityIndicatorView!
    
    var alertPost: [AlertContent] = []
    
    lazy var datamanager: AlertDataManager = AlertDataManager(view: self)
    
    @IBOutlet weak var mainTableView: UITableView!
    var readAllButton: UIBarButtonItem!
    var backButton: UIBarButtonItem!
    
    var postDetail: [DetailContent] = []
    
    override func loadView() {
        super.loadView()
        setLoading()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "AlertTableViewCell", bundle: nil), forCellReuseIdentifier: "AlertTableViewCell")
        mainTableView.refreshControl = UIRefreshControl()
        mainTableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        mainTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        let param = UserAlertRequest(curUser: UserDefaults.standard.string(forKey: "userID")!)
        datamanager.postUserNotification(param, viewController: self, page: currentPage)
        
        readAllButton = UIBarButtonItem(title: "모두 읽기", style: .plain, target: self, action: #selector(readAll))
        readAllButton.tintColor = UIColor.SBColor.SB_BaseYellow
        self.navigationItem.rightBarButtonItem = readAllButton
        
        backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backButtonAction))
        backButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backButton.tintColor = .black

        navigationItem.leftBarButtonItem = backButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "알림"
        
    }
    @objc func refreshData() {
        print(">> 상단 새로고침")
        currentPage = 0
        self.isLoadedAllData = false
        alertPost.removeAll()
        mainTableView.reloadData()
        let param = UserAlertRequest(curUser: UserDefaults.standard.string(forKey: "userID")!)
        datamanager.postUserNotification(param, viewController: self, page: currentPage)
        
    }
    
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
    
    @objc func readAll() {
        let param = ReadAllNoticeRequest(curUser: UserDefaults.standard.string(forKey: "userID")!)
        datamanager.postReadAllNotice(param, viewController: self)
    }
    
    
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension AlertViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alertPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertTableViewCell", for: indexPath) as! AlertTableViewCell
        
        if indexPath.row == alertPost.count - 1 {
            let param = UserAlertRequest(curUser: UserDefaults.standard.string(forKey: "userID")!)
            datamanager.postUserNotification(param, viewController: self, page: currentPage)
        }
        
        let data = alertPost[indexPath.row]
        var alertText = "\(data.nickname)\(data.title). \"\(data.content)\""
        
        
        cell.userAlertTextLabel.text = alertText
        
        
        let attributedString = NSMutableAttributedString(string: cell.userAlertTextLabel.text!)
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 13), range: (cell.userAlertTextLabel.text! as NSString).range(of: data.nickname))
        
        cell.userAlertTextLabel.attributedText = attributedString
        
        
        let formatter        = DateFormatter()
        formatter.locale     = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var time = data.timeStamp
        //현재 시간 값을 받아옴
        let today: String = formatter.string(from: Date())
        
        let nowDay = today.substring(from: 0, to: 10)
        let nowHour = Int(today.substring(from: 11, to: 13))!
        let nowMinute = Int(today.substring(from: 14, to: 16))!
        
        let articleDay = time.substring(from: 0, to: 10)
        let articleHour = Int(time.substring(from: 11, to: 13))!
        let articleMinute = Int(time.substring(from: 14, to: 16))!
        
        let totalArticleTime = articleHour * 60 + articleMinute
        let totalNowTime = nowHour * 60 + nowMinute
        
        var timeText = ""
        
        if nowDay == articleDay {
            if totalNowTime - totalArticleTime < 60 {
                timeText = "\((totalNowTime - totalArticleTime) % 60)분 전"
                    
            } else {
                
                timeText = "\(time.substring(from: 11, to: 16))"
            }
        } else {
            timeText = "\(time.substring(from: 5, to: 10))"
        }
        
        
        
        
        cell.alertTimeLabel.text = timeText
        
        
        let userProfileImage = data.imageSource.toImage()
        cell.userProfileImage.image = userProfileImage
        
        
        
        if data.check_read == true {
            cell.contentView.backgroundColor = .white
        } else {
            cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.9764705882, blue: 0.8862745098, alpha: 1)
        }
        
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        alertPost[indexPath.row].check_read = true  //내 배열
        mainTableView.reloadData()
        let param = ReadNoticeRequest(curUser: UserDefaults.standard.string(forKey: "userID")!, notification_no: alertPost[indexPath.row].notification_no)
        datamanager.postReadNotice(param, viewController: self)
        
        

       //let data = allPost[indexPath.row]
        let paramA = ExistsArticleRequest(no: alertPost[indexPath.row].article_no)

        datamanager.postExist(paramA, viewController: self)
        
        
    }
    
}

extension AlertViewController: AlertView {
    func reloadTableview() {
//        currentPage = 0
//        self.isLoadedAllData = false
//        alertPost.removeAll()
//        mainTableView.reloadData()
//        let param = UserAlertRequest(curUser: UserDefaults.standard.string(forKey: "userID")!)
//        datamanager.postUserNotification(param, viewController: self, page: currentPage)
        
        
        for i in 0..<alertPost.count {
            
            alertPost[i].check_read = true
            
        }
        
        
        mainTableView.reloadData()
        
        
        
    }
    
    func stopRefreshControl() {
        self.mainTableView.refreshControl?.endRefreshing()
    }
    
    func startLoading() {
        self.loading.startAnimating()
    }
    
    func stopLoading() {
        self.loading.stopAnimating()
    }
    
    func goArticle(no: Int, title: String, category: String, timeStamp: String, userNickname: String, text: String, viewCount: Int, userId: String, hash: [String], imageSource: String) {
        let storyBoard = UIStoryboard(name: "In_Post", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailPostViewController") as! DetailPostViewController
        
        vc.getPostNumber = no
        vc.getTitle = title
        vc.getCategory = category
        vc.getTime = timeStamp
        vc.getNickname = userNickname
        vc.getContents = text
        vc.getShowCount = viewCount
        vc.getUserID = userId
        //vc.delegate = self
        vc.getHash = hash
        vc.getImage = imageSource 
        vc.getMainTitle = category
        
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
}
