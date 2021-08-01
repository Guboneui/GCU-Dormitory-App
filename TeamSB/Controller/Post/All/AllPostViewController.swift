//
//  ShowMoreViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class ShowMoreViewController: UIViewController {

    @IBOutlet weak var allPostTableView: UITableView!
    var writeButton: UIBarButtonItem!
    var searchButton: UIBarButtonItem!
    var loading: NVActivityIndicatorView!
    
    lazy var dataManager: AllPostDataManager = AllPostDataManager(view: self)
    var allPost: [AllPost] = []
    var currentPage = 0
    var isLoadedAllData = false
    
    var cellIdx: Int?
    
    
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
extension ShowMoreViewController {
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
    
    
    func setTableView() {
        allPostTableView.delegate = self
        allPostTableView.dataSource = self
        let allPostTableViewNib = UINib(nibName: "AllPostTableViewCell", bundle: nil)
        allPostTableView.register(allPostTableViewNib, forCellReuseIdentifier: "AllPostTableViewCell")
        allPostTableView.rowHeight = 120
        allPostTableView.refreshControl = UIRefreshControl()
        allPostTableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    func setNavigationBarItem() {
        self.navigationItem.title = "게시글"
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
    
}

//MARK: -스토리보드 Action 함수
extension ShowMoreViewController {
    
    @objc func refreshData() {
        print(">> 상단 새로고침")
        currentPage = 0
        self.isLoadedAllData = false
        allPost.removeAll()
        allPostTableView.reloadData()
        dataManager.getAllPost(viewController: self, page: currentPage)
    }
    
    @objc func goWriteView() {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WriteViewController") as! WriteViewController
        
        vc.delegate = self
        
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

//MARK: -tableView 세팅
extension ShowMoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllPostTableViewCell", for: indexPath) as! AllPostTableViewCell
        
        
        if allPost.count != 0 {
            let data = allPost[indexPath.row]

            cell.categoryLabel.text = data.category
            cell.titleLabel.text = data.title
            cell.timeLabel.text = data.timeStamp
            cell.contentsLabel.text = data.text
            
        } else {
            cell.titleLabel.text = ""
            cell.timeLabel.text = ""
            cell.contentsLabel.text = ""
        }
        
        cell.selectionStyle = .none
        
        if indexPath.row == allPost.count - 1 {
            dataManager.getAllPost(viewController: self, page: currentPage)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cellIdx = indexPath.row
        
        let data = allPost[indexPath.row]
        let param = ExistsArticleRequest(no: data.no)
    
        dataManager.postExist(param, viewController: self)

    }

}

//MARK: -UpdateData 프로토콜
extension ShowMoreViewController: UpdateData {
    func update() {
        allPostTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        currentPage = 0
        isLoadedAllData = false
        allPost.removeAll()
        dataManager.getAllPost(viewController: self, page: currentPage)
    }
}

//MARK: -삭제 했을 경우 새로 고침
extension ShowMoreViewController: WhenDismissDetailView {
    func reloadView() {
        currentPage = 0
        isLoadedAllData = false
        allPost.removeAll()
        
        dataManager.getAllPost(viewController: self, page: currentPage)
    }
    
    
    
}

//MARK: -DataManager 연결 함수
extension ShowMoreViewController: AllPostView {
    func stopRefreshControl() {
        self.allPostTableView.refreshControl?.endRefreshing()
    }
    
    func startLoading() {
        self.loading.startAnimating()
    }
    func stopLoading() {
        self.loading.stopAnimating()
    }
    
    func goArticle() {
        let storyBoard = UIStoryboard(name: "In_Post", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailPostViewController") as! DetailPostViewController
        
        let data = allPost[cellIdx!]
        
        vc.getPostNumber = data.no
        vc.getTitle = data.title
        vc.getCategory = data.category
        vc.getTime = data.timeStamp
        vc.getNickname = data.userNickname
        vc.getContents = data.text
        vc.getShowCount = data.viewCount
        vc.getUserID = data.userId
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
