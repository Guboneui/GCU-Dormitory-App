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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allPostTableView.delegate = self
        allPostTableView.dataSource = self
        let allPostTableViewNib = UINib(nibName: "AllPostTableViewCell", bundle: nil)
        allPostTableView.register(allPostTableViewNib, forCellReuseIdentifier: "AllPostTableViewCell")
       
        allPostTableView.rowHeight = 120
        
        allPostTableView.refreshControl = UIRefreshControl()
        allPostTableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func refreshData() {
        print(">> 상단 새로고침")
        currentPage = 0
        self.isLoadedAllData = false
        saveAllData.removeAll()
        allPostTableView.reloadData()
        getAllPost(page: currentPage)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "게시글"
        getAllPost(page: currentPage)
    }
    
    
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
                    print(error)
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
        
        
        cell.titleLabel.text = data["title"] as! String
        cell.timeLabel.text = data["timeStamp"] as! String
        cell.contentsLabel.text = data["text"] as! String

        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (allPostTableView.contentSize.height - 100 - scrollView.frame.size.height) {
            getAllPost(page: currentPage)
        }
    }
    
}
