//
//  NoticeViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/02.
//

import UIKit
import ExpyTableView
import NVActivityIndicatorView

class NoticeViewController: UIViewController {

    @IBOutlet weak var mainTableView: ExpyTableView!
    
    var currentPage = 0
    var isLoadedAllData = false
    var currentNormalPage = 0
    var isLoadedAllNormalData = false
    var loading: NVActivityIndicatorView!
    
    var noticeArray: [TopNotice] = []
    
    lazy var dataManager: NoticeDataManager = NoticeDataManager(view: self)
    
    override func loadView() {
        super.loadView()
        setLoading()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.separatorStyle = .none
        mainTableView.register(UINib(nibName: "NoticeMainTableViewCell", bundle: nil), forCellReuseIdentifier: "NoticeMainTableViewCell")
        mainTableView.register(UINib(nibName: "NoticeSubTableViewCell", bundle: nil), forCellReuseIdentifier: "NoticeSubTableViewCell")
        mainTableView.refreshControl = UIRefreshControl()
        mainTableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        dataManager.getTopNotice(viewController: self, page: currentPage)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "공지사항"
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
    
    @objc func refreshData() {
        print(">> 상단 새로고침")
        currentPage = 0
        self.isLoadedAllData = false
        currentNormalPage = 0
        isLoadedAllNormalData = false
        noticeArray.removeAll()
        mainTableView.reloadData()
        dataManager.getTopNotice(viewController: self, page: currentPage)
    }
    

}


extension NoticeViewController: ExpyTableViewDelegate, ExpyTableViewDataSource {
    //델리게이트
    //열리고 닫히고 상태가 변경될 떄
    func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
        switch state {
        case .willExpand:
            print("")
        case .willCollapse:
            print("")
        case .didExpand:
            print("")
        case .didCollapse:
            print("")
        }
    }
    
    
    //데이터 소스
    func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
        return true
    }
    
    //헤더뷰 (펼치는 섹션)
    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeMainTableViewCell") as! NoticeMainTableViewCell
        
        cell.selectionStyle = .none
        
        let data = noticeArray[section]
        cell.titleLabel.text = data.title
        
        
        let year = data.timeStamp.substring(from: 2, to: 4)
        let month = data.timeStamp.substring(from: 5, to: 7)
        let day = data.timeStamp.substring(from: 8, to: 10)
        
        let date = "\(year)/\(month)/\(day)"
        
        
        
        cell.timeLabel?.text = date
        
        
        
        
        if data.fixTop == true {
            cell.topStateImage.image = UIImage(named: "pin")
        } else {
            cell.topStateImage.image = UIImage(named: "")
        }

        if section == noticeArray.count - 1 {
            
            if isLoadedAllData == false {
                dataManager.getTopNotice(viewController: self, page: currentPage)
            } else {
                dataManager.getNormalNotice(viewController: self, page: currentNormalPage)
            }
        }
       
        
        return cell
    }
    
    //각 섹션에 들어갈 로우의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeSubTableViewCell") as! NoticeSubTableViewCell
        let data = noticeArray[indexPath.section]
        cell.subTitleLabel.text = data.title
        cell.contentsLabel.text = data.content
        
        
        
       
        return cell
    }
    
    //섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return noticeArray.count
    }
    
}


extension NoticeViewController: NoticeView {
    func reloadTableView() {
        self.mainTableView.reloadData()
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
    
    func goArticle() {
    }
    
}
