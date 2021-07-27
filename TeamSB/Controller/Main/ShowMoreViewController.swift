//
//  ShowMoreViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import Alamofire

class ShowMoreViewController: UIViewController {
    
    
    @IBOutlet weak var allPostTableView: UITableView!
    
    var saveAllData = [Any]()
    var requestPage = 0
    var currentPage = 0
    var isLoadedAllData = false
    
    var writeButton: UIBarButtonItem!
    var searchButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setNavigationBarItem()
      
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getAllPost(page: currentPage)
        navigationItemUse()
        
    }
    
//MARK: -기본 UI 함수
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
    
//MARK: -스토리보드 Action 함수
    @objc func refreshData() {
        print(">> 상단 새로고침")
        currentPage = 0
        self.isLoadedAllData = false
        saveAllData.removeAll()
        allPostTableView.reloadData()
        getAllPost(page: currentPage)
        
    }
    
    @objc func goWriteView() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WriteViewController") as! WriteViewController
        vc.delegate = self
        
        writeButton.isEnabled = false
        searchButton.isEnabled = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goSearchView() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        writeButton.isEnabled = false
        searchButton.isEnabled = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
//MARK: -API
    func getAllPost(page: Int) {
        
        currentPage += 1
        
        guard
            isLoadedAllData == false
        else {
            return
        }
        
        let URL = "http://13.209.10.30:3000/home/all?page=\(currentPage)"
        let alamo = AF.request(URL, method: .get, parameters: nil).validate(statusCode: 200...500)
        
        alamo.responseJSON { [self] (response) in
            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    print(">> \(URL)")
                    print(">> 모든 게시글 API 호출 성공")
                    
                    allPostTableView.refreshControl?.endRefreshing()
                    
                    let result = jsonObj.object(forKey: "check") as! Bool
                    if result == true {
                        let message = jsonObj.object(forKey: "message") as! String
                        print(">> \(message)")
                        let content = jsonObj.object(forKey: "content") as! NSArray
                        
                        guard content.count > 0 else {
                            print(">> 더이상 읽어올 게시글 없음")
                            print(">> 총 읽어온 게시글 개수 = \(saveAllData.count)")
                            self.isLoadedAllData = true
                            return
                        }
                        
                        
                        for i in 0..<content.count {
                            saveAllData.append(content[i])
                        }
                        print(">> \(URL)")
                        print(">> 읽어온 게시글의 개수: \(content.count), 현재 페이지\(page+1)")
                        allPostTableView.reloadData()
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


extension ShowMoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return saveAllData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllPostTableViewCell", for: indexPath) as! AllPostTableViewCell
        
        let data = saveAllData[indexPath.row] as! NSDictionary
        
        
        let category = data["category"] as! String
        if category == "delivery" {
            cell.categoryLabel.text = "배달"
        } else if category == "parcel" {
            cell.categoryLabel.text = "택배"
        } else if category == "taxi" {
            cell.categoryLabel.text = "택시"
        } else if category == "laundry" {
            cell.categoryLabel.text = "빨래"
        } else {
            cell.categoryLabel.text = "error"
        }
        
        
        cell.titleLabel.text = data["title"] as? String
        cell.timeLabel.text = data["timeStamp"] as? String
        cell.contentsLabel.text = data["text"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailPostViewController") as! DetailPostViewController
        
        let data = saveAllData[indexPath.row] as! NSDictionary
        
        vc.getPostNumber = data["no"] as! Int
        vc.getTitle = data["title"] as! String
        vc.getCategory = data["category"] as! String
        vc.getTime = data["timeStamp"] as! String
        vc.getNickname = data["userNickname"] as! String
        vc.getContents = data["text"] as! String
        vc.getShowCount = data["viewCount"] as! Int
        vc.getUserID = data["userId"] as! String
        
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (allPostTableView.contentSize.height - 50 - scrollView.frame.size.height) {
            getAllPost(page: currentPage)
        }
    }
}

extension ShowMoreViewController: UpdateData {
    func update() {
        currentPage = 0
        isLoadedAllData = false
        saveAllData = []
        getAllPost(page: currentPage)
    }
}
