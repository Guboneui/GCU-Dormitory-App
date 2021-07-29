//
//  DelevaryViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class DeleveryViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    var writeButton: UIBarButtonItem!
    var searchButton: UIBarButtonItem!
    var loading: NVActivityIndicatorView!

    lazy var dataManager: DeleveryDataManager = DeleveryDataManager(view: self)
    var deleveryPost: [Delevery] = []
    var currentPage = 0
    var isLoadedAllData = false
    
//MARK: -생명주기
    override func loadView() {
        super.loadView()
        setLoading()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setNavigationBarItem()
        dataManager.getAllPost(viewController: self, page: currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItemUse()
    }
}
//MARK: -기본 UI 함수
extension DeleveryViewController {
   
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
    
    
    func setNavigationBarItem() {
        self.navigationItem.title = "배달"
        self.tabBarController?.tabBar.isHidden = true
        writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(goWriteView))
        writeButton.tintColor = .black
        searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(goSearchView))
        searchButton.imageInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        searchButton.tintColor = .black
        
        navigationItem.rightBarButtonItems = [writeButton, searchButton]
        
    }
    
    func navigationItemUse() {
        writeButton.isEnabled = true
        searchButton.isEnabled = true
    }
    
    func setTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        let mainTableViewNib = UINib(nibName: "DeleveryTableViewCell", bundle: nil)
        mainTableView.register(mainTableViewNib, forCellReuseIdentifier: "DeleveryTableViewCell")
        
        mainTableView.refreshControl = UIRefreshControl()
        mainTableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }

}

//MARK: -스토리보드 Action 함수
extension DeleveryViewController {
    @objc func refreshData() {
        print(">> 상단 새로고침")
        currentPage = 0
        self.isLoadedAllData = false
        deleveryPost.removeAll()
        mainTableView.reloadData()
        dataManager.getAllPost(viewController: self, page: currentPage)
        
    }
    
    @objc func goWriteView() {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WriteViewController") as! WriteViewController
        
        vc.delegate = self
        vc.getCategory = "배달"
        
        writeButton.isEnabled = false
        searchButton.isEnabled = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goSearchView() {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        writeButton.isEnabled = false
        searchButton.isEnabled = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: -tableview 세팅
extension DeleveryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deleveryPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeleveryTableViewCell", for: indexPath) as! DeleveryTableViewCell
        
        if deleveryPost.count != 0 {
            let data = deleveryPost[indexPath.row]
            
            cell.titleLabel.text = data.title
            cell.timeLabel.text = data.timeStamp
            cell.contentsLabel.text = data.text
            
            var hashString = ""
            
            let hashData = data.hash
            
            for i in 0..<hashData.count {
                hashString += "#" + "\(hashData[i]) "
            }
            
            cell.tagLabel.text = hashString
            
        } else {
            cell.titleLabel.text = ""
            cell.timeLabel.text = ""
            cell.contentsLabel.text = ""
            cell.tagLabel.text = ""
        }
        
        cell.selectionStyle = .none
        
        if indexPath.row == deleveryPost.count - 1 {
            dataManager.getAllPost(viewController: self, page: currentPage)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "In_Post", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailPostViewController") as! DetailPostViewController
        
        let data = deleveryPost[indexPath.row]
        
        vc.getPostNumber = data.no
        vc.getTitle = data.title
        vc.getCategory = data.category
        vc.getTime = data.timeStamp
        vc.getNickname = data.userNickname
        vc.getContents = data.text
        vc.getShowCount = data.viewCount
        vc.getUserID = data.userId
        
        //vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//
//        if offsetY > contentHeight - scrollView.frame.height {
//            getDelivary(page: currentPage)
//        }
//    }
}

//MARK: -UpdateData 프로토콜 연결 함수
extension DeleveryViewController: UpdateData {
    func update() {
        mainTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        currentPage = 0
        isLoadedAllData = false
        deleveryPost.removeAll()
        dataManager.getAllPost(viewController: self, page: currentPage)
    }
}

//MARK: -DataManager 연결 함수
extension DeleveryViewController: DeleveryView {
    func stopRefreshControl() {
        self.mainTableView.refreshControl?.endRefreshing()
    }
    func startLoading() {
        self.loading.startAnimating()
    }
    func stopLoading() {
        self.loading.stopAnimating()
    }
}
